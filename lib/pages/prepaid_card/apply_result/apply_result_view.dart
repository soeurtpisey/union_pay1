
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/enums/audit_state.dart';
import '../../../utils/dimen.dart';
import '../../../widgets/button/ripple_button.dart';
import '../../../widgets/common.dart';
import 'apply_result_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/13 13:54
/// @Description: 预付卡申请确认
/// /////////////////////////////////////////////
class ApplyResultPage extends StatefulWidget {
  const ApplyResultPage({Key? key}) : super(key: key);

  @override
  State<ApplyResultPage> createState() => _ApplyResultPageState();
}

class _ApplyResultPageState extends State<ApplyResultPage> {
  final logic = Get.put(ApplyResultLogic());
  final state = Get.find<ApplyResultLogic>().state;

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.of(context).application_result,
        backgroundColor: AppColors.colorE9EBF5,
        appBarBgColor: AppColors.colorE9EBF5,
        child: Column(
          children: [
            if (state.auditState.value == AuditState.loading)
              ..._buildLoading(context),
            if (state.auditState.value == AuditState.success)
              ..._buildSuccess(context),
            if (state.auditState.value == AuditState.failed)
              ..._buildFailed(context),
          ],
        ));
  }

  //审核中
  List<Widget> _buildLoading(BuildContext context) {
    return [
      Gaps.vGap80,
      ImagesRes.IC_APPLY_CARD_UNDER_REVIEW.UIImage(),
      Gaps.vGap24,
      cText(S.of(context).under_review,
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
      Gaps.vGap8,
      cText(
        S.of(context).audit_reminder_tip,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.color79747E,
      ).paddingSymmetric(horizontal: 60),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          btnWithLoading(
              title: S.of(context).confirm,
              circular: 50,
              backgroundColor:AppColors.colorE40C19,
              height: 50,
              onTap: () {
                /// warning
                // context.router.popUntil(
                //         (route) => route.settings.name == WalletManagePageRoute.name||route.settings.name==DashboardPageRoute.name);
              }),
          Gaps.vGap80,
        ],
      ).intoExpend()
    ];
  }

  //审核成功
  List<Widget> _buildSuccess(BuildContext context) {
    return [
      Gaps.vGap80,
      ImagesRes.IC_SUCCESS_80.UIImage(),
      Gaps.vGap24,
      Gaps.vGap10,
      cBottomButton(S.of(context).back_to_home, onTap: () {
        /// warning
        // context.router.popUntil(PredicateY);
      })
    ];
  }

  List<Widget> _buildFailed(BuildContext context) {
    return [
      Gaps.vGap80,
      ImagesRes.IC_FAILURE_80.UIImage(),
      Gaps.vGap24,
      cText(S.of(context).verify_fail,
          color: AppColors.color1E1F20,
          fontSize: 17,
          fontWeight: FontWeight.w500),
      Gaps.vGap50,
      cText('',
              color: AppColors.color282828,
              fontWeight: FontWeight.w500,
              fontSize: 12)
          .intoContainer(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                  color: AppColors.colorF5F5F5,
                  borderRadius: BorderRadius.circular(Dimens.gap_dp6))),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                /// warning
                // context.router.popUntil(PredicateY);
              },
              child: cText(S.of(context).back_to_home,
                  color: AppColors.color3478f5, fontSize: 12)),
          Gaps.vGap20,
          cRippleButton(S.of(context).refresh, onTap: () {
            Get.back();
          }).intoPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80))
        ],
      ).intoExpend()
    ];
  }

  @override
  void dispose() {
    Get.delete<ApplyResultLogic>();
    super.dispose();
  }
}
