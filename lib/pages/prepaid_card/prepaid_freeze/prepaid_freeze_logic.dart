
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../generated/l10n.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../http/net/api_exception.dart';
import '../../../models/prepaid/enums/union_card_state.dart';
import '../../../repositories/prepaid_repository.dart';
import 'prepaid_freeze_state.dart';

class PrepaidFreezeLogic extends GetxController {
  final PrepaidFreezeState state = PrepaidFreezeState();
  final _prepaidRepository = PrepaidRepository();

  void freezeCard(int id) async {
    try {
      await _prepaidRepository.freezeCard(id: id);
      PrepaidCardHelper.updateCardInfo(id,
          cardStatus: UnionCardState.FREEZE.value);
      /// warning
      // final logic = Get.put(WalletManageLogic());
      // logic.update();
      // await getIt<AppRouter>().root.replace(PrepaidResultPageRoute(
      //     title: S.current.freeze_card,
      //     description: S.current.freeze_successfully));
    } on ApiException catch (error) {
      showToast(S.current.request_error);
    } catch (e) {}
  }

  void unFreezeCard(int id) async {
    try {
      await _prepaidRepository.unFreezeCard(id: id);
      PrepaidCardHelper.updateCardInfo(id,
          cardStatus: UnionCardState.NORMAL.value);
      /// warning
      // final logic = Get.put(WalletManageLogic());
      // logic.update();
      // await getIt<AppRouter>().root.replace(PrepaidResultPageRoute(
      //     title: S.current.un_freeze_card,
      //     description: S.current.unfreeze_success));
    } on ApiException catch (error) {
      showToast(S.current.request_error);
    } catch (e) {}
  }
}
