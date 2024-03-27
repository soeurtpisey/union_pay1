import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../generated/l10n.dart';
import '../../http/net/api_exception.dart';
import '../../models/prepaid/union_pay_apply_param_model.dart';
import '../../repositories/prepaid_repository.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/15 20:00
/// @Description:
/// /////////////////////////////////////////////
class CardApplicationLogic extends GetxController {
  var isLoading = false.obs;
  PrepaidRepository prepaidRepository = PrepaidRepository();

  Future<UnionPayApplyParamModel?> getLastRejectRecord() async {
    UnionPayApplyParamModel? record;
    try {
      isLoading.value = true;
      update();
      record = await prepaidRepository.getLastApplyRecord();
    } on ApiException catch (e) {
      showToast(e.message ?? '');
    } finally {
      isLoading.value = false;
      update();
    }
    return record;
  }

  Future<UnionPayApplyParamModel?> getRejectRecordById(String applyId) async {
    UnionPayApplyParamModel? record;
    try {
      isLoading.value = true;
      update();
      record = await prepaidRepository.getApplyRecord(applyId);
    } on ApiException catch (e) {
      if(e.status=='BONG_LOY_CARD_APPLYING'){
        showToast(S().you_card_apply_status_tips);
      }else{
        showToast(e.message ?? '');
      }
    } finally {
      isLoading.value = false;
      update();
    }
    return record;
  }
}
