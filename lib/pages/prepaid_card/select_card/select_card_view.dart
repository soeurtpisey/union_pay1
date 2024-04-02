
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/models/prepaid/enums/union_card_type.dart';
import 'package:union_pay/utils/screen_util.dart';
import 'package:union_pay/widgets/common.dart';
import 'select_card_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/13 13:54
/// @Description: 预付卡选择卡片 暂不需要这个选择卡片
/// /////////////////////////////////////////////
class SelectCardPage extends StatelessWidget {
  final UnionCardType? unionCardType;
  SelectCardPage({Key? key, this.unionCardType}) : super(key: key);

  final logic = Get.put(SelectCardLogic());
  final state = Get.find<SelectCardLogic>().state;

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.of(context).apply_prepaid_card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cText('选择您的卡面'),
            //卡面
            _buildCard(context),

            cText('经典款', color: Colors.black),

            cBottomButton(S.of(context).next, onTap: () {
              //todo 表单页面1
            })
          ],
        ).paddingSymmetric(horizontal: 15));
  }

  Container _buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(S.of(context).tourPage_SlideVC_Title,
            fontSize: 16, color: Colors.white),
      ],
    ).intoContainer(
        height: 206,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 15),
        width: ScreenUtil.screenWidth,
        decoration: BoxDecoration(
            color: AppColors.colorFF564F,
            borderRadius: BorderRadius.circular(16)));
  }
}
