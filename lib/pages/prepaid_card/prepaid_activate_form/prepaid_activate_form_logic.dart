
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import 'prepaid_activate_form_state.dart';

class PrepaidActivateFormLogic extends GetxController {
  final PrepaidActivateFormState state = PrepaidActivateFormState();

  PrepaidActivateFormLogic(this.model); //Card No
  final cardNoController = TextEditingController();
  final cardNoFocusNode = FocusNode();

  //Card CVV
  final cardCVVController = TextEditingController();
  final cardCVVFocusNode = FocusNode();

  UnionPayCardResModel model;

  @override
  void onInit() {
    super.onInit();
    cardNoController.addListener(() {
      checkParams();
    });
  }

  void checkParams({String? cardNo}) {
    if (cardNo != null) {
      if (cardNoController.text.trim().isNotEmpty) {
        state.cardNumberError = null;
        update();
      } else {
        state.cardNumberError = S.current.please_input_card_id;
      }

      if (cardNoController.text.trim().endsWith(model.cardId4!)) {
        state.cardNumberError = null;
        update();
      } else {
        state.cardNumberError = S.current.plz_correct_bank_card_number;
      }
    } else {
      if (cardNoController.text.trim().isNotEmpty) {
        state.isContinue.value = true;
      } else {
        state.isContinue.value = false;
      }
    }
  }

  bool onNextEvent() {
    if (cardNoController.text.trim().isNotEmpty) {
      state.unionPayCardActiveParamModel.cardId = cardNoController.text;
    } else {
      state.cardNumberError = S.current.please_input_card_id;
      update();
      return false;
    }

    if (!cardNoController.text.trim().endsWith(model.cardId4!)) {
      state.cardNumberError = S.current.plz_correct_bank_card_number;
      update();
      return false;
    }
    state.unionPayCardActiveParamModel.id = model.id.toString();
    state.unionPayCardActiveParamModel.cvn2 = cardCVVController.text;

    print(state.unionPayCardActiveParamModel.toString());
    return true;
  }
}
