
import 'package:get/get.dart';

import '../../../models/prepaid/res/union_pay_card_config_model.dart';

class ApplyPreState {
  ApplyPreState() {
    ///Initialize variables
  }

  //卡信息
  UnionPayCardConfigModel? configModel;

  var loading = false.obs;
}
