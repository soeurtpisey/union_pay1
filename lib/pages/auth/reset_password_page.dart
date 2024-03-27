import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../../route/base_route.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../widgets/app_input_textfield.dart';
import '../../widgets/common.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  FocusNode focusNode = FocusNode();
  bool buttonActive = false;
  bool isSecurePass = true;
  bool isSecureConfirmPass = true;
  bool isShowBtnLoading = false;

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
              cText(S.current.reset_password, fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
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
      buttonActive = (passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) &&
          (passwordController.text != confirmPasswordController.text)
          ? true
          : false;
    });
  }

  void onClickNextButton() {
    if (passwordController.text != confirmPasswordController.text) {
      // NavigatorUtils.pushVerifyCode(sendTo: emailController.text);
    }
  }
}
