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
    loadBankCard();
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

}
