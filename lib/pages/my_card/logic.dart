import 'package:get/get.dart';
import '../../app/base/app.dart';
import '../../helper/prepaid_card_helper.dart';
import '../../models/prepaid/apply_status_vo_model.dart';
import '../../repositories/prepaid_repository.dart';
import 'state.dart';

class MyCardLogic extends GetxController {
  final MyCardState state = MyCardState();
  PrepaidRepository prepaidRepository = PrepaidRepository();

  @override
  void onInit() {
    super.onInit();
    // loadBalance(isNeedNotification: true);
    loadBankCard();
    // App.balance.addListener(() {
    //   loadBalance();
    // });
  }

  void loadBankCard() async {
    var isEmpty = PrepaidCardHelper.blCardList.isEmpty;
    if (isEmpty) {
      await PrepaidCardHelper.getCardInfo(apiFlag: true);
      update();
    }
  }

  Future<bool> checkStatus() async {
    var isAudit = true;
    try {
      state.loading.value=true;
      update();
      isAudit = await prepaidRepository.blCardApplyStatus();
    } catch (e) {
      //
    }
    state.loading.value=false;
    update();
    return isAudit;
  }


  Future<ApplyStatusVoModel?> checkStatusNew() async {
    ApplyStatusVoModel? applyStatus;
    try {
      state.loading.value=true;
      update();
      applyStatus = await prepaidRepository.blCardApplyStatusNew();
    } catch (e) {
      //
    }
    state.loading.value=false;
    update();
    return applyStatus;
  }

  // void loadBalance({bool isNeedNotification = false}) async {
  //   var balanceVo = await BalanceHelper.getBonusAndBalance();
  //   if (isNeedNotification) {
  //     Application.notificationAccount(balanceVo);
  //   }
  //   state.accountList.clear();
  //   var usdAccount=balanceVo.balanceAndBonus?.getUsdAccount();
  //   if(usdAccount!=null) {
  //     var bonusUsdAccount=balanceVo.balanceAndBonus?.getBonusUsdAccount();
  //     state.accountList.add(WalletAccount(
  //       usdAccount: usdAccount,
  //       bonusUsdAccount: bonusUsdAccount,
  //     ));
  //   }
  //   var khrAccount=balanceVo.balanceAndBonus?.getKhrAccount();
  //   if(khrAccount!=null) {
  //     var bonusKhrAccount=balanceVo.balanceAndBonus?.getBonusKhrAccount();
  //     state.accountList.add(WalletAccount(
  //       khrAccount: khrAccount,
  //       bonusKhrAccount: bonusKhrAccount,
  //     ));
  //   }
  //
  //   balanceVo.balanceAndBonus?.accounts?.forEach((element) {
  //     switch (element.ccy?.toUpperCase()) {
  //       case 'USD':
  //         var bonusUsdAccount = state.accountList
  //             .firstWhereOrNull((element) => element.bonusUsdAccount != null);
  //         if (bonusUsdAccount != null) {
  //           bonusUsdAccount.usdAccount = element;
  //         } else {
  //           state.accountList.add(WalletAccount(
  //             usdAccount: element,
  //           ));
  //         }
  //         break;
  //       case 'BONUS_USD':
  //         var usdAccount = state.accountList
  //             .firstWhereOrNull((element) => element.usdAccount != null);
  //         if (usdAccount != null) {
  //           usdAccount.bonusUsdAccount = element;
  //         } else {
  //           state.accountList.add(WalletAccount(
  //             bonusUsdAccount: element,
  //           ));
  //         }
  //         break;
  //       case 'KHR':
  //         var bonusKhrAccount = state.accountList
  //             .firstWhereOrNull((element) => element.bonusKhrAccount != null);
  //         if (bonusKhrAccount != null) {
  //           bonusKhrAccount.khrAccount = element;
  //         } else {
  //           state.accountList.add(WalletAccount(
  //             khrAccount: element,
  //           ));
  //         }
  //         break;
  //       case 'BONUS_KHR':
  //         var khrAccount = state.accountList
  //             .firstWhereOrNull((element) => element.khrAccount != null);
  //         if (khrAccount != null) {
  //           khrAccount.bonusKhrAccount = element;
  //         } else {
  //           state.accountList.add(WalletAccount(
  //             bonusKhrAccount: element,
  //           ));
  //         }
  //         break;
  //     }
  //   });
  //   //可能会出现有BONUS_KHR但没有KHR的情况
  //   var khrAccount = state.accountList
  //       .firstWhereOrNull((element) => element.khrAccount != null);
  //   var bonusKhrAccount = state.accountList
  //       .firstWhereOrNull((element) => element.bonusKhrAccount != null);
  //   if (khrAccount == null && bonusKhrAccount != null) {
  //     state.accountList
  //         .removeWhere((element) => element.bonusKhrAccount != null);
  //   }
  //   if (state.accountList.isEmpty) {
  //     state.accountList
  //         .add(WalletAccount(isNeedAddCurrency: true, needAddCurrency: 'USD'));
  //   } else if (state.accountList.length == 1) {
  //     var isKHR = state.accountList.first.ccy == 'KHR';
  //     if (isKHR) {
  //       state.accountList.add(
  //           WalletAccount(isNeedAddCurrency: true, needAddCurrency: 'USD'));
  //     } else {
  //       state.accountList.add(
  //           WalletAccount(isNeedAddCurrency: true, needAddCurrency: 'KHR'));
  //     }
  //   }
  //   update();
  // }
  //
  // void toggleBalanceVisible(bool value) {
  //   var visible = !value;
  //   SpHelper.setWalletVisible(visible);
  //   Application.notificationHideWalletManageBalance = visible;
  // }
}
