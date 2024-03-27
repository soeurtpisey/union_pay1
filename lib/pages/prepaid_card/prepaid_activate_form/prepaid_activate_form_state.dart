
import 'package:get/get.dart';
import '../../../models/prepaid/union_pay_card_active_param_model.dart';

class PrepaidActivateFormState {
  PrepaidActivateFormState() {
    ///Initialize variables
  }

  var isContinue = false.obs;

  UnionPayCardActiveParamModel unionPayCardActiveParamModel =
      UnionPayCardActiveParamModel();


  String? cardNumberError;
}
