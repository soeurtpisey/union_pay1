import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/widgets/app_non_border_text_input.dart';
import '../../http/net/http_exceptions.dart';
import '../../repositories/user_repository.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../widgets/common.dart';
import '../home/home_page.dart';

class LoginByEmailPage extends StatefulWidget {

  @override
  State<LoginByEmailPage> createState() => _LoginByEmailPageState();
}

class _LoginByEmailPageState extends State<LoginByEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final userRepository = UserRepository();
  FocusNode focusNode = FocusNode();
  String selectedCode = '855';
  bool showPhoneNumberClear = false;
  bool buttonActive = false;
  bool isSecurePass = true;
  bool isSecureConfirmPass = true;
  bool isShowBtnLoading = false;
  bool isError = false;
  String errorMessage = '';

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
                            errorMessage,
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
              AppNonBorderTextInput(
                isRequiredField: true,
                onTextChanged: (text) {
                  checkEnableRegisterButton();
                },
                controller: emailController,
                hint: S.current.email,
                keyboardType: TextInputType.text,
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
              const SizedBox(height: 8),
              /// forget password
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            NavigatorUtils.jump(AppModuleRoute.resetPasswordOtpPage, arguments: false);
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

  void onClickNextButton() async {
      setState(() {
        isShowBtnLoading = true;
      });
      try {
        var response = await userRepository.loginWithEmail(
            email: emailController.text.removeAllWhitespace,
            password: passwordController.text.removeAllWhitespace);
        if (response != null) {
          /// success -> go to home page
          Get.to(HomePage());
        } else {
          setState(() {
            isShowBtnLoading = false;
            isError = true;
          });
        }
      } catch (error) {
        if (error is UnknownException) {
          if (error.status == 'PWD_ERROR') {
            errorMessage = S().password_incorrect;
          } else if (error.status == 'ACCOUNT_NOT_FOUND') {
            errorMessage = S().account_not_exits;
          } else {
            errorMessage = error.message;
          }
        }
        setState(() {
          isShowBtnLoading = false;
          isError = true;
        });
      } finally {
        setState(() {
          isShowBtnLoading = false;
        });
      }
    }
}
