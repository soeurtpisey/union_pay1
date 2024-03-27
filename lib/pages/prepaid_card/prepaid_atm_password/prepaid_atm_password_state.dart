
import 'package:get/get.dart';
import '../../../models/prepaid/union_pay_card_active_param_model.dart';

class PrepaidAtmPasswordState {
  PrepaidAtmPasswordState(
      {UnionPayCardActiveParamModel? unionPayCardActiveParamModel}) {
    ///Initialize variables
    ///
    isModify = unionPayCardActiveParamModel == null;
    this.unionPayCardActiveParamModel = unionPayCardActiveParamModel;
  }

  var isModify = false; //是否修改密码

  var isContinue = false.obs;
  var isLoading = false.obs;

  var isForceError = false.obs;

  UnionPayCardActiveParamModel? unionPayCardActiveParamModel;
}
