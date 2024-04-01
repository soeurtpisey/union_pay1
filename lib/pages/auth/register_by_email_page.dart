import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/models/auth/email_verify_model.dart';
import '../../repositories/user_repository.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../widgets/app_input_textfield.dart';
import '../../widgets/common.dart';

class RegisterByEmailPage extends StatefulWidget {
  @override
  State<RegisterByEmailPage> createState() => _RegisterByEmailPageState();
}

class _RegisterByEmailPageState extends State<RegisterByEmailPage> {
  final TextEditingController emailController = TextEditingController();
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
              cText(S.current.enter_your_email, fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),

              cText(S.current.enter_email_will_send_otp, fontSize: 16, color: Colors.black.withOpacity(0.45)),
              const SizedBox(height: 30),
              Visibility(
                visible: isError,
                child: Column(
                  children: [
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
                    const SizedBox(height: 16)
                  ],
                ),
              ),
              AppTextInput(
                isRequiredField: true,
                onTextChanged: (text) {
                  checkEnableRegisterButton();
                },
                controller: emailController,
                hint: S.current.email,
                keyboardType: TextInputType.text,
              ),
              Gaps.vGap16,
              AppTextInput(
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
              AppTextInput(
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
      buttonActive = (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty &&
              confirmPasswordController.text.isNotEmpty)
          ? true
          : false;
    });
  }

  void verifyEmail() async {
    try {
      var response = await userRepository.emailVerify(email: emailController.text);
      if (response != null) {
        NavigatorUtils.jump(AppModuleRoute.verifyCodePage,
            arguments: EmailVerifyModel(email: emailController.text, password: passwordController.text, isForgetPass: false));
      }
    } catch (error) {
      print(error);
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
