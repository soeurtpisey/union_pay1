import 'package:get/get.dart';
import '../../models/prepaid/res/union_pay_card_res_model.dart';

class MyCardState {
  MyCardState() {
    ///Initialize variables
  }

  var blCardList = <UnionPayCardResModel>[].obs;

  var loading=false.obs;
}

