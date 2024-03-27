import 'package:get/get.dart';
import '../../../repositories/prepaid_repository.dart';
import 'apply_card_state.dart';

class ApplyCardLogic extends GetxController {
  final ApplyCardState state = ApplyCardState();

  PrepaidRepository prepaidRepository = PrepaidRepository();

  @override
  void onReady() {
    super.onReady();
  }

  Future<bool> checkStatus() async {
    var check = false;
    try {
      check = await prepaidRepository.blCardApplyStatus();
    } catch (e) {
      //
    }
    return check;
  }
}
