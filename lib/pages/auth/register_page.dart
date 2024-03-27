import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/pages/auth/register_by_email_page.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../widgets/app_input_textfield.dart';
import '../../widgets/common.dart';
import '../../widgets/prefix_icon.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 32),
          Visibility(
            visible: isError,
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: const BoxDecoration(
                      color: AppColors.colorF8D6D8,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Image.asset(ImagesRes.PHONE_NUM_ERROR)
                    ),
                    cText(errorText,
                      color: AppColors.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    )
                  ],),
                ),
                const SizedBox(height: 16)
              ],
            ),
          ),
          TextFormField(
            focusNode: focusNode,
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            cursorColor: AppColors.colorE40C19,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              ),
              FilteringTextInputFormatter.deny(
                RegExp(
                    r'^0+'), //users can't type 0 at 1st position
              ),
            ],
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(6.0), // Adjust the radius as needed
                ),
                prefixIcon: PrefixIcon(
                    paddingLeft: 10,
                    paddingRight: 27.0,
                    icon:
                    Icons.keyboard_arrow_down_sharp,
                    prefixFontSize: 16.0,
                    iconColor: AppColors.primaryColor,
                    content: '+' + selectedCode + ' ',
                    onTap: () {}),

                suffixIcon: showPhoneNumberClear ? IconButton(
                  onPressed: () {
                    phoneNumberController.clear();
                    showPhoneNumberClear = false;
                    checkEnableRegisterButton();
                  },
                  icon: const Icon(Icons.close, size: 22, color: AppColors.color79767D),
                ) : null,
                hintText: 'phone number',
                hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color79747E)),
            onEditingComplete: buttonActive
                ? () => onClickRegisterButton()
                : null,
            onChanged: (value) {
              showPhoneNumberClear = value.isNotEmpty;
              checkEnableRegisterButton();
            },
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
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
                  overlayColor: MaterialStateProperty.all(
                      Colors.transparent)),
              icon: isSecurePass ?
              Image.asset(ImagesRes.HIDE_EYE) :
              Image.asset(ImagesRes.SHOW_EYE),
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
                  overlayColor: MaterialStateProperty.all(
                      Colors.transparent)),
              icon: isSecureConfirmPass ?
              Image.asset(ImagesRes.HIDE_EYE) :
              Image.asset(ImagesRes.SHOW_EYE),
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
              title: S.current.register,
              margin: EdgeInsets.zero,
              backgroundColor: buttonActive
                  ? AppColors.primaryColor
                  : AppColors.color80E60013,
              onTap: buttonActive
                  ? () => onClickRegisterButton()
                  : null)
              .intoContainer(
              color: AppColors.background,
              margin: const EdgeInsets.only(top: 24.0),
              height: 42.0),
          btnWithLoading(
              isLoading: isShowBtnLoading,
              title: S.current.register_by_email,
              margin: EdgeInsets.zero,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onTap: () {
                Get.to(RegisterByEmailPage());
              })
              .intoContainer(
              color: AppColors.background,
              margin: const EdgeInsets.only(top: 24.0),
              height: 42.0),
        ],),
      ),
    );
  }

  void checkEnableRegisterButton() {
    setState(() {
      buttonActive = (phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) ? true : false;
    });
  }

  void onClickRegisterButton() {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        isError = true;
        errorText = S().password_not_match;
      });
    }

  }


}