
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/http/net/api_exception.dart';
import 'package:union_pay/models/prepaid/res/union_pay_template_model.dart';
import 'package:union_pay/repositories/prepaid_repository.dart';

import 'prepaid_select_template_state.dart';

class PrepaidSelectTemplateLogic extends GetxController {
  final PrepaidSelectTemplateState state = PrepaidSelectTemplateState();
  final _repository = PrepaidRepository();
  var refreshController = RefreshController(initialRefresh: true);
  int page = 1;
  int pageSize = 20;

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  //获取
  void getTemplateList({bool refresh = false}) async {
    if (refresh == true) {
      page = 1;
      state.isLoading = true;
      state.isError = false;
    }

    update();
    try {
      var list =
          await _repository.templateList(pageSize: pageSize, page: page) ?? [];
      if (refresh == true) {
        state.templateList.clear();
      }
      state.templateList.addAll(list);
      onRefreshHandle(refresh, list.length);
    } on ApiException catch (error) {
      showToast(error.message ?? '');
      state.isLoading = false;
      state.isError = true;
    } catch (e) {
      state.isLoading = false;
      state.isError = true;
      print(e.toString());
    }
    if (state.isError) {
      if (refresh) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    }
    update();
  }

  void onRefreshHandle(bool refresh, int length) {
    state.isLoading = false;
    if (refresh == true) {
      refreshController.refreshCompleted();
    } else {
      refreshController.loadComplete();
    }

    if (length == pageSize) {
      //还有下一页
      if (refreshController.footerStatus == LoadStatus.noMore) {
        refreshController.resetNoData();
      }
      page += 1;
    } else {
      //没有下一页
      refreshController.loadNoData();
    }
  }

  //删除
  void deleteTemplate(UnionPayTemplateModel model) async {
    try {
      await _repository.delTemplate(id: model.id!);
      var index = state.templateList.indexOf(model);
      if (index != -1) {
        state.templateList.removeAt(index);
        update();
      }
    } on ApiException catch (error) {
      // showToast(error.message);
      showToast(S.current.request_error);
    } catch (e) {
      print(e.toString());
    }
  }
}
