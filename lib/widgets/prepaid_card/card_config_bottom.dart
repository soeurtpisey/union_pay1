import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/res/images_res.dart';

import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../models/prepaid/res/union_pay_card_config_model.dart';
import '../common.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/12 16:37
/// @Description:
/// /////////////////////////////////////////////

class CardConfigBottom extends StatelessWidget {
  final UnionPayCardConfigModel? cardInfo;

  const CardConfigBottom({super.key, this.cardInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(ImagesRes.IC_CARD_CONFIG_ICON),
        cText(S().unionpay_classic,
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
        Gaps.vGap20,
        _buildRow(S.current.annual_fee,
            '${cardInfo?.annualFee?.toString().formatCurrency()} USD'),
        _buildRow(S.current.issuance_fee,
            '${cardInfo?.issueFee?.toString().formatCurrency()} USD'),
        _buildRow(S.of(context).validity_period, S.current.number_of_year(cardInfo?.validTime ?? 0)),
        _buildRow(S.of(context).daily_withdrawal_limit, '${cardInfo?.withdrawDayMax?.toString().formatCurrency()} USD'),
        _buildRow(S.of(context).daily_consumption_limit, '${cardInfo?.consumeDayMax?.toString().formatCurrency()} USD'),
        _buildRow(S.of(context).single_consumption_limit, '${cardInfo?.consumeSingleMax.toString().formatCurrency()} USD'),
        _buildRow(S.of(context).daily_consumption_times, S.current.number_of_transactions(cardInfo?.consumeDayMaxNum ?? 0)),
      ],
    );
  }

  Widget _buildRow(String s, String t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cText(s,
            color: AppColors.color79747E,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        cText(t, color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500)
      ],
    ).paddingOnly(top: 15);
  }
}
