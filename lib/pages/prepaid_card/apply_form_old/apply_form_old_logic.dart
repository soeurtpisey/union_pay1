
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../generated/l10n.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../repositories/prepaid_repository.dart';
import '../../../utils/log_util.dart';
import 'apply_form_old_state.dart';

class ApplyFormOldLogic extends GetxController {
  final ApplyFormOldState state = ApplyFormOldState();

  final _repository = PrepaidRepository();

  //first name
  // final firstNameController = TextEditingController();
  // final firstNameFocusNode = FocusNode();

  //last name
  // final lastNameController = TextEditingController();
  // final lastNameFocusNode = FocusNode();

  //ID
  final idCardController = TextEditingController();
  final idCardFocusNode = FocusNode();

  //配置信息
  Future<void> getConfig(UnionCardType? type) async {
    try {
      // state.isLoading.value = true;
      state.configModel = await _repository.blCardConfig(type);
      // state.isLoading.value = false;
    } on ApiException catch (e) {
      Log.e(e.message);
      // state.isLoading.value = false;
    }
    // update();
  }

  void checkParams({
    String? certificateType,
  }) async {
    //证件类型
    if (certificateType != null) {
      state.requestParam?.pidType = certificateType;
      if(certificateType=='1'){
        state.idIndex=0;
      }else{
        state.idIndex=1;
      }
    }
  }

  Future<bool> onNextEvent(UnionCardType? type) async {
    if (state.requestParam?.pidType == null) {
      showToast(S.current.please_select_id_card_type);
      return false;
    }

    if (idCardController.text.trim().isNotEmpty) {
      state.requestParam?.pidNo = idCardController.text;
    } else {
      showToast(S.current.please_input_right_id_card);
      return false;
    }
    if (state.configModel == null) {
      try {
        await getConfig(type);
      } catch (e) {
        return false;
      }
    }
    state.isLoading.value=true;
    update();
    try{
      await _repository.unionPayCardOldApplyCheck(state.requestParam!);
    }on ApiException catch(e){
      //
      if(e.status=='BONG_LOY_UNION_PAY_PID_NO_ERROR'){
        state.requestError=S.current.please_input_right_id_card;
      }else if(e.message=='Parameter error : pidType'){
        showToast(S.current.document_type_not_match);
      }else{
        showToast(e.message ?? '');
      }
      state.isLoading.value=false;
      update();
      return false;
    }
    state.isLoading.value=false;
    update();

    print(state.requestParam.toString());
    return true;
  }

  void checkErrorStyle(String text) {
    state.requestError=null;
    update();
  }
}
