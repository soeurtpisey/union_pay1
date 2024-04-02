import 'package:union_pay/models/prepaid/res/union_pay_template_model.dart';

class PrepaidSelectTemplateState {
  PrepaidSelectTemplateState() {
    ///Initialize variables
  }

  bool isLoading = true;
  bool isError = false;
  var templateList = <UnionPayTemplateModel>[];
}
