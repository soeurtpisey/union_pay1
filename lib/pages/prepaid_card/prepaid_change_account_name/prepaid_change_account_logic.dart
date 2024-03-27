import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../generated/l10n.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../repositories/prepaid_repository.dart';
import 'prepaid_change_account_state.dart';

class PrepaidChangeAccountNameLogic extends GetxController {
  final PrepaidChangeAccountNameState state = PrepaidChangeAccountNameState();
  final accountNameController = TextEditingController();
  final accountNameFocus = FocusNode();
  final PrepaidRepository _prepaidRepository = PrepaidRepository();


  Future<UnionPayCardResModel?> accountName(UnionPayCardResModel model) async {
    if (state.isLoading.value) {
      return null;
    }

    if (accountNameController.text.trim().isEmpty) {
      showToast(S.current.plz_enter_card_name);
      return null;
    }
    state.isLoading.value = true;
    update();
    try {
      await _prepaidRepository.accountName(
          model.id!, accountNameController.text);
      var updateCardInfo = PrepaidCardHelper.updateCardInfo(model.id!,
          accountName: accountNameController.text);
      state.isLoading.value = false;
      update();
      return updateCardInfo;
    } on ApiException catch (e) {
      showToast(S.current.request_error);
    } catch (e) {
      //
    }
    state.isLoading.value = false;
    update();
    return null;
  }
}
