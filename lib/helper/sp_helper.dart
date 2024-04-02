import 'dart:convert';
import 'package:union_pay/helper/share_preference_keys.dart';

import '../app/base/app.dart';
import '../generated/json/base/json_convert_content.dart';
import '../models/prepaid/res/union_pay_card_res_model.dart';
import '../utils/sp_util.dart';

class SpHelper {
  static List<UnionPayCardResModel>? getPrepaidCardList() {
    var data = SpUtil.getString(SharedPreferencesKeys.PREPAID_CARD_LIST);

    if (data != null && data.isNotEmpty) {
      return JsonConvert.fromJsonAsT<List<UnionPayCardResModel>>(
          jsonDecode(data));
    }
    return null;
  }

  static void setPrepaidCardList(String list) {
    SpUtil.putString(SharedPreferencesKeys.PREPAID_CARD_LIST,
        list);
  }
}