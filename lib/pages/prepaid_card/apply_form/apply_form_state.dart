
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../models/certificate_type.dart';
import '../../../models/prepaid/res/union_pay_card_config_model.dart';
import '../../../models/prepaid/union_pay_apply_param_model.dart';
import '../../../models/region/region_item_model.dart';
import '../../../res/images_res.dart';
import '../../../widgets/country_selection/code_country.dart';

class ApplyFormState {
  ApplyFormState() {
    ///Initialize variables
  }

  var serviceProviders = <ServiceProvider>[
    ServiceProvider(
        assetPath: ImagesRes.IC_SERVICE_PROVIDER_UNIONPAY,
        isSelect: true,
        enable: true),
    ServiceProvider(
        assetPath: ImagesRes.IC_SERVICE_PROVIDER_VISA, isSelect: false),
    ServiceProvider(
        assetPath: ImagesRes.IC_SERVICE_PROVIDER_MASTER, isSelect: false),
  ].obs;

  var regions = <CountryCode>[].obs;
  var regionIndex = 36.obs;

  var firstNameEnable = true.obs;
  var lastNameEnable = true.obs;
  var idCardEnable = true.obs;

  var isContinue = true.obs;
  UnionPayApplyParamModel requestParam = UnionPayApplyParamModel();
  final List<CertificateType> idItems = [
    CertificateType('1', S.current.kycDocType_IdCard),
    CertificateType('3', S.current.kycDocType_Passport),
  ].obs;

  var idTypeIndex = 0;

  UnionPayCardConfigModel? configModel;

  //省市
  var provinces = <RegionItemModel>[].obs;
  var provinceIndex = 0;
  var provinceLoading=false;

  var districts = <RegionItemModel>[].obs;
  var districtIndex = 0;
  var districtsLoading=false;

  var partitions = <RegionItemModel>[].obs;
  var partitionIndex = 0;
  var partitionsLoading=false;


  var isLoading = false.obs;

  String? idNumberError;
  String? firstNameError;
  String? lastNameError;
  String? phoneError;
  String? addressError;


  String? base64ImagePhotoFront;
  String? base64ImagePhotoObverse;
  String? base64ImageHeadPhoto;


}

class ServiceProvider {
  String? assetPath;
  bool? isSelect;
  bool? enable;

  ServiceProvider({this.assetPath, this.isSelect, this.enable = false});
}
