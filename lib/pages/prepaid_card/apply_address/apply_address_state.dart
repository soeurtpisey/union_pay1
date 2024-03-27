import 'package:get/get_rx/get_rx.dart';
import '../../../models/prepaid/res/union_pay_card_config_model.dart';
import '../../../models/prepaid/union_pay_apply_param_model.dart';
import '../../../models/region/region_item_model.dart';

class ApplyAddressState {
  ApplyAddressState() {
    ///Initialize variables
  }

  UnionPayApplyParamModel? requestParam;
  UnionPayCardConfigModel? configModel;

  var isContinue = true.obs;

  //省市
  var provinces = <RegionItemModel>[].obs;
  var provinceIndex = 0;

  var districts = <RegionItemModel>[].obs;
  var districtIndex = 0;

  var partitions = <RegionItemModel>[].obs;
  var partitionIndex = 0;

  var isLoading = false.obs;
}
