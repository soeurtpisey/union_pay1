import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/http/net/dio_new.dart';
import 'package:union_pay/models/auth/email_verify_model.dart';
import 'package:union_pay/repositories/user_repository.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/route/base_route.dart';
import 'package:union_pay/widgets/app_non_border_text_input.dart';
import 'package:union_pay/widgets/common.dart';
import '../../route/app_route.dart';

class RegisterByEmailSendOPTPage extends StatefulWidget {
  @override
  State<RegisterByEmailSendOPTPage> createState() => _RegisterByEmailSendOPTPageState();
}

class _RegisterByEmailSendOPTPageState extends State<RegisterByEmailSendOPTPage> {
  final TextEditingController inputController = TextEditingController();
  final userRepository = UserRepository();
  FocusNode focusNode = FocusNode();
  bool buttonActive = false;
  bool isShowBtnLoading = false;
  bool isError = false;
  var errorText = '';

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
              cText(S.current.enter_your_email,
                  fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
              const SizedBox(height: 5),
              cText(S.current.enter_email_will_send_otp,
                  fontSize: 16, color: Colors.black.withOpacity(0.45), textAlign: TextAlign.center),
              const SizedBox(height: 27),
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
              AppNonBorderTextInput(
                isRequiredField: true,
                onTextChanged: (text) {
                  checkEnableNextButton();
                },
                controller: inputController,
                hint: S.current.email,
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

  void checkEnableNextButton() {
    setState(() {
      buttonActive = (inputController.text.removeAllWhitespace.isNotEmpty)
          ? true
          : false;
    });
  }

  ////////////////////////// API Integrate /////////////////////
  void onClickNextButton() async {
    if (isShowBtnLoading) return;
    setState(() {
      isShowBtnLoading = true;
    });
    try {
      var response = await userRepository.emailRegisterSendOTP(email: inputController.text.removeAllWhitespace);
      if (response != null) {
        /// success
        NavigatorUtils.jump(AppModuleRoute.verifyCodePage, arguments: EmailVerifyModel(email: inputController.text.removeAllWhitespace, isForgetPass: false));
      }
      isError = false;
    } catch (error) {
      if (error is UnknownException) {
        isError = true;
        if (error.status == 'EMAIL_EXIT_REGISTER') {
          errorText = S().email_already_exits;
        } else {
          errorText = error.message;
        }
      }
    } finally {
      setState(() {
        isShowBtnLoading = false;
      });
    }
  }

}
