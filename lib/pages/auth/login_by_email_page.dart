import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/models/auth/email_verify_model.dart';
import 'package:union_pay/models/auth/phone_verify_model.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../widgets/app_input_textfield.dart';
import '../../widgets/common.dart';

class LoginByEmailPage extends StatefulWidget {

  @override
  State<LoginByEmailPage> createState() => _LoginByEmailPageState();
}

class _LoginByEmailPageState extends State<LoginByEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String selectedCode = '855';
  bool showPhoneNumberClear = false;
  bool buttonActive = false;
  bool isSecurePass = true;
  bool isSecureConfirmPass = true;
  bool isShowBtnLoading = false;
  bool isError = false;
  String errorText = '';

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
              const SizedBox(height: 8),
              /// forget password
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            NavigatorUtils.jump(AppModuleRoute.verifyCodePage, arguments: EmailVerifyModel(emailController.text, passwordController.text));
                          },
                          child: cText(S().forget_password, fontSize: 15, color: AppColors.primaryColor, textAlign: TextAlign.right)
                      )
                  )
                ],),
              Gaps.vGap16,
              btnWithLoading(
                  isLoading: isShowBtnLoading,
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
          passwordController.text.isNotEmpty)
          ? true
          : false;
    });
  }

  void onClickNextButton() {
    if (passwordController.text != '1234') {
      setState(() {
        isError = true;
        errorText = S().password_not_match;
      });
    } else {
      NavigatorUtils.jump(AppModuleRoute.verifyCodePage, arguments: EmailVerifyModel(emailController.text, passwordController.text));
    }
  }
}
