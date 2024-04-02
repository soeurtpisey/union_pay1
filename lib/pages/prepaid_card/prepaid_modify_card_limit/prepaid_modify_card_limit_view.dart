
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/constants/style.dart';
import 'package:union_pay/extensions/double_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/models/prepaid/res/union_pay_card_res_model.dart';
import 'package:union_pay/utils/bio_util.dart';
import 'package:union_pay/widgets/common.dart';
import 'package:union_pay/widgets/prepaid_card/form_common.dart';
import '../../../utils/custom_decoration.dart';
import '../../../widgets/page_loading_indicator.dart';
import 'prepaid_modify_card_limit_logic.dart';
import 'prepaid_modify_card_limit_state.dart';

class PrepaidModifyCardLimitPage extends StatefulWidget {
  final UnionPayCardResModel unionPayCardResModel;

  const PrepaidModifyCardLimitPage(
      {Key? key, required this.unionPayCardResModel})
      : super(key: key);

  @override
  _PrepaidModifyCardLimitPageState createState() =>
      _PrepaidModifyCardLimitPageState();
}

class _PrepaidModifyCardLimitPageState
    extends State<PrepaidModifyCardLimitPage> {
  late PrepaidModifyCardLimitLogic logic;
  late PrepaidModifyCardLimitState state;

  @override
  void initState() {
    super.initState();
    logic = Get.put(PrepaidModifyCardLimitLogic(widget.unionPayCardResModel));
    state = Get.find<PrepaidModifyCardLimitLogic>().state;
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.current.modify_transaction_limit,
        resizeToAvoidBottomInset: true,
        child: GetBuilder(
            init: logic,
            builder: (control) {
              return state.isInit.value
                  ? PageLoadingIndicator()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cText(S.current.daily_limit,
                              color: AppColors.color151736, fontSize: 18),
                          cFormItem(S.of(context).maximum_consumption_amount,
                              child: buildTextInput(context,
                                  amountInput: true,
                                  controller:
                                      logic.maximumConsumptionAmountControl,
                                  focusNode:
                                      logic.maximumConsumptionAmountFocusNode)),
                          cText(
                              '\$5-\$${state.limitModel?.sysConsumeSingleMax}'),
                          if (state.consumptionMaxTimes.value != 0)
                            cFormItem(S.of(context).consumption_times,
                                child: _buildSlider(
                                    progress: state.consumptionTimes.value,
                                    minNum: state.consumptionMinTimes.value,
                                    maxNum: state.consumptionMaxTimes.value,
                                    onSlide: (value) {
                                      state.consumptionTimes.value = value;
                                    })),
                          cFormItem(
                              S.of(context).daily_maximum_consumption_amount,
                              child: buildTextInput(context,
                                  amountInput: true,
                                  controller: logic
                                      .dailyMaximumConsumptionAmountControl,
                                  focusNode: logic
                                      .dailyMaximumConsumptionAmountFocusNode)),
                          cText('\$5-\$${state.limitModel?.sysConsumeDayMax}'),
                          Gaps.vGap15,
                          cText(S.current.daily_withdrawal_limit,
                              color: AppColors.color151736, fontSize: 18),
                          cFormItem(
                              S.of(context).maximum_cash_withdrawal_amount,
                              child: buildTextInput(context,
                                  controller:
                                      logic.maximumWithdrawalAmountControl,
                                  amountInput: true,
                                  focusNode:
                                      logic.maximumWithdrawalAmountFocusNode)),
                          cText(
                              '\$5-\$${state.limitModel?.sysWithdrawSingleMax}'),
                          if (state.withdrawalMaxTimes.value != 0)
                            cFormItem(S.of(context).number_of_withdrawals,
                                child: _buildSlider(
                                    progress: state.withdrawalTimes.value,
                                    minNum: state.withdrawalMinTimes.value,
                                    maxNum: state.withdrawalMaxTimes.value,
                                    onSlide: (value) {
                                      state.withdrawalTimes.value = value;
                                    })),
                          cFormItem(
                              S
                                  .of(context)
                                  .daily_maximum_cash_withdrawal_amount,
                              child: buildTextInput(context,
                                  amountInput: true,
                                  controller:
                                      logic.dailyMaximumWithdrawalAmountControl,
                                  focusNode: logic
                                      .dailyMaximumWithdrawalAmountFocusNode)),
                          cText('\$5-\$${state.limitModel?.sysWithdrawDayMax}'),
                        ],
                      ).intoContainer(
                              decoration: normalDecoration(color: Colors.white),
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15))));
            }),
        bottomNavigationBar: Obx(() => btnWithLoading(
            title: S.current.confirm,
            isLoading: state.isLoading.value,
            onTap: () async {
              logic.unFocus();
              BioUtil.getInstance().showPasscodeModal(context, '', '',
                  (value) async {
                await logic.setCardLimit();
                Navigator.pop(context);
              });
            })).intoContainer(margin: const EdgeInsets.symmetric(vertical: 30)));
  }

  Widget _buildSlider(
      {double? progress = 0,
      double? minNum = 0,
      double? maxNum = 10,
      ValueChanged? onSlide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(S.current.current_num_of_times(progress!.toInt())),
        SliderTheme(
            data: const SliderThemeData(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
            child: Slider(
              // 当前值
              value: progress,
              // 拖动中
              onChanged: (progress) {
                onSlide?.call(progress);
              },
              min: minNum!,
              max: maxNum!,
              label: progress.toString(),
              // label的数量，比如最小0、最大10、divisions是10，那么label的数量就是10
              divisions: (maxNum - minNum).toInt(),
              activeColor: AppColors.colorE60013,
              inactiveColor: Colors.white,
            )).intoContainer(width: double.infinity),
        Row(
          children: [
            cText(S.current.num_of_times(minNum.toInt()),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.color999999,
                textAlign: TextAlign.left),
            Spacer(),
            cText(S.current.num_of_times(maxNum.toInt()),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.color999999,
                textAlign: TextAlign.right),
          ],
        )
      ],
    ).intoContainer(
        decoration: normalDecoration(
          color: AppColors.colorF5F5F5,
        ),
        padding: EdgeInsets.symmetric(vertical: 14.0.px, horizontal: 20.0.px));
  }

  @override
  void dispose() {
    Get.delete<PrepaidModifyCardLimitLogic>();
    super.dispose();
  }
}
