
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:union_pay/extensions/string_extension.dart';

import '../../../generated/l10n.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/prepaid/union_pay_card_active_param_model.dart';
import '../../../models/prepaid/union_pay_card_pwd_modify_model.dart';
import '../../../repositories/prepaid_repository.dart';
import 'prepaid_atm_password_state.dart';

class PrepaidAtmPasswordLogic extends GetxController {
  // final bool? isModify;
  final UnionPayCardActiveParamModel? unionPayCardActiveParamModel;
  late PrepaidAtmPasswordState state;
  PrepaidAtmPasswordLogic(this.unionPayCardActiveParamModel) {
    state = PrepaidAtmPasswordState(
        unionPayCardActiveParamModel: unionPayCardActiveParamModel);
  }

  //
  UnionPayCardPwdModifyModel? cardPwdModifyModel;

  final PrepaidRepository _prepaidRepository = PrepaidRepository();
  //第一个
  final firstController = TextEditingController();
  final firstFocusNode = FocusNode();

  //第二个
  final secondController = TextEditingController();
  final secondFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

    firstFocusNode.requestFocus();
    secondController.addListener(() {
      onVerification();
      update();
    });
  }

  void onVerification({bool isForce = false}) {
    var first = firstController.text;
    var second = secondController.text;
    var isContinue = false;
    var isForceError = false;
    if (first.isNotEmpty && second.isNotEmpty) {
      if (first == second) {
        isContinue = true;
      } else {
        //输入二次密码不同，进行错误提示
        if (isForce) {
          isForceError = true;
        }
      }
    }
    if (!firstController.text.trim().checkPin()) {
      isForceError = true;
    }

    state.isContinue.value = isContinue;
    state.isForceError.value = isForceError;
    // print('state.isContinue.value  ${state.isContinue.value}');
    // print('state.isForceError.value  ${state.isForceError.value}');
  }

  void onFirstDone() {
    if (firstFocusNode.hasFocus) {
      firstFocusNode.unfocus();
    }
    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => secondFocusNode.requestFocus());
  }

  void onSecondDone() {
    if (firstFocusNode.hasFocus) {
      firstFocusNode.unfocus();
    }
    if (secondFocusNode.hasFocus) {
      secondFocusNode.unfocus();
    }

    onVerification(isForce: true);
    if (state.isContinue.value && !state.isForceError.value) {
      onDone();
    }
  }

  void onDone() async {
    var pin = secondController.text;
    state.isLoading.value = true;
    update();
    try {
      if (state.isModify) {
        cardPwdModifyModel?.newPinEnc = pin;
        print('修改密码');
        await _prepaidRepository.cardPwdModify(cardPwdModifyModel!);
        /// warning
        // await getIt<AppRouter>().root.pushAndPopUntil(
        //     PrepaidResultPageRoute(
        //         title: S.current.reset_atm_pwd,
        //         resultTitle: S.current.modify_atm_pwd_success,
        //         description: ''),
        //     predicate: (Route<dynamic> route) => RouteHelper.predicateX(route,
        //         pageRoute: WalletManagePageRoute.name));
      } else {
        print('设置密码 ${state.unionPayCardActiveParamModel.toString()}');
        //激活的时候设置密码
        state.unionPayCardActiveParamModel?.newPin = pin;
        await _prepaidRepository
            .cardInfoActive(state.unionPayCardActiveParamModel!);
        await PrepaidCardHelper.getCardInfo(apiFlag: true);
        /// warning
        // await getIt<AppRouter>().root.pushAndPopUntil(
        //     PrepaidResultPageRoute(
        //         title: S.current.prepaid_activate_result,
        //         resultTitle: S.current.prepaid_activate_success,
        //         description: ''),
        //     predicate: (Route<dynamic> route) => RouteHelper.predicateX(route,
        //         pageRoute: DashboardPageRoute.name));
      }
    } on ApiException catch (error) {
      showToast(error.message ?? '');
    } catch (e) {
      print(e.toString());
    }
    state.isLoading.value = false;
    update();
  }
}
