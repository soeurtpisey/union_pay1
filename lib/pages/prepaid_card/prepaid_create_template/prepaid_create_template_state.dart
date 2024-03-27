
import 'package:get/get_rx/get_rx.dart';
import '../../../models/prepaid/res/union_pay_template_model.dart';

class PrepaidCreateTemplateState {
  PrepaidCreateTemplateState(
      {UnionPayTemplateModel? templateModel, int? transferType}) {
    ///Initialize variables
    this.transferType = transferType;
    this.templateModel = templateModel;
  }
  int? transferType;
  UnionPayTemplateModel? templateModel;
  var isLoading = false.obs;
}
