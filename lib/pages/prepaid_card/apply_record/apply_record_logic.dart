
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../http/net/api_exception.dart';
import '../../../repositories/prepaid_repository.dart';
import 'apply_record_state.dart';

class ApplyRecordLogic extends GetxController {
  final ApplyRecordState state = ApplyRecordState();
  final PrepaidRepository _prepaidRepository = PrepaidRepository();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getApplyList();
  }

  void getApplyList() async {
    try {
      state.applyList = await _prepaidRepository.blCardApplyList() ?? [];
      print('state.applyList  ${state.applyList.length}');
      update();
    } on ApiException catch (error) {
      showToast(error.message ?? '');
    } catch (e) {
      print('e: ${e.toString()}');
    }
  }
}
