// import 'package:bank_app/http/http.dart';
// import 'package:bank_app/models/prepaid/res/union_pay_card_res_model.dart';
// import 'package:bank_app/repositories/prepaid_repository.dart';
// import 'package:bank_app/utils/toast.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import 'prepaid_history_state.dart';
//
// class PrepaidHistoryLogic extends GetxController {
//   PrepaidHistoryLogic(UnionPayCardResModel model) {
//     this.model = model;
//   }
//
//   final PrepaidHistoryState state = PrepaidHistoryState();
//   final _repository = PrepaidRepository();
//   var refreshController = RefreshController(initialRefresh: false);
//   late UnionPayCardResModel model;
//   int page = 1;
//   int pageSize = 20;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     //进来默认是按月搜索
//     var now = DateTime.now();
//     //默认当前时间前3个月
//     selectTime(state.filterType, DateTime(now.year, now.month - 3, now.day));
//   }
//
//   bool hasNext(int index) {
//     if (state.historyList.length > index) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   bool hasPrevious(int index) {
//     if (index >= 0) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   bool isOnlyOne(int index) {
//     var previous = index - 1;
//     var next = index + 1;
//     var previousDate;
//     var nextDate;
//     var currentItem = state.historyList[index];
//     var currentDate = currentItem.parseDate();
//     if (hasPrevious(previous)) {
//       var previousItem = state.historyList[previous];
//       previousDate = previousItem.parseDate();
//     }
//     if (hasNext(next)) {
//       var nextItem = state.historyList[next];
//       nextDate = nextItem.parseDate();
//     }
//     if (previousDate != null &&
//         nextDate != null &&
//         previousDate != currentDate &&
//         nextDate != currentDate) {
//       return true;
//     } else if (previousDate != null &&
//         previousDate != currentDate &&
//         nextDate == null) {
//       return true;
//     } else if (nextDate != null &&
//         nextDate != currentDate &&
//         previousDate == null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   bool isGroupTop(int index) {
//     var previous = index - 1;
//     var currentItem = state.historyList[index];
//     var currentDate = currentItem.parseDate();
//     var previousDate;
//     if (hasPrevious(previous)) {
//       var previousItem = state.historyList[previous];
//       previousDate = previousItem.parseDate();
//     }
//     if (previousDate != null) {
//       return previousDate != currentDate ? true : false;
//     } else {
//       return true;
//     }
//   }
//
//   bool isGroupBottom(int index) {
//     var next = index + 1;
//     var currentItem = state.historyList[index];
//     var currentDate = currentItem.parseDate();
//     var nextDate;
//     if (hasNext(next)) {
//       var nextItem = state.historyList[next];
//       nextDate = nextItem.parseDate();
//     }
//     if (nextDate != null) {
//       return nextDate != currentDate ? true : false;
//     } else {
//       return true;
//     }
//   }
//
//   void getHistoryList({bool refresh = false}) async {
//     if (refresh == true) {
//       page = 1;
//       state.isLoading = true;
//       state.isError = false;
//     }
//     update();
//     try {
//       var data = await _repository.cardBongLoyTransactionList(
//           cucId: model.id!,
//           pageSize: pageSize,
//           page: page,
//           startTime: state.startTime,
//           endTime: state.endTime);
//       if (refresh == true) {
//         state.historyList.clear();
//       }
//       state.transferAmount = data?.transferNum ?? 0.0;
//       state.topUpAmount = data?.topUpNum ?? 0.0;
//       state.historyList.addAll(data?.bongLoyCardOrderDtoList ?? []);
//       onRefreshHandle(refresh, (data?.bongLoyCardOrderDtoList ?? []).length);
//     } on ApiException catch (error) {
//       showToast(error.message);
//       state.isError = true;
//     } catch (e) {
//       state.isError = true;
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
//   //设置时间
//   void selectTime(String timeType, DateTime time) {
//     state.filterType = timeType;
//     var startTimeStr = '';
//     var endTimeStr = '';
//     if (timeType == 'yyyy') {
//       //年度搜索
//       var startTime = DateTime(time.year); //本年第一天
//       var firstNextMonthDay = DateTime(time.year + 1); //明年第一天
//       var endTime = firstNextMonthDay.subtract(Duration(days: 1)); //减一天,得本年最后一天
//       startTimeStr = DateFormat('yyyy-MM-dd 00:00:00').format(startTime);
//       endTimeStr = DateFormat('yyyy-MM-dd 23:59:59').format(endTime);
//     } else if (timeType == 'yyyy-MM') {
//       //月度搜索搜索
//       var startTime = DateTime(time.year, time.month); //本月第一天
//       var firstNextMonthDay = DateTime(time.year, time.month + 1); //下月第一天
//       var endTime = firstNextMonthDay.subtract(Duration(days: 1)); //减一天,得本月最后一天
//
//       startTimeStr = DateFormat('yyyy-MM-dd 00:00:00').format(startTime);
//       endTimeStr = DateFormat('yyyy-MM-dd 23:59:59').format(endTime);
//     } else if (timeType == 'yyyy-MM-d') {
//       //日度搜索
//       startTimeStr = DateFormat('yyyy-MM-dd 00:00:00').format(time);
//       endTimeStr = DateFormat('yyyy-MM-dd 23:59:59').format(time);
//     }
//
//     // print(startTimeStr); //2022-03-10_00:00:00
//     // print(endTimeStr); //2022-03-10_23:59:59
//     // print(state.startTime);
//     // print(state.endTime);
//     state.startTime = startTimeStr;
//     state.endTime = endTimeStr;
//     update();
//     getHistoryList(refresh: true);
//   }
// }
