import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/pages/prepaid_card/apply_form/apply_form_view.dart';
import 'package:union_pay/pages/prepaid_card/apply_form_old/apply_form_old_view.dart';
import 'package:union_pay/res/images_res.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../helper/notify.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../widgets/common.dart';
import 'apply_card_logic.dart';


bool isAdminApplyCard = false;

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/13 12:54
/// @Description: 预付卡申请
/// /////////////////////////////////////////////
class ApplyCardPage extends StatefulWidget {
  const ApplyCardPage({Key? key}) : super(key: key);

  @override
  State<ApplyCardPage> createState() => _ApplyCardPageState();
}

class _ApplyCardPageState extends State<ApplyCardPage> {
  final logic = Get.put(ApplyCardLogic());
  final state = Get.find<ApplyCardLogic>().state;

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S().apply_prepaid_card,
        child: Column(
          children: [
            _buildItem(ImagesRes.IC_VIRTUAL_CARD,
                S().virtual_card_application, '', onTap: () {
              if (PrepaidCardHelper.blCardList.isEmpty) {
                /// warning
                Get.to(ApplyFormPage(unionCardType: UnionCardType.virtualCard), arguments: UnionCardType.virtualCard);
                // context.pushRoute(ApplyFormPageRoute(
                //     unionCardType: UnionCardType.virtualCard));
              } else {
                /// warning
                Get.to(const ApplyFormOldPage(unionCardType: UnionCardType.virtualCard));
                // context.pushRoute(ApplyFormOldPageRoute(
                //     unionCardType: UnionCardType.virtualCard));
              }
            }),
            _buildItem(
                ImagesRes.IC_PHYSICAL_CARD,
                S().physical_card_application,
                '', onTap: () async {
              if (isAdminApplyCard) {
                if(PrepaidCardHelper.blCardList.isEmpty) {
                  /// warning
                  Get.to(ApplyFormPage(), arguments: UnionCardType.physicalCard);
                  // await context.pushRoute(ApplyFormPageRoute(
                  //     unionCardType: UnionCardType.physicalCard));
                } else {
                  /// warning
                  Get.to(const ApplyFormOldPage(), arguments: UnionCardType.physicalCard);
                  // await context.pushRoute(ApplyFormOldPageRoute(
                  //     unionCardType: UnionCardType.physicalCard));
                }
              } else {
                if (await logic.checkStatus()) {
                  if (PrepaidCardHelper.blCardList.isEmpty) {
                    /// warning
                    // await context.pushRoute(ApplyFormPageRoute(
                    //     unionCardType: UnionCardType.physicalCard));
                  } else {
                    /// warning
                    // await context.pushRoute(ApplyFormOldPageRoute(
                    //     unionCardType: UnionCardType.physicalCard));
                  }
                } else {
                  Notify.info(
                      message: S().you_card_apply_status_tips,
                      context: context);
                }
              }
            }),
          ],
        ));
  }

  Widget _buildItem(String icon, String title, String sub,
      {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            icon.UIImage(),
            Gaps.hGap10,
            cText(title,
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: AppColors.color1E1F20),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImagesRes.ICON_PREPAID_UPAY_V2.UIImage(),
            cText('&', color: AppColors.colorFF3E47)
                .intoContainer(margin: const EdgeInsets.symmetric(horizontal: 6)),
            ImagesRes.ICON_PREPAID_UNIONPAY_V2.UIImage(),
          ],
        )
      ],
    )
        .intoContainer(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)))
        .onClick(onTap);
  }

  @override
  void dispose() {
    Get.delete<ApplyCardLogic>();
    super.dispose();
  }
}
