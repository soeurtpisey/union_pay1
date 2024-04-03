import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/models/auth/phone_verify_model.dart';
import 'package:union_pay/pages/auth/select_country_code.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../models/auth/email_verify_model.dart';
import '../../repositories/prepaid_repository.dart';
import '../../repositories/user_repository.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../utils/view_util.dart';
import '../../widgets/app_input_textfield.dart';
import '../../widgets/common.dart';
import '../../widgets/country_selection/code_country.dart';
import '../../widgets/prefix_icon.dart';

class ForgetPasswordOTPPage extends StatefulWidget {
  @override
  State<ForgetPasswordOTPPage> createState() => _ForgetPasswordOTPPageState();
}

class _ForgetPasswordOTPPageState extends State<ForgetPasswordOTPPage> {
  final TextEditingController inputController = TextEditingController();
  final userRepository = UserRepository();
  FocusNode focusNode = FocusNode();
  bool buttonActive = false;
  bool isShowBtnLoading = false;
  bool isPhoneNumber = false;
  String selectedCode = '855';
  bool showPhoneNumberClear = false;
  List<CountryCode> listCountry = [];
  PrepaidRepository prepaidRepository = PrepaidRepository();

  @override
  void initState() {
    super.initState();
    var argument = Get.arguments;
    if (argument != null) {
      if (argument is bool) {
        isPhoneNumber = argument;
        if (isPhoneNumber) {
          getRegions();
        }
      }
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

  void onClickNextButton() async {
    setState(() {
      isShowBtnLoading = true;
    });
    try {
      var response = isPhoneNumber ?
      await userRepository.forgetPassSendOTPByPhone(phone: '+$selectedCode${inputController.text.removeAllWhitespace}')
      :
      await userRepository.forgetPassSendOTPByEmail(email: inputController.text.removeAllWhitespace);
      if (response != null) {
        /// success
        NavigatorUtils.jump(AppModuleRoute.verifyCodePage,
            arguments: isPhoneNumber ?
            PhoneVerifyModel(phone: '+$selectedCode${inputController.text.removeAllWhitespace}', isForgetPass: true)
                :
            EmailVerifyModel(email: inputController.text.removeAllWhitespace, isForgetPass: true)
        );
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isShowBtnLoading = false;
      });
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
              cText(isPhoneNumber ? S.current.enter_your_phone_number : S.current.enter_your_email,
                  fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
              const SizedBox(height: 27),
              isPhoneNumber ?
              TextFormField(
                focusNode: focusNode,
                controller: inputController,
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
                        content: '+$selectedCode ',
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
                        inputController.clear();
                        showPhoneNumberClear = false;
                        checkEnableRegisterButton();
                      },
                      icon: const Icon(Icons.close, size: 22, color: AppColors.color79767D),
                    ) : null,
                    hintText: S().label_phone_number.toLowerCase(),
                    hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color79747E)),
                onEditingComplete: buttonActive
                    ? () => checkEnableRegisterButton()
                    : null,
                onChanged: (value) {
                  showPhoneNumberClear = value.isNotEmpty;
                  checkEnableRegisterButton();
                },
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              )
                  :
              AppTextInput(
                isRequiredField: true,
                onTextChanged: (text) {
                  checkEnableRegisterButton();
                },
                controller: inputController,
                hint: isPhoneNumber ? S.current.label_phone_number.toLowerCase() : S.current.email,
                keyboardType: TextInputType.text,
              ),
              btnWithLoading(
                  isLoading: isShowBtnLoading,
                  title: S.current.get_otp,
                  margin: EdgeInsets.zero,
                  backgroundColor: buttonActive
                      ? AppColors.primaryColor
                      : AppColors.color80E60013,
                  onTap: buttonActive ? () => onClickNextButton() : null)
                  .intoContainer(
                  color: AppColors.background,
                  margin: const EdgeInsets.only(top: 27.0),
                  height: 42.0),
            ],
          ),
        ),
      ),
    );
  }

  void checkEnableRegisterButton() {
    setState(() {
      buttonActive = (inputController.text.removeAllWhitespace.isNotEmpty)
          ? true
          : false;
    });
  }

}
