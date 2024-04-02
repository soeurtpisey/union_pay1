
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:union_pay/models/prepaid/union_pay_card_pwd_modify_model.dart';
import '../../../repositories/prepaid_repository.dart';
import 'prepaid_old_atm_password_state.dart';

class PrepaidOldAtmPasswordLogic extends GetxController {
  final PrepaidOldAtmPasswordState state = PrepaidOldAtmPasswordState();
  final PrepaidRepository _prepaidRepository = PrepaidRepository();
  //第一个
  final firstController = TextEditingController();
  final firstFocusNode = FocusNode();

  UnionPayCardPwdModifyModel cardModel = UnionPayCardPwdModifyModel();

  @override
  void onInit() {
    super.onInit();
    firstController.addListener(() {
      var pin = firstController.text;
      state.isContinue.value = pin.length == 6;
      update();
    });
  }

  void updateCardId(int cardId) {
    cardModel.id = cardId;
  }

  void onSubmit() {
    if (state.isContinue.value) {
      var pin = firstController.text;
      cardModel.pinEnc = pin;
      /// warning
      // getIt<AppRouter>().root.push(
      //     PrepaidAtmPasswordPageRoute(unionPayCardPwdModifyModel: cardModel));
    }
  }
}
