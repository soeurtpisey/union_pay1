
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';

import '../../app/config/app_config.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../helper/prepaid_card_helper.dart';
import '../../models/prepaid/apply_status_vo_model.dart';
import '../../models/prepaid/enums/union_card_type.dart';
import '../../repositories/prepaid_repository.dart';
import '../common.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/11 19:45
/// @Description:
/// /////////////////////////////////////////////

class NewCardBottom extends StatefulWidget {
  final ApplyStatusVoModel applyStatus;

  const NewCardBottom({super.key, required this.applyStatus});

  @override
  State<NewCardBottom> createState() => _NewCardBottomState();
}

class _NewCardBottomState extends State<NewCardBottom> {
  var physicalCardHave = false;
  var virtualCardHave = false;
  PrepaidRepository prepaidRepository = PrepaidRepository();

  @override
  void initState() {
    super.initState();
    physicalCardHave = (PrepaidCardHelper.blCardList
            .where((element) => !element.isVirtual())
            .length) >=
        (Env.appEnv == EnvName.dev ? 1 : 1);
    virtualCardHave = (PrepaidCardHelper.blCardList
            .where((element) => element.isVirtual())
            .length) >=
        (Env.appEnv == EnvName.dev ? 1 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(ImagesRes.IC_NEW_CARD_TITLE),
          cText(S().new_card,
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
          Gaps.vGap30,
          buildItem(ImagesRes.IC_PHYSICAL_NEW_CARD_ICON,
              S.of(context).physical_card, S.of(context).physical_card_apply,
              isVirtual: false,
              isHave: physicalCardHave,
              applyStatus: widget.applyStatus, onTap: () {
            Navigator.pop(
                context,
                NewCardParam(UnionCardType.physicalCard,
                    widget.applyStatus.audit == true));
          }),
          Gaps.vGap30,
          buildItem(ImagesRes.IC_VIRTUAL_NEW_CARD_ICON,
              S.of(context).vcCardTitle, S.of(context).virtual_card_apply_desc,
              isHave: virtualCardHave,
              isVirtual: true,
              applyStatus: widget.applyStatus, onTap: () {
            Navigator.pop(
                context,
                NewCardParam(UnionCardType.virtualCard,
                    widget.applyStatus.audit == true));
          }),
          Gaps.vGap20,
        ],
      ),
    );
  }

  // Future<void> pushFormPage(
  //     BuildContext context, UnionCardType unionCardType) async {
  //   if (PrepaidCardHelper.blCardList.isEmpty) {
  //     await context.router
  //         .popAndPush(ApplyFormPageRoute(unionCardType: unionCardType));
  //   } else {
  //     await context.router
  //         .popAndPush(ApplyFormOldPageRoute(unionCardType: unionCardType));
  //   }
  // }

  Widget buildItem(String image, String title, String desc,
      {bool isHave = false,
      bool isVirtual = false,
      ApplyStatusVoModel? applyStatus,
      VoidCallback? onTap}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        image.UIImage(color: isHave||applyStatus?.supportApply==false ? Colors.grey.withOpacity(0.4) : null),
        Gaps.hGap10,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cText(title,
                color: isHave||applyStatus?.supportApply==false ? Colors.grey.withOpacity(0.4) : Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start),
            cText(desc,
                fontSize: 14,
                color: isHave||applyStatus?.supportApply==false
                    ? Colors.grey.withOpacity(0.4)
                    : AppColors.color49454F,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w500),
            if ((applyStatus?.audit==false&&applyStatus?.supportApply==true) || (isHave&&applyStatus?.supportApply==true))
              Row(
                children: [
                  isVirtual
                      ? ImagesRes.IC_APPLY_CARD_TIP2_ICON.UIImage()
                      : ImagesRes.IC_APPLY_CARD_TIP_ICON.UIImage(),
                  if (applyStatus?.audit==false && !isHave)
                    cText(S.of(context).waiting_for_audit,
                        fontSize: 14, fontWeight: FontWeight.w500),
                  if (isHave)
                    cText(S.of(context).you_already_had_it,
                        fontSize: 14, fontWeight: FontWeight.w500)
                ],
              ),
            if(applyStatus?.supportApply!=true)
              Row(
                children: [
                  isVirtual
                      ? ImagesRes.IC_APPLY_CARD_TIP2_ICON.UIImage()
                      : ImagesRes.IC_APPLY_CARD_TIP_ICON.UIImage(),
                    cText(S.of(context).service_under_maintenance,
                        fontSize: 14, fontWeight: FontWeight.w500),
                ],
              ),
          ],
        ).intoExpend()
      ],
    ).onClick(() {
      if (!isHave&&applyStatus?.supportApply==true||isAdminApplyCard) {
        onTap?.call();
      }
    });
  }
}

class NewCardParam {
  final UnionCardType cardType;
  final bool isAudit;

  NewCardParam(this.cardType, this.isAudit);
}
