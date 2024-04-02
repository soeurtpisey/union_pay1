
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:union_pay/constants/style.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/widgets/common.dart';
import 'package:union_pay/widgets/prepaid_card/form_common.dart';
import 'prepaid_old_atm_password_logic.dart';

class PrepaidOldAtmPasswordPage extends StatefulWidget {
  final int? cardId;

  const PrepaidOldAtmPasswordPage({Key? key, this.cardId}) : super(key: key);

  @override
  State<PrepaidOldAtmPasswordPage> createState() =>
      _PrepaidOldAtmPasswordPageState();
}

class _PrepaidOldAtmPasswordPageState extends State<PrepaidOldAtmPasswordPage> {
  final logic = Get.put(PrepaidOldAtmPasswordLogic());
  final state = Get.find<PrepaidOldAtmPasswordLogic>().state;

  @override
  void initState() {
    super.initState();
    logic.updateCardId(widget.cardId!);
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.of(context).reset_atm_pwd,
        child: Column(
          children: [
            Gaps.vGap70,
            ImagesRes.ICON_PIN_LOCK_V2.UIImage(),
            Gaps.vGap40,
            //第一个设置PIN
            _buildPinFirst(context),
            Gaps.vGap24,
            Gaps.vGap24,
            buildTip(S.of(context).old_atm_password),
            //Done
            Obx(() => cBottomButton(S.of(context).acceptPrivacy_continue,
                    isEnable: state.isContinue.value, onTap: () {
                  logic.onSubmit();
                }))
          ],
        ).paddingSymmetric(horizontal: 40));
  }

  //第一个设置PIN
  Widget _buildPinFirst(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(S.of(context).please_input_old_atm_password,
            color: AppColors.color666666, fontSize: 12),
        Gaps.vGap12,
        Center(
          child: cPinPut(
              focusNode: logic.firstFocusNode,
              controller: logic.firstController,
              onSubmit: (smsCode) {
                logic.onSubmit();
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
                  color: AppColors.colorEFEFEF,
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
    Get.delete<PrepaidOldAtmPasswordLogic>();
    super.dispose();
  }
}
