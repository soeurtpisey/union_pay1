
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../helper/sp_helper.dart';
import '../../../repositories/prepaid_repository.dart';
import 'prepaid_manager_state.dart';

class PrepaidManagerLogic extends GetxController {
  final PrepaidManagerState state = PrepaidManagerState();
  final PageController? controller =
      PageController(initialPage: 0, viewportFraction: 0.9);

  // NBCRepository nbcRepository = NBCRepository();
  //
  // NbcMemberBanks nbcMemberBank = NbcMemberBanks(participantCode: 'BONGKHPPXXX');
  final _repository = PrepaidRepository();

  @override
  void onInit() {
    super.onInit();
    PrepaidCardHelper.getCardInfo(apiFlag: true);
    /// warning
    // state.cardNumVisible.value = SpHelper.getPrepaidVisible();

  }

  void getQueryCardLimit() async {
    try {
      state.limitModel =
          await _repository.queryCardLimit(state.currentModel!.id!);
      update();
    } catch (e) {
      //
    }
  }

  void updateAccountName(String? accountName) async {
    state.currentModel?.accountName = accountName;
    update();
  }

  /// warning
  // Future<NbcAccountModel?> onGetAccount() async {
  //   state.loading.value = true;
  //   update();
  //   NbcAccountModel? model;
  //   try {
  //     var accountNumber = state.currentModel?.cardId;
  //     var data = await nbcRepository.getAccount(
  //         accountNumber: accountNumber,
  //         participantCode: nbcMemberBank.participantCode);
  //     model = JsonConvert.fromJsonAsT<NbcAccountModel>(data);
  //     model?.accountNumber = accountNumber;
  //   } on ApiException catch (e) {
  //     var errorText;
  //     if (e.message ==
  //         'The account ID is not found. Please check the entered data.') {
  //       errorText = S.current.accountId_not_found_check_entered;
  //     } else if (e.message ==
  //         'The account Number is not found. Please check the entered data.') {
  //       errorText = S.current.account_number_not_found_check_entered_data;
  //     } else {
  //       if (e.status == 'OKHTTP_RESPONSE_STATUS_ERROR') {
  //         errorText = S.current.system_error;
  //       } else {
  //         errorText = e.message;
  //       }
  //     }
  //     showToast(errorText);
  //   }
  //   state.loading.value = false;
  //   update();
  //   return model;
  // }

  void pageChanged(int index) {
    print('pageChanged  $index');
    state.currentModel = PrepaidCardHelper.blCardList[index];
    state.currentPage = index;
    update();
  }

  void setCardNumVisible() {
    state.cardNumVisible.value = !state.cardNumVisible.value;
    /// warning
    // SpHelper.setPrepaidVisible(state.cardNumVisible.value);
    update();
  }
}
