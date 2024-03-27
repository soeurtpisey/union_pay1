
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';

import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../utils/screen_util.dart';
import '../common.dart';
import 'card_application_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/15 17:24
/// @Description:
/// /////////////////////////////////////////////

class CardApplication extends StatelessWidget {
  final String title;
  final String desc;
  final String reason;
  final String id;

  final logic = Get.put(CardApplicationLogic());

  CardApplication(
      {super.key,
      required this.title,
      required this.desc,
      required this.id,
      required this.reason});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(ImagesRes.IC_APPLY_CARD_REJECTED),
        cText(title,
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
        cText(
            desc,
            color: AppColors.color36343B,
            textAlign: TextAlign.start),
        Gaps.vGap15,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImagesRes.IC_APPLY_CARD_TIP2_ICON),
            Gaps.hGap10,
            cText(S().card_issue_fee_been_refunded, color: Colors.black)
          ],
        ),
        Gaps.vGap15,
        ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: ScreenUtil.screenWidth,
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 21),
              decoration: BoxDecoration(
                  color: AppColors.colorF5F5F5,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(S.of(context).reason_unit,
                      fontSize: 22, color: AppColors.color36343B),
                  cText(reason, color: AppColors.color36343B,textAlign: TextAlign.start)
                ],
              ),
            )
          ],
        ).intoContainer(constraints:BoxConstraints(
          maxHeight: ScreenUtil.screenHeight/3
        )),
        Gaps.vGap30,
        GetBuilder(
            init: logic,
            builder: (viewModel) {
              return btnWithLoading(
                  title: S.of(context).edit_information,
                  isLoading: logic.isLoading.value,
                  onTap: () async {
                    var record = await logic.getRejectRecordById(id);
                    if (record != null) {
                      /// warning, please update this later
                      // await context.router.popAndPush(ApplyFormPageRoute(
                      //     unionCardType: record.getCardType(),
                      //     requestParam: record));
                    }
                  });
            }),
        Gaps.vGap20
      ],
    );
  }
}
