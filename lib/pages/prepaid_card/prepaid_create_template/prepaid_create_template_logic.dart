import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../generated/l10n.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/prepaid/enums/union_card_transfer_type.dart';
import '../../../models/prepaid/res/union_pay_template_model.dart';
import '../../../repositories/prepaid_repository.dart';
import '../prepaid_home/prepaid_home_logic.dart';
import 'prepaid_create_template_state.dart';

class PrepaidCreateTemplateLogic extends GetxController {
  late PrepaidCreateTemplateState state;
  PrepaidCreateTemplateLogic(
      {UnionPayTemplateModel? templateModel, int? transferType}) {
    state = PrepaidCreateTemplateState(
      templateModel: templateModel,
      transferType: transferType,
    );
  }

  final _repository = PrepaidRepository();

  final nameController = TextEditingController();
  final cardNumController = TextEditingController();
  final nameFocusNode = FocusNode();
  final cardNumFocusNode = FocusNode();

  @override
  void onReady() {
    super.onReady();
    if (state.templateModel != null) {
      nameController.text = state.templateModel?.name ?? '';
      cardNumController.text = state.templateModel?.keyId ?? '';
    }
  }

  void saveTemplate() async {
    if (nameController.text.isEmpty) {
      return;
    }
    if (cardNumController.text.isEmpty) {
      return;
    }

    try {
      print('state.transferType  ${state.transferType}');
      state.isLoading.value = true;
      update();
      await _repository.saveOrUpdateTemplate(
          id: state.templateModel?.id,
          name: nameController.text,
          keyId: cardNumController.text,
          keyIdType:
              state.transferType ?? UnionCardTransferType.toSelfAccount.value);

      if (state.templateModel != null) {
        //修改
        state.templateModel?.name = nameController.text;
        state.templateModel?.keyId = cardNumController.text;
        /// warning
        // if (Get.isRegistered<PrepaidHomeLogic>()) {
        //   var homeLogic = Get.find<PrepaidHomeLogic>();
        //   homeLogic.updateTemplate(state.templateModel!);
        // }
        /// warning
        // await getIt<AppRouter>().root.pop(state.templateModel);
      } else {
        /// warning
        // await getIt<AppRouter>().root.pop();
      }
    } on ApiException catch (error) {
      state.isLoading.value = false;
      if (error.status=='BONG_LOY_TEMPLATE_EXIST') {
        showToast(S.current.favorite_already_exists);
      }else{
        showToast(error.message ?? '');
      }
    } catch (e) {
      state.isLoading.value = false;
      print(e.toString());
    }
    update();
  }
}
