
import 'package:get/get_rx/get_rx.dart';

import '../../../models/prepaid/res/union_pay_card_limit_res_model.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';

class PrepaidManagerState {
  PrepaidManagerState() {
    ///Initialize variables
  }

  UnionPayCardLimitResModel? limitModel;
  var cards = <UnionPayCardResModel>[].obs;
  var currentPage = 0;
  UnionPayCardResModel? currentModel;
  var cardNumVisible = false.obs;
  var loading = false.obs;
}
