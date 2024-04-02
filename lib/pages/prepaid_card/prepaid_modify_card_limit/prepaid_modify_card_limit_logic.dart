
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/http/net/api_exception.dart';
import 'package:union_pay/models/prepaid/union_pay_card_limit_param_model.dart';

import '../../../helper/prepaid_card_helper.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../repositories/prepaid_repository.dart';
import 'prepaid_modify_card_limit_state.dart';

class PrepaidModifyCardLimitLogic extends GetxController {
  PrepaidModifyCardLimitLogic(this.unionPayCardResModel);
  final PrepaidModifyCardLimitState state = PrepaidModifyCardLimitState();
  final _repository = PrepaidRepository();

  //最大消费金额
  final maximumConsumptionAmountControl = TextEditingController();
  final maximumConsumptionAmountFocusNode = FocusNode();

  //每日最高消费金额
  final dailyMaximumConsumptionAmountControl = TextEditingController();
  final dailyMaximumConsumptionAmountFocusNode = FocusNode();

  //最大现金提款金额
  final maximumWithdrawalAmountControl = TextEditingController();
  final maximumWithdrawalAmountFocusNode = FocusNode();

  //每日最高现金提款金额
  final dailyMaximumWithdrawalAmountControl = TextEditingController();
  final dailyMaximumWithdrawalAmountFocusNode = FocusNode();

  final UnionPayCardResModel unionPayCardResModel;

  void unFocus() {
    if (maximumConsumptionAmountFocusNode.hasFocus) {
      maximumConsumptionAmountFocusNode.unfocus();
    }
    if (dailyMaximumConsumptionAmountFocusNode.hasFocus) {
      dailyMaximumConsumptionAmountFocusNode.unfocus();
    }
    if (maximumWithdrawalAmountFocusNode.hasFocus) {
      maximumWithdrawalAmountFocusNode.unfocus();
    }

    if (dailyMaximumWithdrawalAmountFocusNode.hasFocus) {
      dailyMaximumWithdrawalAmountFocusNode.unfocus();
    }
  }

  @override
  void onInit() {
    super.onInit();

    //获取限制
    getQueryCardLimit();
  }

  void getQueryCardLimit() async {
    try {
      state.limitModel =
          await _repository.queryCardLimit(unionPayCardResModel.id!);

      //消费次数最大值
      state.consumptionMaxTimes.value =
          double.tryParse(state.limitModel?.sysConsumeDayMaxNum ?? '10') ??
              10.0;
      //提款次数最大值
      state.withdrawalMaxTimes.value =
          double.tryParse(state.limitModel?.sysWithdrawDayMaxNum ?? '10') ??
              10.0;
      //当前单笔消费金额
      maximumConsumptionAmountControl.text =
          state.limitModel!.consumeSingleMax.toString();
      //当前日消费金额
      dailyMaximumConsumptionAmountControl.text =
          state.limitModel!.consumeDayMax.toString();
      //当前单笔提款金额
      maximumWithdrawalAmountControl.text =
          state.limitModel!.withdrawSingleMax.toString();
      //当前日提款金额
      dailyMaximumWithdrawalAmountControl.text =
          state.limitModel!.withdrawDayMax.toString();

      //当前消费次数
      state.consumptionTimes.value =
          double.parse(state.limitModel!.consumeDayMaxNum!);
      //当前提款次数
      state.withdrawalTimes.value =
          double.parse(state.limitModel!.withdrawDayMaxNum!);
      print(
          'state.consumptionTimes.value  ${state.consumptionTimes.value},  ${state.withdrawalTimes.value}');
      state.isInit.value = false;
      update();
    } on ApiException catch (error) {
      showToast(S.current.request_error);
    } catch (e) {
      print('e:${e.toString()}');
      // update();
    }
  }

  Future<bool> setCardLimit() async {
    try {
      //校验最大消费金额
      if (maximumConsumptionAmountControl.text.trim().isEmpty) {
        showToast(S.current.maximum_consumption_amount_cue);
        return false;
      } else {
        print("11111111");
        var current = int.parse(maximumConsumptionAmountControl.text);
        var min = 5;
        var max = int.parse(state.limitModel!.sysConsumeSingleMax!);
        if (current < min || current > max) {
          showToast(S.current.maximum_consumption_amount_not_in_range);
          return false;
        } else {
          print("2222");
        }
      }
      //校验每日最高消费金额
      if (dailyMaximumConsumptionAmountControl.text.trim().isEmpty) {
        showToast(S.current.daily_maximum_consumption_amount_cue);
        return false;
      } else {
        var current = int.parse(dailyMaximumConsumptionAmountControl.text);
        var min = 5;
        var max = int.parse(state.limitModel!.sysConsumeDayMax!);
        if (current < min || current > max) {
          showToast(S.current.daily_maximum_consumption_amount_not_in_range);
          return false;
        }
      }
      //校验最大提现金额
      if (maximumWithdrawalAmountControl.text.trim().isEmpty) {
        showToast(S.current.maximum_withdrawal_amount_cue);
        return false;
      } else {
        var current = int.parse(maximumWithdrawalAmountControl.text);
        var min = 5;
        var max = int.parse(state.limitModel!.sysWithdrawSingleMax!);
        if (current < min || current > max) {
          showToast(S.current.maximum_withdrawal_amount_not_in_range);
          return false;
        }
      }
      //校验每日最高提现金额
      if (dailyMaximumWithdrawalAmountControl.text.trim().isEmpty) {
        showToast(S.current.daily_maximum_withdrawal_amount_cue);
        return false;
      } else {
        var current = int.parse(dailyMaximumWithdrawalAmountControl.text);
        var min = 5;
        var max = int.parse(state.limitModel!.sysWithdrawDayMax!);
        if (current < min || current > max) {
          showToast(S.current.daily_maximum_withdrawal_amount_not_in_range);
          return false;
        }
      }

      state.isLoading.value = true;
      var param = UnionPayCardLimitParamModel();
      param.id = unionPayCardResModel.id!;
      param.consumeSingleMax =
          double.parse(maximumConsumptionAmountControl.text);
      param.consumeDayMaxNum = state.consumptionTimes.toInt();
      param.consumeDayMax =
          double.parse(dailyMaximumConsumptionAmountControl.text);

      param.withdrawSingleMax =
          double.parse(maximumWithdrawalAmountControl.text);
      param.withdrawDayMaxNum = state.withdrawalTimes.toInt();
      param.withdrawDayMax =
          double.parse(dailyMaximumWithdrawalAmountControl.text);

      await _repository.setCardLimit(param);
      PrepaidCardHelper.updateCardInfo(unionPayCardResModel.id!,
          consumeSingleMax: param.consumeSingleMax,
          consumeDayMaxNum: param.consumeDayMaxNum,
          consumeDayMax: param.consumeDayMax,
          withdrawSingleMax: param.withdrawSingleMax,
          withdrawDayMaxNum: param.withdrawDayMaxNum,
          withdrawDayMax: param.withdrawDayMax);
      showToast(S.current.save_success);
      state.isLoading.value = false;
      return true;
    } on ApiException catch (error) {
      // showToast(error.message);
      showToast(S.current.request_error);
    } catch (e) {
      print('e:${e.toString()}');
      // update();

    }
    state.isLoading.value = false;
    return false;
  }
}
