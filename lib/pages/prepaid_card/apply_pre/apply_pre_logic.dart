
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../app/base/app.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../models/prepaid/union_pay_apply_old_param_model.dart';
import '../../../models/prepaid/union_pay_apply_param_model.dart';
import '../../../repositories/prepaid_repository.dart';
import 'apply_pre_state.dart';

class ApplyPreLogic extends GetxController {
  final ApplyPreState state = ApplyPreState();
  final PrepaidRepository _prepaidRepository = PrepaidRepository();

  void applyRequest(
      {UnionPayApplyParamModel? param,
      UnionPayApplyOldParamModel? oldParam,
      int? walletId}) async {
    // if (param == null) {
    //   return;
    // }
    state.loading.value = true;
    update();
    try {
      if (isAdminApplyCard) {
        if (oldParam != null) {
          await _prepaidRepository.unionPayCardOldApplySkip(
              oldParam, walletId!);
        } else {
          await _prepaidRepository.unionPayCardApplySkip(param!, walletId!);
        }
      } else {
        if (oldParam == null) {
          await _prepaidRepository.unionPayCardApply(param!);
        } else {
          //老客户
          await _prepaidRepository.unionPayCardOldApply(oldParam);

          if (oldParam.cardType() == UnionCardType.virtualCard) {
            //虚拟卡 直接审核成功 重新获取卡列表，回到卡管理
            PrepaidCardHelper.getCardInfo();
            /// warning
            // getIt<AppRouter>().root.popUntil((route) =>
            //     route.settings.name == WalletManagePageRoute.name ||
            //     route.settings.name == DashboardPageRoute.name);
            // return;
            // getIt<AppRouter>().root.popUntil((route) =>
            //     route.settings.name == WalletManagePageRoute.name ||
            //     route.settings.name == DashboardPageRoute.name);
            // return;
          }
        }
      }
      /// warning
      // App.refreshBalance();
      // await getIt<AppRouter>().root.pushAndPopUntil(ApplyResultPageRoute(),
      //     predicate: (Route<dynamic> route) =>
      //         route.settings.name == WalletManagePageRoute.name ||
      //         route.settings.name == DashboardPageRoute.name);
    } on ApiException catch (error) {
      showToast(error.message ?? '');
    } catch (e) {
      print(e.toString());
    } finally {
      state.loading.value = false;
      update();
    }
  }
}
