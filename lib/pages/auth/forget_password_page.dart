import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/widgets/app_non_border_text_input.dart';
import '../../models/auth/forget_password_model.dart';
import '../../repositories/user_repository.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../widgets/common.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final userRepository = UserRepository();
  FocusNode focusNode = FocusNode();
  bool buttonActive = false;
  bool isSecurePass = true;
  bool isSecureConfirmPass = true;
  bool isShowBtnLoading = false;
  bool isError = false;
  String errorText = '';
  late ForgetPasswordModel model;

  @override
  void initState() {
    super.initState();
    var argument = Get.arguments;
    if (argument != null) {
      if (argument is ForgetPasswordModel) {
        model = argument;
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
              cText(S.current.reset_password, fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
              Gaps.vGap16,
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
              AppNonBorderTextInput(
                isRequiredField: true,
                onTextChanged: (text) {
                  checkEnableButton();
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
                  checkEnableButton();
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

  void checkEnableButton() {
    setState(() {
      buttonActive = (passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) &&
          (passwordController.text == confirmPasswordController.text)
          ? true
          : false;
    });
  }

  /// request forget password
  void onClickNextButton() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        isError = true;
        errorText = S().password_not_match;
      });
    } else {
      setState(() {
        isError = false;
        isShowBtnLoading = true;
      });
      try {
        var response = model.isPhone ?
        await userRepository.forgetPassByPhone(
            password: passwordController.text.removeAllWhitespace,
            verifyUuid: model.verifyUuid,
            phone: model.phone
        )
        :
        await userRepository.forgetPassByEmail(
            password: passwordController.text.removeAllWhitespace,
            verifyUuid: model.verifyUuid,
            email: model.phone
        );
        if (response != null) {
          /// success
          NavigatorUtils.jump(AppModuleRoute.loginByEmailPage);
        }
      } catch (error) {
        print(error);
      } finally {
        setState(() {
          isShowBtnLoading = false;
        });
      }
    }
  }
}
