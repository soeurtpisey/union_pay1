import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/models/prepaid/union_pay_card_pwd_modify_model.dart';
import 'package:union_pay/pages/prepaid_card/prepaid_atm_password/prepaid_atm_password_state.dart';
import 'package:union_pay/res/images_res.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/union_pay_card_active_param_model.dart';
import '../../../utils/view_util.dart';
import '../../../widgets/common.dart';
import '../../../widgets/prepaid_card/form_common.dart';
import 'prepaid_atm_password_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/14 19:30
/// @Description: ATM密码设计
/// /////////////////////////////////////////////

class PrepaidAtmPasswordPage extends StatefulWidget {
  final UnionPayCardActiveParamModel? unionPayCardActiveParamModel;
  final UnionPayCardPwdModifyModel? unionPayCardPwdModifyModel;
  const PrepaidAtmPasswordPage(
      {Key? key,
      this.unionPayCardActiveParamModel,
      this.unionPayCardPwdModifyModel})
      : super(key: key);

  @override
  State<PrepaidAtmPasswordPage> createState() => _PrepaidAtmPasswordPageState();
}

class _PrepaidAtmPasswordPageState extends State<PrepaidAtmPasswordPage> {
  late PrepaidAtmPasswordLogic logic;
  late PrepaidAtmPasswordState state;

  @override
  void initState() {
    super.initState();
    logic =
        Get.put(PrepaidAtmPasswordLogic(widget.unionPayCardActiveParamModel));
    state = Get.find<PrepaidAtmPasswordLogic>().state;
    logic.cardPwdModifyModel = widget.unionPayCardPwdModifyModel;
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.of(context).atm_password,
        child: Stack(
          children: [
            Column(
              children: [
                Gaps.vGap70,
                ImagesRes.ICON_PIN_LOCK_V2.UIImage(),
                Gaps.vGap40,
                //第一个设置PIN
                _buildPinFirst(context),
                Gaps.vGap24,
                //第二个设置PIN
                Obx(() => _buildPinSecond(context)),
                Gaps.vGap24,
                buildTip(S.of(context).securitySettingsChangePinHint),
                Gaps.vGap10,
                buildTip(S.of(context).atm_password_set_tip),
                //Done
                cBottomButton(S.of(context).next, onTap: () {
                  logic.onSecondDone();
                })
              ],
            ).paddingSymmetric(horizontal: 40),
            Obx(() => buildPageLoadingStack(state.isLoading.value))
          ],
        ));
  }

  //第一个设置PIN
  Widget _buildPinFirst(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(S.of(context).enter_your_atm_pin,
            color: AppColors.color666666, fontSize: 12),
        Gaps.vGap12,
        Center(
          child: cPinPut(
              focusNode: logic.firstFocusNode,
              controller: logic.firstController,
              onSubmit: (smsCode) {
                logic.onFirstDone();
              },
              fieldsCount: 6,
              separatorWidth: 15,
              pinTheme: PinTheme(
                width: 40,
                height: 40,
                textStyle: const TextStyle(
                    fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0xffEFEFEF),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
              )),
        )
      ],
    );
  }

  //第二个设置PIN
  Widget _buildPinSecond(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(S.of(context).enter_your_atm_pin_again,
            color: state.isForceError.value
                ? AppColors.colorE60013
                : AppColors.color666666,
            fontSize: 12),
        Gaps.vGap12,
        Center(
          child: cPinPut(
              focusNode: logic.secondFocusNode,
              controller: logic.secondController,
              onSubmit: (smsCode) {
                logic.onSecondDone();
              },
              fieldsCount: 6,
              forceErrorState: state.isForceError.value,
              separatorWidth: 15,
              pinTheme: PinTheme(
                width: 40,
                height: 40,
                textStyle: TextStyle(
                    fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0xffEFEFEF),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
              )),
        )
      ],
    );
  }

  @override
  void dispose() {
    Get.delete<PrepaidAtmPasswordLogic>();
    super.dispose();
  }
}
