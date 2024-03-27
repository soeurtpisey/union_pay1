
import 'dart:convert';

import 'package:flutter/services.dart';

import '../generated/json/base/json_convert_content.dart';
import '../http/api.dart';
import '../models/country_code_info_model.dart';
import '../models/prepaid/apply_status_vo_model.dart';
import '../models/prepaid/enums/union_card_type.dart';
import '../models/prepaid/res/union_pay_apply_list_res_model.dart';
import '../models/prepaid/res/union_pay_apply_res_model.dart';
import '../models/prepaid/res/union_pay_card_active_res_model.dart';
import '../models/prepaid/res/union_pay_card_config_model.dart';
import '../models/prepaid/res/union_pay_card_limit_res_model.dart';
import '../models/prepaid/res/union_pay_card_res_model.dart';
import '../models/prepaid/res/union_pay_customer_res_model.dart';
import '../models/prepaid/res/union_pay_history_res_entity.dart';
import '../models/prepaid/res/union_pay_template_model.dart';
import '../models/prepaid/union_pay_apply_old_param_model.dart';
import '../models/prepaid/union_pay_apply_param_model.dart';
import '../models/prepaid/union_pay_card_active_param_model.dart';
import '../models/prepaid/union_pay_card_limit_param_model.dart';
import '../models/prepaid/union_pay_card_pwd_modify_model.dart';
import '../models/prepaid/union_pay_custom_param_model.dart';
import '../models/region/region_item_model.dart';
import '../widgets/country_selection/code_country.dart';
import 'base_repository.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 13:59
/// @Description: 预付卡
/// /////////////////////////////////////////////

class PrepaidRepository extends BaseRepository {

  Future<List<CountryCode>> getCountryRegion() async {
    var value =
    await rootBundle.loadString('assets/data/country_dial_info.json');
    List list = json.decode(value);
    var result = <CountryCode>[];
    list.forEach((element) {
      var model = CountryCode(
          name: element['name'],
          nameKm: element['nameKm'],
          nameZh: element['nameZh'],
          flagUri: element['flagUri'],
          code: element['code'],
          dialCode: element['dialCode']);
      result.add(model);
    });
    return result;
  }

  Future<List<CountryCodeInfoModel>> getCountryCodeInfo() async {
    var value =
    await rootBundle.loadString('assets/data/country_code_info.json');
    List list = json.decode(value);
    var result = <CountryCodeInfoModel>[];
    list.forEach((element) {
      var model = CountryCodeInfoModel.fromJson(element);
      result.add(model);
    });
    return result;
  }

  Future<UnionPayApplyResModel> unionPayCardApply(
      UnionPayApplyParamModel param) async {
    var response = await appPost(Api.unionPayCardApply, data: param.toJson());
    return UnionPayApplyResModel.fromJson(response.data);
  }

  Future<UnionPayApplyResModel> unionPayCardApplySkip(
      UnionPayApplyParamModel param, int walletId) async {
    var data = param.toJson();
    data['wallet_id'] = walletId;
    var response = await appPost(Api.unionPayCardApplySkip, data: data);
    return UnionPayApplyResModel.fromJson(response.data);
  }

  //卡配置信息
  Future<UnionPayCardConfigModel> blCardConfig(UnionCardType? cardType) async {
    var response =
        await appPost(Api.blCardConfig, data: {'brandId': cardType?.value});
    return UnionPayCardConfigModel.fromJson(response.data);
  }

  //卡列表
  Future<List<UnionPayCardResModel>?> blCardList({bool apiFlag = false}) async {
    var response = await appPost(Api.blCardList, data: {'apiFlag': apiFlag});
    var list =
        JsonConvert.fromJsonAsT<List<UnionPayCardResModel>>(response.data);
    return list;
  }

  //卡密码修改接口
  Future<dynamic> cardPwdModify(UnionPayCardPwdModifyModel param) async {
    var response = await appPut(Api.cardPwdModify, data: param.toJson());
    return response.data;
  }

  // 开卡申请 [老客户]
  Future<UnionPayApplyResModel> unionPayCardOldApply(
      UnionPayApplyOldParamModel param) async {
    var response =
        await appPost(Api.unionPayCardOldApply, data: param.toJson());
    return UnionPayApplyResModel.fromJson(response.data);
  }
  // 开卡申请 [老客户]检查
  Future<UnionPayApplyResModel> unionPayCardOldApplyCheck(
      UnionPayApplyOldParamModel param) async {
    var response =
        await appPost(Api.unionPayCardOpenOldCheck, data: param.toJson());
    return UnionPayApplyResModel.fromJson(response.data);
  }

  // 开卡申请 [老客户]
  Future<UnionPayApplyResModel> unionPayCardOldApplySkip(
      UnionPayApplyOldParamModel param, int walletId) async {
    var data = param.toJson();
    data['wallet_id'] = walletId;
    var response = await appPost(Api.unionPayCardOldApplySkip, data: data);
    return UnionPayApplyResModel.fromJson(response.data);
  }

  //银联卡：实名卡激活
  Future<UnionPayCardActiveResModel> cardInfoActive(
      UnionPayCardActiveParamModel param) async {
    var response = await appPost(Api.cardInfoActive, data: param.toJson());
    return UnionPayCardActiveResModel.fromJson(response.data);
  }

  //获取客户信息
  Future<dynamic> unionPayCardCustomer(String blCustId) async {
    var response = await appGet(Api.unionPayCardCustomer,
        queryParameters: {'blCustId': blCustId});
    return response.data;
  }

  //获取省市信息
  Future<List<RegionItemModel>?> getProvince() async {
    var response = await appPost(Api.getProvince);
    return JsonConvert.fromJsonAsT<List<RegionItemModel>>(response.data);
  }

  //获取区级信息
  Future<List<RegionItemModel>?> getDistricts(int provinceId) async {
    var response = await appPost(Api.getDistricts, data: {'id': provinceId});
    return JsonConvert.fromJsonAsT<List<RegionItemModel>>(response.data);
  }

  //获取分区信息
  Future<List<RegionItemModel>?> getCommunes(int districtId) async {
    var response = await appPost(Api.getCommunes, data: {'id': districtId});
    return JsonConvert.fromJsonAsT<List<RegionItemModel>>(response.data);
  }

  // 银联卡：持卡人姓名查询
  Future<UnionPayCustomerResModel> customerInfoQuery(
      UnionPayCustomParamModel param) async {
    var response = await appPost(Api.customerInfoQuery, data: param.toJson());
    return UnionPayCustomerResModel.fromJson(response.data);
  }

  Future<dynamic> saveOrUpdateTemplate(
      {required String name,
      required String keyId,
      required int keyIdType,
      int? id}) async {
    var response = await appPost(Api.saveOrUpdateTemplate,
        data: {'name': name, 'keyId': keyId, 'keyIdType': keyIdType, 'id': id});
    return response.data;
  }

  //模版列表
  Future<List<UnionPayTemplateModel>?> templateList(
      {int? pageSize = 15, int? page = 1}) async {
    var response = await appGet(Api.templateList, queryParameters: {
      'page': page,
      'size': pageSize,
    });
    return JsonConvert.fromJsonAsT<List<UnionPayTemplateModel>>(response.data);
  }

  //删除模版
  Future<dynamic> delTemplate({required int id}) async {
    var response = await appDelete('${Api.delTemplate}/$id');
    return response.data;
  }

  //冻结卡
  Future<dynamic> freezeCard({int? id}) async {
    var response = await appPut(Api.freezeCard, data: {'id': id});
    return response.data;
  }

  //解冻卡
  Future<dynamic> unFreezeCard({int? id}) async {
    var response = await appPut(Api.unFreezeCard, data: {'id': id});
    return response.data;
  }

  //历史列表
  Future<UnionPayHistoryResEntity?> cardTransactionList(
      {required int cucId,
      String? startTime,
      String? endTime,
      int? pageSize = 15,
      int? page = 1}) async {
    print('startTime  ${startTime}');
    print('endTime  ${endTime}');
    var response = await appGet(Api.cardTransactionList, queryParameters: {
      'cucId': cucId,
      'page': page,
      'size': pageSize,
      'startTime': startTime,
      'endTime': endTime
    });
    return JsonConvert.fromJsonAsT<UnionPayHistoryResEntity>(response.data);
  }

  //历史列表
  Future<UnionPayHistoryResEntity?> cardBongLoyTransactionList(
      {required int cucId,
      String? startTime,
      String? endTime,
      int? pageSize = 15,
      int? page = 1}) async {
    var response =
        await appGet(Api.cardBongLoyTransactionList, queryParameters: {
      'cucId': cucId,
      'page': page,
      'size': pageSize,
      'startTime': startTime,
      'endTime': endTime
    });
    return JsonConvert.fromJsonAsT<UnionPayHistoryResEntity>(response.data);
  }

  //修改单笔消费额度
  Future<dynamic> setCardLimit(UnionPayCardLimitParamModel model) async {
    var response = await appPost(Api.setCardLimit, data: model.toJson());
    return response.data;
  }

  //修改卡别名
  Future<dynamic> accountName(int id, String accountName) async {
    var response = await appPost(Api.accountName,
        data: {'id': id, 'accountName': accountName});
    return response.data;
  }

  //获取申请列表
  Future<List<UnionPayApplyListResModel>?> blCardApplyList() async {
    var response = await appPost(Api.blCardApplyList);
    return JsonConvert.fromJsonAsT<List<UnionPayApplyListResModel>>(
        response.data);
  }

  //检查申请列表
  Future<bool> blCardApplyStatus() async {
    var response = await appPost(Api.blCardApplyStatus);
    return response.data;
  }
  //检查申请列表
  Future<ApplyStatusVoModel> blCardApplyStatusNew() async {
    var response = await appPost(Api.blCardApplyStatusNew);
    return ApplyStatusVoModel.fromJson(response.data);
  }

  //设置cvv
  Future<dynamic> setCardCVV(int id, String cvv) async {
    var response = await appPost(Api.setCardCVV, data: {'id': id, 'cvv': cvv});
    return response.data;
  }

  //查询交易限制
  Future<UnionPayCardLimitResModel?> queryCardLimit(int id) async {
    var response = await appPost(Api.queryCardLimit, data: {'id': id});
    return JsonConvert.fromJsonAsT<UnionPayCardLimitResModel>(response.data);
  }

  //查询交易限制
  Future<String> getCVV(int id) async {
    var response = await appPost(Api.getCVV, data: {'id': id});
    return response.data;
  }

  //获取最新一条拒审记录
  Future<UnionPayApplyParamModel> getLastApplyRecord() async {
    var response = await appPost(Api.getApplyRecord);
    return UnionPayApplyParamModel.fromJson(response.data);
  }



  //根据ID获取拒审记录
  Future<UnionPayApplyParamModel> getApplyRecord(String id) async {
    var response = await appPost(Api.getApplyRecordById,data:{
      'id':id
    });
    return UnionPayApplyParamModel.fromJson(response.data);
  }
}
