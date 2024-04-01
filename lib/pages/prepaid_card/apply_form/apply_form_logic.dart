import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_number/phone_number.dart';
import 'package:union_pay/extensions/int_extension.dart';

import '../../../app/base/app.dart';
import '../../../generated/l10n.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/certificate_type.dart';
import '../../../models/country_code_info_model.dart';
import '../../../models/image_model.dart';
import '../../../models/kyc_info_model.dart';
import '../../../models/prepaid/enums/doc_type.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../models/prepaid/union_pay_apply_param_model.dart';
import '../../../models/region/region_item_model.dart';
import '../../../packages/mrz_parse/src/mrz_result.dart';
import '../../../repositories/prepaid_repository.dart';
import '../../../utils/log_util.dart';
import '../../../utils/luban_util.dart';
import '../../../widgets/certificate/certificate_widget.dart';
import '../../../widgets/country_selection/code_country.dart';
import 'apply_form_state.dart';

class ApplyFormLogic extends GetxController {
  final ApplyFormState state = ApplyFormState();

  //first name
  final firstNameController = TextEditingController();
  final firstNameFocusNode = FocusNode();

  //last name
  final lastNameController = TextEditingController();
  final lastNameFocusNode = FocusNode();

  //ID
  final idCardController = TextEditingController();
  final idCardFocusNode = FocusNode();

  KycInfoModel? kycInfo;

  PhoneNumberUtil plugin = PhoneNumberUtil();

  PrepaidRepository prepaidRepository = PrepaidRepository();

  //address
  final addressController = TextEditingController();
  final addressFocusNode = FocusNode();

  //电话一线
  final phoneOneController = TextEditingController();
  final phoneOneFocusNode = FocusNode();

  //电子邮箱
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  var isEdit = false;

  @override
  void onInit() {
    super.onInit();
  }

  void init(
      UnionCardType? unionCardType, UnionPayApplyParamModel? requestParam) {
    isEdit = requestParam != null;
    if (requestParam != null) {
      state.requestParam = requestParam;
    }
    state.requestParam.isEdit = isEdit;
    initListener();
    loadData();
    getProvince(init: true, isEdit: isEdit);
    getConfig(unionCardType);
  }

  Future<UnionPayApplyParamModel?> getLastRejectRecord() async {
    try {
      state.isLoading.value = true;
      update();
      var record = await prepaidRepository.getLastApplyRecord();
      state.requestParam = record;
      update();
    } on ApiException catch (e) {
      showToast(e.message ?? '');
    } finally {
      state.isLoading.value = false;
      update();
    }
    return state.requestParam;
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getProvince({bool init = false, bool isEdit = false}) async {
    try {
      state.provinceLoading = true;
      state.districtsLoading = true;
      state.partitionsLoading = true;
      update();
      var list = await prepaidRepository.getProvince();
      state.provinces.clear();
      state.provinces.addAll(list ?? []);
      if (isEdit) {
        var indexOf = state.provinces
            .indexOf(RegionItemModel(id: state.requestParam.provincesId));
        if (indexOf != -1) {
          state.provinceIndex = indexOf;
          state.requestParam.province = state.provinces[indexOf].item;
          await getDistricts(state.requestParam.provincesId!,
              isEdit: isEdit, hasLoading: true);
        }
      } else {
        if (init == true) {
          //默认金边
          var first = state.provinces.where((item) => item.id == 12).first;
          var index = state.provinces.indexOf(first);
          state.provinceIndex = index;
          state.requestParam.provincesId = first.id;
          state.requestParam.province = first.item;
          await getDistricts(state.requestParam.provincesId!, hasLoading: true);
        } else {
          await getDistricts(list!.first.id!, hasLoading: true);
        }
      }
    } on ApiException catch (e) {
      Log.e(e.message);
    } finally {
      state.provinceLoading = false;
      state.districtsLoading = false;
      state.partitionsLoading = false;
      update();
    }
  }

  Future<void> getDistricts(int provinceId,
      {bool isEdit = false, bool hasLoading = false}) async {
    try {
      if (!hasLoading) {
        state.districtsLoading = true;
        state.partitionsLoading = true;
        update();
      }
      var list = await prepaidRepository.getDistricts(provinceId);
      state.districts.clear();
      state.districts.addAll(list ?? []);
      if (isEdit) {
        var indexOf = state.districts
            .indexOf(RegionItemModel(id: state.requestParam.districtsId));
        if (indexOf != -1) {
          var model = state.districts[indexOf];
          state.districtIndex = indexOf;
          state.requestParam.districts = model.item;
          await getCommunes(state.requestParam.districtsId!,
              isEdit: isEdit, hasLoading: hasLoading);
        }
      } else {
        state.districtIndex = 0;
        state.requestParam.districtsId = state.districts.first.id;
        state.requestParam.districts = state.districts.first.item;
        await getCommunes(state.districts.first.id!, hasLoading: hasLoading);
      }
    } on ApiException catch (e) {
      Log.e(e.message);
    } finally {
      if (!hasLoading) {
        state.districtsLoading = false;
        state.partitionsLoading = false;
        update();
      }
    }
  }

  Future<void> getCommunes(int districtId,
      {bool isEdit = false, bool hasLoading = false}) async {
    try {
      if (!hasLoading) {
        state.partitionsLoading = true;
        update();
      }
      var list = await prepaidRepository.getCommunes(districtId);
      state.partitions.clear();
      state.partitions.addAll(list ?? []);
      if (isEdit) {
        var indexOf = state.partitions
            .indexOf(RegionItemModel(id: state.requestParam.communesId));
        if (indexOf != -1) {
          var model = state.partitions[indexOf];
          state.partitionIndex = indexOf;
          state.requestParam.communes = model.item;
        }
      } else {
        state.partitionIndex = 0;
        state.requestParam.communesId = state.partitions.first.id;
        state.requestParam.communes = state.partitions.first.item;
      }
    } on ApiException catch (e) {
      Log.e(e.message);
    } finally {
      if (!hasLoading) {
        state.partitionsLoading = false;
        update();
      }
    }
  }

  UnionCardType? type;

  //配置信息
  Future<void> getConfig(UnionCardType? type) async {
    try {
      state.requestParam.brandId = type?.value;
      this.type = type;
      state.isLoading.value = true;
      state.configModel = await prepaidRepository.blCardConfig(type);
      state.isLoading.value = false;
    } on ApiException catch (e) {
      Log.e(e.message);
      state.isLoading.value = false;
    }
    update();
  }

  void loadData() async {
    await getRegions();
    if (isEdit) {
      //找到国籍角标
      var nationalityCode = state.requestParam.nationalityCode;
      var index = state.regions.indexWhere((element) {
        var code = element.getNationCode();
        return nationalityCode==code;
      });
      if (index != -1) {
        state.regionIndex.value = index;
        state.requestParam.nationality =
        '${state.regions[index].displayName()} ${state.regions[index].dialCode}';
      }

      //设置数据
      firstNameController.text = state.requestParam.getFirstName();
      lastNameController.text = state.requestParam.getLastName();

      idCardController.text = state.requestParam.pidNo ?? '';

      addressController.text = state.requestParam.addr ?? '';

      phoneOneController.text =
          state.requestParam.mobile?.replaceAll('855-', '') ?? '';

      if (state.requestParam.pidType == '1') {
        state.idTypeIndex = 0;
      } else {
        state.idTypeIndex = 1;
      }

      var idPhotoFront = state.requestParam.idPhotoFront;
      if (idPhotoFront != null) {
        state.base64ImagePhotoFront = idPhotoFront;
      }

      var idPhotoObverse = state.requestParam.idPhotoObverse;
      if (idPhotoObverse != null) {
        state.base64ImagePhotoObverse = idPhotoObverse;
      }
      var headPhoto = state.requestParam.headPhoto;
      if (headPhoto != null) {
        state.base64ImageHeadPhoto = headPhoto;
      }
    } else {
      state.requestParam.nationality =
          '${state.regions[state.regionIndex.value].displayName()} ${state.regions[state.regionIndex.value].dialCode}';
      setNationCode(state.regions[state.regionIndex.value].dialCode);
      state.requestParam.pidType = '1';
      /// warning
      // if (!isAdminApplyCard) {
      //   getKycInfo();
      // }
    }
  }


  void updateNationalityCode(String? country) {
    try {
      var first = state.regions
          .where((p0) =>
              p0.name?.toLowerCase().contains(country?.toLowerCase() ?? '') ==
                  true ||
              p0.code?.toLowerCase().contains(country?.toLowerCase() ?? '') ==
                  true)
          .first;
      var index = state.regions.indexOf(first);
      if (index != -1) {
        state.regionIndex.value = index;
        state.requestParam.nationality =
            '${state.regions[index].displayName()} ${state.regions[index].dialCode}';
        setNationCode(state.regions[index].dialCode);
      }
    } catch (e) {
      //
    }
  }

  bool isKycContinue() {
    return kycInfo?.getType() == DocType.PASSPORT ||
        kycInfo?.getType() == DocType.ID_CARD;
  }

  void initListener() {
    firstNameController.addListener(() {
      checkParams();
    });
    lastNameController.addListener(() {
      checkParams();
    });
    idCardController.addListener(() {
      checkParams(idCard: idCardController.text);
    });
    addressController.addListener(() {
      checkParams(address: addressController.text);
    });
    phoneOneController.addListener(() {
      checkParams(phone: phoneOneController.text);
    });
    // emailController.addListener(() {
    //   checkParams();
    // });
    if (isAdminApplyCard) {
      var randomString2 = Random().nextInt(100);
      var randomString3 = Random().nextInt(100);
      addressController.text =
          'No.${randomString3},Resident ${randomString2} Villa Street';
      var randomString = Random().nextInt(100000000);
      emailController.text = '${randomString}@gmail.com';
    }
    if(!isEdit) {
      getPhone();
    }
  }

  void getPhone() async {
    var user = App.userSession?.userInfo;
    if(user?.phone?.startsWith('855')==true){
      phoneOneController.text = user!.phone!.substring(3,user.phone!.length);
    }
  }

  void unFocus() {
    if (firstNameFocusNode.hasFocus) {
      firstNameFocusNode.unfocus();
    }
    if (lastNameFocusNode.hasFocus) {
      lastNameFocusNode.unfocus();
    }
    if (idCardFocusNode.hasFocus) {
      idCardFocusNode.unfocus();
    }

    if (addressFocusNode.hasFocus) {
      addressFocusNode.unfocus();
    }
    if (phoneOneFocusNode.hasFocus) {
      phoneOneFocusNode.unfocus();
    }
    if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
    }
  }

  MRZResult? mrzResult;

  bool checkMRZ() {
    if (mrzResult == null) {
      return true;
    }
    var surname = mrzResult?.surnames ?? '';
    var givenNames = mrzResult?.givenNames ?? '';
    var documentNumber = mrzResult?.documentNumber ?? '';
    var birthYear = mrzResult?.birthYear() ?? '';
    var birthMonth = mrzResult?.birthMonth() ?? '';
    var birthDay = mrzResult?.birthDay() ?? '';
    var dob = '$birthYear$birthMonth$birthDay';
    var requestParam = state.requestParam;
    if (requestParam.dob != dob) {
      showToast(S.current.birthday_not_match_certificate);
      return false;
    }
    if (requestParam.name != '$surname $givenNames'.toUpperCase()) {
      showToast(S.current.name_not_match_certificate);
      return false;
    }
    if (requestParam.pidType != mrzResult?.getIdType()) {
      showToast(S.current.document_type_not_match);
      return false;
    }
    if (requestParam.pidNo != documentNumber) {
      showToast(S.current.id_number_not_match);
      return false;
    }
    return true;
  }


  void setNationCode(String? dialCode) {
    dialCode = dialCode?.replaceAll('+', '');
    if (dialCode?.length == 2) {
      dialCode = '00$dialCode';
    }
    if (dialCode?.length == 3) {
      dialCode = '0$dialCode';
    }
    state.requestParam.nationalityCode = dialCode;
  }

  void clearUploadFile({
    ImgModel? positiveFile,
    ImgModel? backFile,
    ImgModel? selfieFile,
  }) {
    if (positiveFile != null) {
      state.requestParam.idPhotoFront = null;
    }
    if (backFile != null) {
      state.requestParam.idPhotoObverse = null;
    }
    if (selfieFile != null) {
      state.requestParam.headPhoto = null;
    }
  }

  void checkParams({
    DateTime? birthday,
    CountryCode? nationality,
    CertificateType? certificateType,
    ImgModel? positiveFile,
    MRZResult? mrzResult,
    ImgModel? backFile,
    ImgModel? selfieFile,
    RegionItemModel? province,
    RegionItemModel? district,
    RegionItemModel? partition,
    String? address,
    String? phone,
    String? idCard,
  }) async {
    //生日
    if (birthday != null) {
      var dob =
          '${birthday.year}${birthday.month.addZero()}${birthday.day.addZero()}';
      state.requestParam.dob = dob;
      update();
    }

    //国籍编码
    if (nationality != null) {
      state.requestParam.nationality =
          '${nationality.displayName()} ${nationality.dialCode}';

      setNationCode(nationality.dialCode);
      state.regionIndex.value = state.regions.indexOf(nationality);
      update();
    }
    //证件类型
    if (certificateType != null) {
      state.requestParam.pidType = certificateType.type;
      state.idTypeIndex = state.idItems.indexOf(certificateType);
      update();
    }

    //正面
    if (positiveFile != null) {
      try {
        if (mrzResult != null) {
          this.mrzResult = mrzResult;
          var surname = mrzResult.surnames;
          var givenNames = mrzResult.givenNames;
          var documentNumber = mrzResult.documentNumber;
          var documentType = mrzResult.documentType;
          var nationalityCountryCode = mrzResult.nationalityCountryCode;
          var birthYear = mrzResult.birthYear();
          var birthMonth = mrzResult.birthMonth();
          var birthDay = mrzResult.birthDay();
          var dob = '$birthYear$birthMonth$birthDay';
          if (isKycContinue() && !isAdminApplyCard) {
            //kyc认证
            if (documentNumber.isNotEmpty &&
                kycInfo?.docId?.isNotEmpty == true) {
              if (documentNumber != kycInfo?.docId) {
                showToast(
                    S.current.id_number_not_match_real_name_authentication);
                certificateWidget.currentState?.removeFile(0);
                return;
              }
            }
          }
          if (idCardController.text != documentNumber) {
            idCardController.text = documentNumber;
            state.idCardEnable.value = false;
          }

          if (countryCodes?.isNotEmpty == true) {
            try {
              var countryName = countryCodes
                  ?.firstWhere((element) =>
                      element.iSO3?.toLowerCase() ==
                      nationalityCountryCode.toLowerCase())
                  .countryName;
              updateNationalityCode(countryName);
            } catch (e) {
              //
            }
          }
          if (documentType == 'ID') {
            //身份证
            state.requestParam.pidType = '1';
            state.idTypeIndex = 0;
          } else if (documentType.startsWith('P')) {
            //护照
            state.requestParam.pidType = '3';
            state.idTypeIndex = 1;
          }
          // updateNationalityCode(nationalityCountryCode);
          if (surname.isNotEmpty == true && givenNames.isNotEmpty == true) {
            // if (firstNameController.text.isEmpty) {
            firstNameController.text = givenNames;
            state.firstNameEnable.value = false;
            // }
            // if (lastNameController.text.isEmpty) {
            lastNameController.text = surname;
            state.lastNameEnable.value = false;
            // }

            setName();
          }

          if (state.requestParam.dob != dob) {
            state.requestParam.dob = dob;
          }
          update();
        }
        var file = File(positiveFile.locPath!);
        var filePath = await LubanUtil.luban(
            file, positiveFile.width!, positiveFile.height!);
        var compressFile = File(filePath);
        if (compressFile.existsSync()) {
          var imageBytes = await compressFile.readAsBytes();
          if (imageBytes.isEmpty) {
            imageBytes = await file.readAsBytes();
          }
          if (imageBytes.isNotEmpty) {
            var base64 = base64Encode(imageBytes);
            state.requestParam.idPhotoFront = base64;
          }
          compressFile.deleteSync();
        }
      } catch (e) {
        print(e);
      }
    }
    //背面
    if (backFile != null) {
      try {
        var file = File(backFile.locPath!);
        var filePath =
            await LubanUtil.luban(file, backFile.width!, backFile.height!);
        var compressFile = File(filePath);
        if (compressFile.existsSync()) {
          var imageBytes = await compressFile.readAsBytes();
          if (imageBytes.isEmpty) {
            imageBytes = await file.readAsBytes();
          }
          if (imageBytes.isNotEmpty) {
            var base64 = base64Encode(imageBytes);
            state.requestParam.idPhotoObverse = base64;
          }
          compressFile.deleteSync();
        }
      } catch (e) {
        print(e);
      }
    }

    //自己
    if (selfieFile != null) {
      try {
        var file = File(selfieFile.locPath!);
        var filePath =
            await LubanUtil.luban(file, selfieFile.width!, selfieFile.height!);
        var compressFile = File(filePath);
        if (compressFile.existsSync()) {
          var imageBytes = await compressFile.readAsBytes();
          if (imageBytes.isEmpty) {
            imageBytes = await file.readAsBytes();
          }
          if (imageBytes.isNotEmpty) {
            var base64 = base64Encode(imageBytes);
            state.requestParam.headPhoto = base64;
          }
          compressFile.deleteSync();
        }
      } catch (e) {
        print(e);
      }
    }
    var email = emailController.text;
    var param = state.requestParam;
    if (address != null && address != param.addr) {
      param.addr = address;
    }
    if (phone != null && phone != param.mobile) {
      param.mobile = '855-$phone';
    }
    if (email != param.email) {
      param.email = email;
    }
    if (province != null) {
      var indexOf = state.provinces.indexOf(province);
      state.provinceIndex = indexOf;
      state.requestParam.provincesId = province.id;
      state.requestParam.province = province.item;
      await getDistricts(province.id!);
      update();
    }

    if (district != null) {
      var indexOf = state.districts.indexOf(district);
      state.districtIndex = indexOf;
      state.requestParam.districtsId = district.id;
      state.requestParam.districts = district.item;
      await getCommunes(district.id!);
      update();
    }
    if (partition != null) {
      var indexOf = state.partitions.indexOf(partition);
      state.partitionIndex = indexOf;
      state.requestParam.communesId = partition.id;
      state.requestParam.communes = partition.item;
      update();
    }
  }

  List<CountryCodeInfoModel>? countryCodes;

  Future<void> getRegions() async {
    try {
      var regions = await prepaidRepository.getCountryRegion();
      state.regions.clear();
      state.regions.addAll(regions);
      update();

      countryCodes = await prepaidRepository.getCountryCodeInfo();
    } catch (e) {
      //
      print(e);
    }
  }

  void setName() {
    state.requestParam.fName = firstNameController.text.toUpperCase();
    state.requestParam.lName = lastNameController.text.toUpperCase();
    state.requestParam.name =
        '${lastNameController.text.toUpperCase()} ${firstNameController.text.toUpperCase()}';
  }

  void checkErrorStyle({
    String? firstName,
    String? lastName,
    String? address,
    String? idCard,
    String? phone,
  }) {
    if (firstName != null) {
      if (firstNameController.text.trim().isNotEmpty) {
        state.firstNameError = null;
      } else {
        state.firstNameError = S.current.kycFieldHint_FirstName;
      }
    }

    if (lastName != null) {
      if (lastNameController.text.trim().isEmpty) {
        state.lastNameError = S.current.kycFieldHint_LastName;
      } else {
        state.lastNameError = null;
      }
    }

    if (address != null) {
      if (addressController.text.trim().isNotEmpty) {
        state.addressError = null;
      } else {
        state.addressError = S.current.validation_EnterAddress;
      }
    }

    if (idCard != null) {
      if (idCardController.text.trim().isNotEmpty) {
        state.idNumberError = null;
      } else {
        state.idNumberError = S.current.please_input_right_id_card;
      }
    }

    if (phone != null) {
      if (phoneOneController.text.trim().isNotEmpty &&
          phoneOneController.text.isNumericOnly) {
        state.phoneError = null;
      } else {
        state.phoneError = S.current.invalidPleaseEnterACorrectPhoneNumber;
      }
    }

    update();
  }

  Future<bool> onNextEvent() async {
    if (state.requestParam.nationalityCode == null) {
      showToast(S.current.empty_nationality_tips);
      return false;
    }

    if (state.requestParam.pidType == null) {
      showToast(S.current.please_select_id_card_type);
      return false;
    }

    if (state.requestParam.idPhotoFront == null) {
      showToast(S.current.please_upload_id_photo_front);
      return false;
    }

    if (state.requestParam.idPhotoObverse == null) {
      showToast(S.current.please_upload_id_photo_obverse);
      return false;
    }

    if (state.requestParam.headPhoto == null) {
      showToast(S.current.please_upload_self_photo);
      return false;
    }

    if (idCardController.text.trim().isNotEmpty) {
      state.requestParam.pidNo = idCardController.text;
    } else {
      showToast(S.current.please_input_right_id_card);
      state.idNumberError = S.current.please_input_right_id_card;
      update();
      return false;
    }

    if (firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty) {
      setName();
    } else if (firstNameController.text.trim().isEmpty) {
      showToast(S.current.please_input_right_name);
      state.firstNameError = S.current.please_input_right_name;
      update();
      return false;
    } else if (lastNameController.text.trim().isEmpty) {
      showToast(S.current.please_input_right_name);
      state.lastNameError = S.current.please_input_right_name;
      update();
      return false;
    }

    if (state.requestParam.dob == null) {
      showToast(S.current.please_select_the_date_of_birth);
      return false;
    }

    if (!checkMRZ()) {
      return false;
    }
    if (kycInfo?.docId != null) {
      if (kycInfo?.getType() == DocType.ID_CARD) {
        if (state.requestParam.pidType != '1') {
          //
          showToast(S.current.certificate_type_match_real_name_authentication);
          return false;
        }
      } else if (kycInfo?.getType() == DocType.PASSPORT) {
        if (state.requestParam.pidType != '3') {
          //
          showToast(S.current.certificate_type_match_real_name_authentication);
          return false;
        }
      }
      if (state.requestParam.pidNo?.toLowerCase() !=
          kycInfo?.docId?.toLowerCase()) {
        showToast(S.current.id_number_does_match_real_name_authentication);
        return false;
      }
    }

    if (addressController.text.trim().isNotEmpty) {
      state.requestParam.addr = addressController.text;
    } else {
      showToast(S.current.validation_EnterAddress);
      state.addressError = S.current.validation_EnterAddress;
      update();
      return false;
    }

    if (phoneOneController.text.trim().isNotEmpty &&
        phoneOneController.text.isNumericOnly) {
      String phone;
      if (phoneOneController.text.startsWith('0')) {
        phone = phoneOneController.text
            .substring(1, phoneOneController.text.length);
      } else {
        phone = phoneOneController.text;
      }
      state.requestParam.mobile = phone;
    } else {
      state.phoneError = S.current.invalidPleaseEnterACorrectPhoneNumber;
      update();
      showToast(S.current.invalidPleaseEnterACorrectPhoneNumber);
      return false;
    }

    if (state.configModel == null) {
      try {
        await getConfig(type);
        return false;
      } catch (e) {
        return false;
      }
    }
    if (state.requestParam.provincesId == null ||
        state.requestParam.districtsId == null ||
        state.requestParam.communesId == null) {
      return false;
    }
    state.requestParam.mobile = '855-${state.requestParam.mobile}';

    print(state.requestParam.toString());
    return true;
  }
}
