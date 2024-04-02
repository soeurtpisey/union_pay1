
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../models/prepaid/res/union_pay_card_limit_res_model.dart';

class PrepaidModifyCardLimitState {
  PrepaidModifyCardLimitState() {
    ///Initialize variables
  }

  var isInit = true.obs;
  var isLoading = false.obs;

  //消费次数
  var consumptionTimes = 0.0.obs;
  // //消费次数最大值
  var consumptionMaxTimes = 10.0.obs;
  //消费次数最小值
  var consumptionMinTimes = 1.0.obs;

  //提现次数
  var withdrawalTimes = 0.0.obs;
  // //提现次数最大值
  var withdrawalMaxTimes = 10.0.obs;
  //提现次数最小值
  var withdrawalMinTimes = 1.0.obs;

  UnionPayCardLimitResModel? limitModel;
}
