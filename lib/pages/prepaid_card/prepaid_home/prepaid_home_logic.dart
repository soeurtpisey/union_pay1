// import 'package:bank_app/generated/l10n.dart';
// import 'package:bank_app/helpers/prepaid_card_helper.dart';
// import 'package:bank_app/http/http.dart';
// import 'package:bank_app/models/prepaid/res/union_pay_template_model.dart';
// import 'package:bank_app/repositories/prepaid_repository.dart';
// import 'package:bank_app/utils/toast.dart';
// import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import 'prepaid_home_state.dart';
//
// class PrepaidHomeLogic extends GetxController {
//   final PrepaidHomeState state = PrepaidHomeState();
//
//   final _repository = PrepaidRepository();
//   // final managerLogic = Get.put(PrepaidManagerLogic());
//   final refreshController = RefreshController(initialRefresh: false);
//
//   int page = 1;
//   int pageSize = 20;
//
//   @override
//   void onInit() {
//     super.onInit();
//     PrepaidCardHelper.getCardInfo(apiFlag: true);
//     getTemplateList(refresh: true);
//   }
//
//   // void getCardInfo() async {
//   //   try {
//   //     var blCardList = await _repository.blCardList();
//   //     managerLogic.state.cards.addAll(blCardList ?? []);
//   //   } on ApiException catch (error) {
//   //     showToast(error.message);
//   //   } catch (e) {
//   //     print(e.toString());
//   //   }
//   // }
//
//   void getTemplateList({bool refresh = false}) async {
//     if (refresh == true) {
//       page = 1;
//       state.isLoading = true;
//       state.isError = false;
//     }
//
//     try {
//       update();
//
//       var list =
//           await _repository.templateList(pageSize: pageSize, page: page) ?? [];
//       if (refresh == true) {
//         state.templateList.clear();
//       }
//       state.templateList.addAll(list);
//       onRefreshHandle(refresh, list.length);
//     } on ApiException catch (error) {
//       showToast(error.message);
//       state.isError = true;
//     } catch (e) {
//       state.isError = true;
//       print(e.toString());
//     }
//     state.isLoading = false;
//     if (state.isError) {
//       if (refresh) {
//         refreshController.refreshFailed();
//       } else {
//         refreshController.loadFailed();
//       }
//     }
//     update();
//   }
//
//   void onRefreshHandle(bool refresh, int length) {
//     state.isLoading = false;
//     if (refresh == true) {
//       refreshController.refreshCompleted();
//     } else {
//       refreshController.loadComplete();
//     }
//
//     if (length == pageSize) {
//       //还有下一页
//       if (refreshController.footerStatus == LoadStatus.noMore) {
//         refreshController.resetNoData();
//       }
//       page += 1;
//     } else {
//       //没有下一页
//       refreshController.loadNoData();
//     }
//   }
//
//   void deleteTemplate(UnionPayTemplateModel model) async {
//     try {
//       await _repository.delTemplate(id: model.id!);
//       var index = state.templateList.indexOf(model);
//       if (index != -1) {
//         state.templateList.removeAt(index);
//         update();
//       }
//     } on ApiException catch (error) {
//       // showToast(error.message);
//       showToast(S.current.request_error);
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   void updateTemplate(UnionPayTemplateModel model) {
//     var index = state.templateList.indexOf(model);
//     if (index != -1) {
//       state.templateList[index] = model;
//       update();
//     }
//   }
// }
