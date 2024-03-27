
import 'dart:convert';

import 'package:get/get.dart';
import 'package:union_pay/helper/sp_helper.dart';
import '../app/base/app.dart';
import '../http/net/api_exception.dart';
import '../models/event/refresh_home_data.dart';
import '../models/prepaid/res/union_pay_card_res_model.dart';
import '../repositories/prepaid_repository.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/20 18:49
/// @Description: PrepaidCardHelper
/// /////////////////////////////////////////////
class PrepaidCardHelper {
  static var blCardList = <UnionPayCardResModel>[].obs;

  static var totalAccountAmount = 0.0.obs;
  static final _repository = PrepaidRepository();

  //apiFlag=true 服务端会去刷新bongloy的真实数据，用来矫正余额或者状态
  static Future<void> getCardInfo({bool apiFlag = false}) async {
    try {
      var preData = SpHelper.getPrepaidCardList();
      var isEmpty=true;
      if (preData != null) {
        blCardList.value = preData;
        if(blCardList.isNotEmpty){
          isEmpty=false;
          App.eventBus?.fire(RefreshHomeData());
        }
      }

      var list = await _repository.blCardList(apiFlag: apiFlag) ?? [];
      blCardList.assignAll(list);
      SpHelper.setPrepaidCardList(jsonEncode(blCardList));
      totalAccountAmount.value = 0;
      blCardList.forEach((element) {
        if (element.availableAmount != null) {
          totalAccountAmount.value += element.availableAmount!;
        }
      });
      if(isEmpty&&blCardList.isNotEmpty){
        App.eventBus?.fire(RefreshHomeData());
      }
    } on ApiException catch (error) {
      // showToast(error.message);
    } catch (e) {
       print(e.toString());
    }
  }

  //修改卡对应字段值
  static UnionPayCardResModel? updateCardInfo(int id,
      {int? cardStatus,
      double? consumeSingleMax,
      int? consumeDayMaxNum,
      double? consumeDayMax,
      double? withdrawSingleMax,
      int? withdrawDayMaxNum,
      double? withdrawDayMax,
      String? accountName,
      String? cvv}) {
    var index = blCardList.indexOf(UnionPayCardResModel()..id = id);
    if (index != -1) {
      var data = blCardList[index];
      if (cardStatus != null) {
        data.cardStatus = cardStatus;
      }
      if (consumeSingleMax != null) {
        data.consumeSingleMax = consumeSingleMax;
      }
      if (consumeDayMaxNum != null) {
        data.consumeDayMaxNum = consumeDayMaxNum;
      }

      if (consumeDayMax != null) {
        data.consumeDayMax = consumeDayMax;
      }

      if (withdrawSingleMax != null) {
        data.withdrawSingleMax = withdrawSingleMax;
      }
      if (withdrawDayMaxNum != null) {
        data.withdrawDayMaxNum = withdrawDayMaxNum;
      }
      if (withdrawDayMax != null) {
        data.withdrawDayMax = withdrawDayMax;
      }

      if (accountName != null) {
        data.accountName = accountName;
      }

      if (cvv != null) {
        data.cvn2 = cvv;
      }
      blCardList[index] = data;
      return data;
    }
    return null;
  }

  static void clearCardInfo() {
    blCardList.clear();
    totalAccountAmount.value = 0.0;
  }
}
