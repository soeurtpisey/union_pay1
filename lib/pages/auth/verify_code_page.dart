import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:union_pay/models/auth/email_verify_model.dart';
import 'package:union_pay/models/auth/phone_verify_model.dart';
import 'package:union_pay/repositories/user_repository.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../utils/count_down.dart';
import '../../widgets/common.dart';

class VerifyCodePage extends StatefulWidget {
  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final FocusNode pinPutFocusNode = FocusNode();
  TextEditingController pinPutController = TextEditingController();
  int timeout = 60;
  CountDown? cd;
  StreamSubscription? sub;
  bool hasError = false;
  String errorMessage = '';
  bool isSuccessVerify = false;
  String sendTo = '';
  String pass = '';

  @override
  void initState() {
    super.initState();
    var arguments = Get.arguments;
    if (arguments != null) {
      if (arguments is PhoneVerifyModel) {
        sendTo = arguments.phone;
        pass = arguments.password;
      } else if (arguments is EmailVerifyModel) {
        sendTo = arguments.email;
        pass = arguments.password;
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
              cText(S.current.enter_code_we_have_sent(sendTo),
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
                    onSubmitPinCode();
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

  void resendSmsCode() {
    startTimer();
  }

  void onSubmitPinCode() {

  }

  PinTheme setPinStyle() {
    var underlineColor = Colors.black;
    if (hasError) {
      if (pinPutController.text.length == 4) {
        underlineColor = Colors.black;
      } else {
        underlineColor = Colors.red;
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
}
