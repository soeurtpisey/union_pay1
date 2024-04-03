import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:union_pay/http/net/dio_new.dart';
import 'package:union_pay/models/auth/email_verify_model.dart';
import 'package:union_pay/models/auth/phone_verify_model.dart';
import 'package:union_pay/pages/auth/register_by_email_page.dart';
import 'package:union_pay/pages/home/home_page.dart';
import 'package:union_pay/repositories/user_repository.dart';
import 'package:union_pay/utils/encrypt_util.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../models/auth/email_register_model.dart';
import '../../models/auth/forget_password_model.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../utils/count_down.dart';
import '../../widgets/common.dart';

class VerifyCodePage extends StatefulWidget {
  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final FocusNode pinPutFocusNode = FocusNode();
  final TextEditingController pinPutController = TextEditingController();
  final userRepository = UserRepository();
  int timeout = 60;
  CountDown? cd;
  StreamSubscription? sub;
  bool hasError = false;
  String errorMessage = '';
  bool isSuccessVerify = false;
  String sendTo = '';
  bool isLoading = false;
  bool isResetPassword = false;
  bool isPhoneNumber = false;

  @override
  void initState() {
    super.initState();
    var arguments = Get.arguments;
    if (arguments != null) {
      if (arguments is PhoneVerifyModel) {
        sendTo = arguments.phone;
        isResetPassword = arguments.isForgetPass;
        isPhoneNumber = true;
      } else if (arguments is EmailVerifyModel) {
        sendTo = arguments.email;
        isResetPassword = arguments.isForgetPass;
        isPhoneNumber = false;
      }
    }
    startTimer();
  }

  @override
  void dispose() {
    pinPutController.dispose();
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              cText(S.current.verify_code,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              cText( isPhoneNumber ? S.current.enter_code_we_have_sent_to_phone(sendTo) : S.current.enter_code_we_have_sent(sendTo),
                  fontSize: 16, color: Colors.black.withOpacity(0.45)),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal:
                        (MediaQuery.of(context).size.width - (50 + (42 * 4))) /
                            2),
                child: Pinput(
                  closeKeyboardWhenCompleted: false,
                  enableSuggestions: false,
                  useNativeKeyboard: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  cursor: Container(
                      height: 25, width: 2, color: AppColors.primaryColor),
                  autofocus: true,
                  length: 4,
                  validator: (v) {
                    isResetPassword ?
                    verifyOTPForResetPassword()
                    :
                    verifyOTPForRegisterByEmail();
                  },
                  focusNode: pinPutFocusNode,
                  controller: pinPutController,
                  submittedPinTheme: setPinStyle(),
                  defaultPinTheme: setPinStyle(),
                  focusedPinTheme: setPinStyle(),
                  forceErrorState: hasError ? true : false,
                  showCursor: true,
                ),
              ),
              Visibility(
                visible: hasError && errorMessage.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: cText(errorMessage, fontSize: 12, color: AppColors.colorF5222D),
                )
              ),
              isLoading ?
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                      height: 28.0,
                      width: 28.0,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorF5222D))),
                ),
              ) :
              /// resend
              Container(
                padding: EdgeInsets.only(top: hasError ? 10.0 : 16, bottom: 44),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    timeout == 0
                        ?
                    InkWell(
                      child: cText(S().resend,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor),
                      onTap: () {
                        setState(() {
                          hasError = false;
                        });
                        resendSmsCode();
                      },
                    )
                        :
                    cText(S().sms_resend(timeout), fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.45)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PinTheme setPinStyle() {
    var underlineColor = Colors.black;
    if (hasError) {
      if (pinPutController.text.length == 4) {
        underlineColor = Colors.red;
      } else {
        underlineColor = Colors.black;
      }
    } else if (pinPutController.text.length == 4 && isSuccessVerify == true) {
      underlineColor = AppColors.color00C958;
    } else {
      underlineColor = Colors.black;
    }
    return PinTheme(
        width: 42,
        height: 50,
        textStyle: const TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.w500, color: Colors.black),
        //GoogleFonts.poppins(fontSize: 30.0, fontWeight: FontWeight.w500, color: Colors.black),
        decoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(color: underlineColor, width: 3.0))));
  }

  void startTimer() {
    setState(() {
      timeout = 60;

      cd = CountDown(Duration(seconds: timeout));
      sub = cd?.stream?.listen(null);

      // start your countdown by registering a listener
      sub?.onData((dynamic d) {
        setState(() {
          if (d !=null) {
            timeout = (d as Duration).inSeconds;
          }
        });
      });

      // when it finish the onDone cb is called
      sub?.onDone(() {
        setState(() {
          timeout = 0;
        });
      });
    });
  }

  ///////////////////////// API Integrate /////////////////////////////

  void resendOTPForForgetPassword() async {
    try {
      var response = isPhoneNumber ?
      await userRepository.forgetPassSendOTPByPhone(phone: sendTo)
          :
      await userRepository.forgetPassSendOTPByEmail(email: sendTo)
      ;
      if (response != null) {
        /// success
        setState(() {
          timeout = 0;
          hasError = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void resendOTPForRegisterByEmail() async {
    try {
      var response = await userRepository.emailRegisterSendOTP(email: sendTo);
      if (response != null) {
        /// success
        setState(() {
          timeout = 0;
          hasError = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void resendSmsCode() {
    if (isResetPassword) {
      resendOTPForForgetPassword();
    } else {
      resendOTPForRegisterByEmail();
    }
    startTimer();
  }

  /// Request verify OTP for forget password by phone and by email
  void verifyOTPForResetPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = isPhoneNumber ?
      await userRepository.verifyOTPForgetPassByPhone(phone: sendTo, optCode: pinPutController.text)
          :
      await userRepository.verifyOTPForgetPassByEmail(email: sendTo, optCode: pinPutController.text);

      if (response != null) {
        /// success -> go to forget password page
        setState(() {
          timeout = 0;
        });
        NavigatorUtils.jump(AppModuleRoute.resetPasswordPage,
            arguments: ForgetPasswordModel(
              phone: sendTo,
              verifyUuid: response,
              isPhone: isPhoneNumber
            )
        );
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (error) {
      if (error is UnknownException) {
        if (error.status == 'OPT_CODE_ERROR') {
          errorMessage = S().incorrect_verify_code;
        } else {
          errorMessage = error.message;
        }
      }
      setState(() {
        isLoading = false;
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// verify OTP for register by email
  void verifyOTPForRegisterByEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await userRepository.emailRegisterVerifyOTP(email: sendTo, optCode: pinPutController.text);
      if (response != null) {
        /// success -> go to home page
        setState(() {
          timeout = 0;
        });
        NavigatorUtils.jump(AppModuleRoute.registerByEmailPage,
            arguments: EmailRegisterModel(email: sendTo, verifyUuid: response));

      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (error) {
      if (error is UnknownException) {
        if (error.status == 'OPT_CODE_ERROR') {
          errorMessage = S().incorrect_verify_code;
        } else if (error.status == 'EXIT_REGISTER') {
          errorMessage = S().email_already_exits;
        } else {
          errorMessage = error.message;
        }
      }
      setState(() {
        isLoading = false;
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
