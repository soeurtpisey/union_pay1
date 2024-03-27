
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/enums/freeze_state.dart';
import '../../../models/prepaid/enums/union_card_state.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../widgets/common.dart';
import 'prepaid_freeze_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/14 19:30
/// @Description: 冻结卡
/// /////////////////////////////////////////////

class PrepaidFreezePage extends StatefulWidget {
  final FreezeState freezeState;
  final UnionPayCardResModel? model;
  PrepaidFreezePage({Key? key, required this.freezeState, required this.model})
      : super(key: key);

  @override
  State<PrepaidFreezePage> createState() => _PrepaidFreezePageState();
}

class _PrepaidFreezePageState extends State<PrepaidFreezePage> {
  final logic = Get.put(PrepaidFreezeLogic());
  final state = Get.find<PrepaidFreezeLogic>().state;

  @override
  Widget build(BuildContext context) {
    var freezeState;
    var title;
    Widget icon = Container();
    if (widget.model?.cardStatus == UnionCardState.NORMAL.value) {
      freezeState = FreezeState.FREEZE;
      title = S.current.freeze_card;
      icon = ImagesRes.IC_FREEZE_80.UIImage();
    } else if (widget.model?.cardStatus == UnionCardState.FREEZE.value) {
      freezeState = FreezeState.UNFREEZE;
      title = S.current.un_freeze_card;
      icon = ImagesRes.IC_FREEZE_80.UIImage();
    }

    return cScaffold(context, title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.vGap40,
            icon,
            Gaps.vGap13,
            buildFreeze(context),
            /// warning
            // //右滑组件
            // buildSliderButton(context, state: freezeState, action: () {
            //   BioUtil.getInstance().showPasscodeModal(context, '', '', (value) {
            //     if (freezeState == FreezeState.FREEZE) {
            //       logic.freezeCard(widget.model!.id!);
            //     } else {
            //       logic.unFreezeCard(widget.model!.id!);
            //     }
            //   }, onClose: () {
            //     setState(() {});
            //   });
            // }, flag: false)
          ],
        ).intoContainer(width: double.infinity));
  }

  Widget buildFreeze(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: widget.model?.cardState() == UnionCardState.FREEZE
              ? S.current.you_are_about_to_unfreeze_your_card_number
              : S.current.you_are_about_to_freeze_your_card_number,
          style: const TextStyle(color: AppColors.color1E1F20, fontSize: 17)),
      TextSpan(
          text: widget.model?.cardId4 ?? '',
          style: const TextStyle(color: AppColors.colorFF3E47, fontSize: 17)),
      TextSpan(
          text: S.current.s_card,
          style: const TextStyle(color: AppColors.color1E1F20, fontSize: 17)),
    ])).intoContainer(padding: const EdgeInsets.symmetric(horizontal: 15));
  }

  @override
  void dispose() {
    Get.delete<PrepaidFreezeLogic>();
    super.dispose();
  }
}
