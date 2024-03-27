import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../app/base/app.dart';
import '../../../generated/l10n.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../models/region/region_item_model.dart';
import '../../../repositories/prepaid_repository.dart';
import '../../../utils/log_util.dart';
import 'apply_address_state.dart';

class ApplyAddressLogic extends GetxController {
  final ApplyAddressState state = ApplyAddressState();

  //address
  final addressController = TextEditingController();
  final addressFocusNode = FocusNode();

  //电话一线
  final phoneOneController = TextEditingController();
  final phoneOneFocusNode = FocusNode();

  //电子邮箱
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final _repository = PrepaidRepository();

  void initListener() {
    addressController.addListener(() {
      checkParam();
    });
    phoneOneController.addListener(() {
      checkParam();
    });
    emailController.addListener(() {
      checkParam();
    });
    if (isAdminApplyCard) {
      var randomString2 = Random().nextInt(100);
      var randomString3 = Random().nextInt(100);
      addressController.text = 'No.$randomString3,Resident ${randomString2} Villa Street';
      var randomString = Random().nextInt(100000000);
      emailController.text = '$randomString@gmail.com';
      getPhone();
    }
  }

  void getPhone() async{
    var user=await App.getLocalUserProfile();
    phoneOneController.text = user?.phone?.replaceAll('855', '')??'';
  }

  @override
  void onInit() {
    super.onInit();
    //获取上一个页面的传参
    initListener();
    getProvince(init: true);
  }

  //配置信息
  Future<void> getConfig(UnionCardType? type) async {
    try {
      state.isLoading.value = true;
      state.configModel = await _repository.blCardConfig(type);
      state.isLoading.value = false;
    } on ApiException catch (e) {
      Log.e(e.message);
      state.isLoading.value = false;
    }
  }

  Future<void> getProvince({bool init = false}) async {
    try {
      var list = await _repository.getProvince();
      state.provinces.clear();
      state.provinces.addAll(list ?? []);
      if (init == true) {
        //默认金边
        var first = state.provinces.where((item) => item?.id == 12).first;
        var index = state.provinces.indexOf(first);
        state.provinceIndex = index;
        state.requestParam?.provincesId = first.id;
        await getDistricts(state.requestParam!.provincesId!);
      } else {
        await getDistricts(list!.first.id!);
      }
      update();
    } on ApiException catch (e) {
      Log.e(e.message);
    }
  }

  Future<void> getDistricts(int provinceId) async {
    try {
      var list = await _repository.getDistricts(provinceId);
      state.districts.clear();
      state.districtIndex = 0;
      state.districts.addAll(list ?? []);
      await getCommunes(state.districts.first.id!);
    } on ApiException catch (e) {
      Log.e(e.message);
    }
  }

  Future<void> getCommunes(int districtId) async {
    try {
      var list = await _repository.getCommunes(districtId);
      state.partitions.clear();
      state.partitionIndex = 0;
      state.partitions.addAll(list ?? []);
    } on ApiException catch (e) {
      Log.e(e.message);
    }
  }

  void checkParam({
    RegionItemModel? province,
    RegionItemModel? district,
    RegionItemModel? partition,
  }) async {
    var address = addressController.text;
    var phoneOne = phoneOneController.text;
    var email = emailController.text;
    var param = state.requestParam;
    if (address != param?.addr) {
      param?.addr = address;
    }
    if (phoneOne != param?.mobile) {
      param?.mobile = '855-$phoneOne';
    }
    if (email != param?.email) {
      param?.email = email;
    }
    if (province != null) {
      state.requestParam?.provincesId = province.id;
      await getDistricts(province.id!);
      update();
    }

    if (district != null) {
      state.requestParam?.districtsId = district.id;
      await getCommunes(district.id!);
      update();
    }
    if (partition != null) {
      state.requestParam?.communesId = partition.id;
    }
    //checkParam
    //update button
  }

  Future<bool> onNextEvent(UnionCardType? type) async {
    if (addressController.text.trim().isNotEmpty) {
      state.requestParam?.addr = addressController.text;
    } else {
      showToast(S.current.validation_enter_address);
      return false;
    }

    if (phoneOneController.text.trim().isNotEmpty &&
        phoneOneController.text.isNumericOnly) {
      state.requestParam?.mobile = phoneOneController.text;
    } else {
      showToast(S.current.invalid_please_enter_correct_phone_number);
      return false;
    }

    if (emailController.text.trim().isNotEmpty &&
        emailController.text.isEmail) {
      state.requestParam?.email = emailController.text;
    } else {
      showToast(S.current.validation_enter_email);
      return false;
    }

    if (state.configModel == null) {
      try {
        await getConfig(type);
      } catch (e) {
        return false;
      }
    }
    if (state.requestParam?.provincesId == null ||
        state.requestParam?.districtsId == null ||
        state.requestParam?.communesId == null) {
      return false;
    }
    state.requestParam?.mobile = '855-${state.requestParam?.mobile}';
    return true;
  }

}
