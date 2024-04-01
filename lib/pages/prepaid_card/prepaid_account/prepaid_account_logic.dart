
import 'package:get/get.dart';
import 'package:share/share.dart';
import '../../../app/base/app.dart';
import '../../../generated/l10n.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../repositories/prepaid_repository.dart';
import '../../../utils/clipboard_tool.dart';
import 'prepaid_account_state.dart';

class PrepaidAccountLogic extends GetxController {
  final PrepaidAccountState state = PrepaidAccountState();

  final PrepaidRepository _prepaidRepository = PrepaidRepository();

  @override
  void onInit() {
    super.onInit();
  }

  String getAllAmount() {
    var amount = 0.0;
    PrepaidCardHelper.blCardList.forEach((element) {
      amount += element.availableAmount ?? 00;
    });

    return amount.toString();
  }

  void shareAccount(UnionPayCardResModel data) {
    /// warning
    var userName = '';
        //'${App.userProfile?.profile?.fname} ${App.userProfile?.profile?.lname} ';
    var shareStr = S.current.prepaid_card_share_account(
        'U-Pay', userName, data.cardId ?? '', 'http://upay');
    ClipboardTool.setData(shareStr);
    Share.share(shareStr);
  }
}
