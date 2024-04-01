import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/models/auth/phone_verify_model.dart';
import 'package:union_pay/pages/auth/login_by_email_page.dart';
import 'package:union_pay/pages/auth/select_country_code.dart';
import '../../http/net/http_exceptions.dart';
import '../../models/auth/email_verify_model.dart';
import '../../repositories/prepaid_repository.dart';
import '../../repositories/user_repository.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../res/images_res.dart';
import '../../utils/view_util.dart';
import '../../widgets/app_input_textfield.dart';
import '../../widgets/common.dart';
import '../../widgets/country_selection/code_country.dart';
import '../../widgets/prefix_icon.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();
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
  String errorText = '';
  List<CountryCode> listCountry = [];
  PrepaidRepository prepaidRepository = PrepaidRepository();

  @override
  void initState() {
    getRegions();
    super.initState();
  }

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
                    onTap: () {
                      showSheet(
                          context,
                          SelectCountryPage(
                            onResult:
                                (CountryCode value) {
                              setState(() {
                                selectedCode =
                                    (value.dialCode ??
                                        '')
                                        .substring(1);
                              });
                            },
                            regions: listCountry,
                          ));
                    }),

                suffixIcon: showPhoneNumberClear ? IconButton(
                  onPressed: () {
                    phoneNumberController.clear();
                    showPhoneNumberClear = false;
                    checkEnableLoginButton();
                  },
                  icon: const Icon(Icons.close, size: 22, color: AppColors.color79767D),
                ) : null,
                hintText: S().label_phone_number.toLowerCase(),
                hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color79747E)),
            onEditingComplete: buttonActive
                ? () => onClickLoginButton()
                : null,
            onChanged: (value) {
              showPhoneNumberClear = value.isNotEmpty;
              checkEnableLoginButton();
            },
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
          ),
          Gaps.vGap16,
          AppTextInput(
            isRequiredField: true,
            onTextChanged: (text) {
              checkEnableLoginButton();
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
                    ///arguments = true -> forget password by phone
                    NavigatorUtils.jump(AppModuleRoute.resetPasswordOtpPage, arguments: true);
                  },
                    child: cText(S().forget_password, fontSize: 15, color: AppColors.primaryColor, textAlign: TextAlign.right)
                )
            )
          ],),
          /// login
          btnWithLoading(
              isLoading: isShowBtnLoading,
              title: S.current.login,
              margin: EdgeInsets.zero,
              backgroundColor: buttonActive
                  ? AppColors.primaryColor
                  : AppColors.color80E60013,
              onTap: buttonActive
                  ? () => onClickLoginButton()
                  : null)
              .intoContainer(
              color: AppColors.background,
              margin: const EdgeInsets.only(top: 24.0),
              height: 42.0),
          btnWithLoading(
              title: S.current.login_by_email,
              margin: EdgeInsets.zero,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onTap: () {
                Get.to(LoginByEmailPage());
              })
              .intoContainer(
              color: AppColors.background,
              margin: const EdgeInsets.only(top: 24.0),
              height: 42.0),
        ],),
      ),
    );
  }

  void checkEnableLoginButton() {
    setState(() {
      buttonActive = (phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) ? true : false;
    });
  }

  void onClickLoginButton() async {
    setState(() {
      isShowBtnLoading = true;
    });
    try {
      var response = await userRepository.loginWithPhone(
          password: passwordController.text.removeAllWhitespace,
          phone: '+$selectedCode${phoneNumberController.text.removeAllWhitespace}');
      if (response != null) {
        NavigatorUtils.jump(AppModuleRoute.homePage);
      }
    } catch (error) {
      if (error is UnknownException) {
        if (error.status == 'PWD_ERROR') {
          errorText = S().password_incorrect;
        } else {
          errorText = error.message;
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

  void getRegions() async {
    try {
      var regions = await prepaidRepository.getCountryRegion();
      setState(() {
        listCountry.addAll(regions);
      });
    } catch (e) {
      // error
      print(e);
    }
  }
}