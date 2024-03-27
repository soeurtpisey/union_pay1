import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../generated/l10n.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../http/net/api_exception.dart';
import '../../../repositories/prepaid_repository.dart';
import 'prepaid_cvv_state.dart';

class PrepaidCvvLogic extends GetxController {
  final PrepaidCvvState state = PrepaidCvvState();

  final _prepaidRepository = PrepaidRepository();
  final control = TextEditingController();
  final focusNode = FocusNode();

  Future<void> getCVV(int? id) async {
    if (id != null) {
      try {
        state.isLoading.value = true;
        state.cvn2.value = await _prepaidRepository.getCVV(id);
      } on ApiException catch (error) {
        showToast(S.current.request_error);
      } catch (e) {
        print('e: ${e.toString()}');
      }
      state.isLoading.value = false;
    }
  }

  Future<bool> setCvv(int id) async {
    if (control.text.trim().isEmpty) {
      return false;
    }

    try {
      state.isLoading.value = true;
      await _prepaidRepository.setCardCVV(id, control.text);
      PrepaidCardHelper.updateCardInfo(
        id,
      );
      state.isLoading.value = false;
      return true;
    } on ApiException catch (error) {
      showToast(error.message ?? '');
    } catch (e) {
      print('e: ${e.toString()}');
    }
    state.isLoading.value = false;
    return false;
  }
}
