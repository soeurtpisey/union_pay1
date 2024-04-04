import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/http/net/dio_new.dart';
import 'package:union_pay/models/auth/email_register_model.dart';
import 'package:union_pay/utils/encrypt_util.dart';
import 'package:union_pay/widgets/app_non_border_text_input.dart';
import '../../repositories/user_repository.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../widgets/common.dart';
import '../home/home_page.dart';

class RegisterByEmailPage extends StatefulWidget {
  @override
  State<RegisterByEmailPage> createState() => _RegisterByEmailPageState();
}

class _RegisterByEmailPageState extends State<RegisterByEmailPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final userRepository = UserRepository();
  FocusNode focusNode = FocusNode();
  bool buttonActive = false;
  bool isSecurePass = true;
  bool isSecureConfirmPass = true;
  bool isError = false;
  String errorText = '';
  bool isLoading = false;
  late EmailRegisterModel registerModel;

  @override
  void initState() {
    super.initState();
    var arguments = Get.arguments;
    if (arguments != null) {
      if (arguments is EmailRegisterModel) {
        registerModel = arguments;
      }
    }
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
              cText(S.current.set_password, fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
              Visibility(
                visible: isError,
                child: Column(
                  children: [
                    Gaps.vGap16,
                    Container(
                      height: 48,
                      decoration: const BoxDecoration(
                          color: AppColors.colorF8D6D8,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 8),
                              child: Image.asset(ImagesRes.PHONE_NUM_ERROR)),
                          cText(
                            errorText,
                            color: AppColors.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.vGap16,
              AppNonBorderTextInput(
                isRequiredField: true,
                onTextChanged: (text) {
                  checkEnableRegisterButton();
                },
                controller: passwordController,
                hint: S.current.password,
                securedTextEntry: isSecurePass,
                keyboardType: TextInputType.text,
                suffixIcon: TextButton.icon(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  icon: isSecurePass
                      ? Image.asset(ImagesRes.HIDE_EYE)
                      : Image.asset(ImagesRes.SHOW_EYE),
                  onPressed: () {
                    setState(() {
                      isSecurePass = !isSecurePass;
                    });
                  },
                  label: const Text(''),
                ),
              ),
              Gaps.vGap16,
              AppNonBorderTextInput(
                isRequiredField: true,
                onTextChanged: (text) {
                  checkEnableRegisterButton();
                },
                controller: confirmPasswordController,
                hint: S.current.confirm_password,
                securedTextEntry: isSecureConfirmPass,
                keyboardType: TextInputType.text,
                suffixIcon: TextButton.icon(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  icon: isSecureConfirmPass
                      ? Image.asset(ImagesRes.HIDE_EYE)
                      : Image.asset(ImagesRes.SHOW_EYE),
                  onPressed: () {
                    setState(() {
                      isSecureConfirmPass = !isSecureConfirmPass;
                    });
                  },
                  label: const Text(''),
                ),
              ),
              btnWithLoading(
                      isLoading: isLoading,
                      title: S.current.next,
                      margin: EdgeInsets.zero,
                      backgroundColor: buttonActive
                          ? AppColors.primaryColor
                          : AppColors.color80E60013,
                      onTap: buttonActive ? () => onClickNextButton() : null)
                  .intoContainer(
                      color: AppColors.background,
                      margin: const EdgeInsets.only(top: 24.0),
                      height: 42.0),
            ],
          ),
        ),
      ),
    );
  }

  void checkEnableRegisterButton() {
    setState(() {
      buttonActive = (passwordController.text.isNotEmpty &&
              confirmPasswordController.text.isNotEmpty)
          ? true
          : false;
    });
  }

  void verifyEmail() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      var response = await userRepository.registerWithEmail(
          email: registerModel.email,
          password: EncryptUtil.encodeMd5(passwordController.text.removeAllWhitespace).toString(),
          verifyUuid: registerModel.verifyUuid);
      if (response != null) {
        /// success -> go to home page
        Get.to(HomePage());
      }
    } catch (error) {
      if (error is UnknownException) {
        errorText = error.message;
        isError = true;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  void onClickNextButton() {
    if (isLoading) return;
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        isError = true;
        errorText = S().password_not_match;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      verifyEmail();
    }
  }
}
