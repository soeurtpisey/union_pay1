// import 'package:bank_app/base/routing/router.dart';
// import 'package:bank_app/extension/extensions.dart';
// import 'package:bank_app/generated/l10n.dart';
// import 'package:bank_app/helpers/NumberHelper.dart';
// import 'package:bank_app/models/prepaid/res/union_pay_card_res_model.dart';
// import 'package:bank_app/models/prepaid/res/union_pay_history_res_entity.dart';
// import 'package:bank_app/pages/prepaid_card/select_date/select_date_view.dart';
// import 'package:bank_app/res/assets_res.dart';
// import 'package:bank_app/style/custom_decoration.dart';
// import 'package:bank_app/utils/colors.dart';
// import 'package:bank_app/utils/date_util.dart';
// import 'package:bank_app/utils/screen_util.dart';
// import 'package:bank_app/utils/styles.dart';
// import 'package:bank_app/widgets/common.dart';
// import 'package:bank_app/widgets/prepaid_card/form_common.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:grouped_list/sliver_grouped_list.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import 'prepaid_history_logic.dart';
// import 'prepaid_history_state.dart';
//
// /// ////////////////////////////////////////////
// /// @author: SJD
// /// @Date: 2022/12/14 18:05
// /// @Description: 预付卡历史页
// /// /////////////////////////////////////////////
// class PrepaidHistoryPage extends StatefulWidget {
//   final UnionPayCardResModel model;
//
//   const PrepaidHistoryPage({Key? key, required this.model}) : super(key: key);
//
//   @override
//   _PrepaidHistoryPageState createState() => _PrepaidHistoryPageState();
// }
//
// class _PrepaidHistoryPageState extends State<PrepaidHistoryPage> {
//   late PrepaidHistoryLogic
//       logic; //= Get.put(PrepaidHistoryLogic(widget.cucId));
//   late PrepaidHistoryState state; //= Get.find<PrepaidHistoryLogic>().state;
//   @override
//   void initState() {
//     super.initState();
//     logic = Get.put(PrepaidHistoryLogic(widget.model));
//     state = Get.find<PrepaidHistoryLogic>().state;
//   }
//
//   @override
//   void dispose() {
//     Get.delete<PrepaidHistoryLogic>();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return cScaffold(context, S.of(context).history,
//         backgroundColor: AppColors.colorE9EBF5,
//         appBarBgColor: AppColors.colorE9EBF5,
//         actions: [
//           IconButton(
//               onPressed: () {
//                 _showDataSelect();
//               },
//               icon: AssetsRes.IC_CARD_HISTORY_CALENDAR.UIImage())
//         ],
//         child: GetBuilder(
//             init: logic,
//             builder: (controller) {
//               return SmartRefresher(
//                   controller: logic.refreshController,
//                   onRefresh: () => logic.getHistoryList(refresh: true),
//                   onLoading: () => logic.getHistoryList(),
//                   enablePullUp: true,
//                   header: const MaterialClassicHeader(
//                     color: Colors.black,
//                   ),
//                   footer: ClassicFooter(
//                     noDataText: S.current.no_more_data,
//                   ),
//                   child: CustomScrollView(
//                     slivers: [
//                       SliverPadding(
//                           padding: EdgeInsets.symmetric(horizontal: 15),
//                           sliver: SliverGroupedListView<dynamic, String>(
//                             elements: state.historyList,
//                             sort: false,
//                             groupBy: (element) => element.parseDate(),
//                             groupSeparatorBuilder: (value) {
//                               return Container(
//                                 margin: EdgeInsets.only(
//                                     left: 16, bottom: 10, top: 16),
//                                 child: cText(value,
//                                     textAlign: TextAlign.start,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 17,
//                                     color: Colors.black),
//                               );
//                             },
//                             indexedItemBuilder: (context, element, index) =>
//                                 buildItem(element, index),
//                           ))
//                     ],
//                   ));
//               // return CustomScrollView(
//               //   slivers: [/*_headWidget(), *//*_timeSelectWidget(), */_historyList()],
//               // );
//             }));
//   }
//
//   Widget _headWidget() {
//     return SliverToBoxAdapter(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Gaps.hGap16,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               cText(S.current.available_balance('\$'),
//                   color: AppColors.colorA6FFFFFF, textAlign: TextAlign.left),
//               Gaps.vGap5,
//               cText(widget.model.availableAmount.toString().formatCurrency(),
//                   fontSize: 36,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                   textAlign: TextAlign.left),
//               Gaps.vGap40,
//             ],
//           ).intoExpend(flex: 2),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               cText(S.current.account_balance('\$'),
//                   color: AppColors.colorA6FFFFFF, textAlign: TextAlign.left),
//               Gaps.vGap5,
//               cText(widget.model.accountAmount.toString().formatCurrency(),
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                   textAlign: TextAlign.left),
//               Gaps.vGap40,
//             ],
//           ).intoExpend(),
//           Gaps.hGap16,
//         ],
//       ).intoContainer(
//           height: 128,
//           margin: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//           decoration: normalDecoration(color: Colours.color_ffff3e47)),
//     );
//   }
//
//   Widget _timeSelectWidget() {
//     var timeStr = '';
//     if (state.filterType == 'yyyy-MM-d') {
//       timeStr = DateUtil.formatTime(
//           DateUtil.getDateTime(state.startTime)!.millisecondsSinceEpoch,
//           format: DateFormats.y_mo_d);
//     } else if (state.filterType == 'yyyy-MM') {
//       timeStr = DateUtil.formatTime(
//           DateUtil.getDateTime(state.startTime)!.millisecondsSinceEpoch,
//           format: DateFormats.y_mo);
//     } else if (state.filterType == 'yyyy') {
//       timeStr = DateUtil.formatTime(
//           DateUtil.getDateTime(state.startTime)!.millisecondsSinceEpoch,
//           format: DateFormats.y);
//     }
//
//     return SliverToBoxAdapter(
//         child: Row(
//       children: [
//         Row(
//           children: [
//             cText(timeStr),
//             Icon(Icons.arrow_drop_down),
//             cText(' — ${S.current.to_today}')
//           ],
//         ).onClick(() {
//           _showDataSelect();
//         }).intoExpend(),
//         if (state.transferAmount != 0)
//           cText(
//               ' ${S.current.transactionsExpense}\$${NumberHelper.formatCurrency(state.transferAmount)}',
//               fontSize: 12,
//               color: Colours.color_9a9a9a),
//         Gaps.hGap12,
//         if (state.topUpAmount != 0)
//           cText(
//               ' ${S.current.transactionsIncome}\$${NumberHelper.formatCurrency(state.topUpAmount)}',
//               fontSize: 12,
//               color: Colours.color_9a9a9a),
//       ],
//     ).intoContainer(
//             padding: EdgeInsets.symmetric(vertical: 9, horizontal: 15)));
//   }
//
//   Widget _historyList() {
//     return SliverFillRemaining(
//         child: SmartRefresher(
//             controller: logic.refreshController,
//             onRefresh: () => logic.getHistoryList(refresh: true),
//             onLoading: () => logic.getHistoryList(),
//             enablePullUp: true,
//             footer: ClassicFooter(
//               noDataText: S.current.no_more_data,
//             ),
//             child: ListView.builder(
//                 itemCount: state.historyList.length,
//                 itemBuilder: (context, index) {
//                   var data = state.historyList[index];
//                   return historyItem(context, data);
//                 })).intoContainer(color: Colors.white));
//   }
//   Widget buildItem(BongLoyCardOrderDto data, int index) {
//     var dirStr = '-';
//     if (data.way == 0) {
//       dirStr = '+';
//     }
//     var isGroupTop = logic.isGroupTop(index);
//     var isGroupBottom = logic.isGroupBottom(index);
//     var groupRadius = BorderRadius.zero;
//     var onlyOne = logic.isOnlyOne(index);
//     if (onlyOne) {
//       groupRadius = BorderRadius.all(Radius.circular(16));
//     } else if (isGroupTop) {
//       groupRadius = BorderRadius.only(
//           topLeft: Radius.circular(16), topRight: Radius.circular(16));
//     } else if (isGroupBottom) {
//       groupRadius = BorderRadius.only(
//           bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16));
//     }
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: groupRadius,
//       ),
//       child: Column(
//         children: [
//           Gaps.vGap16,
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   cText(data.getTransferType(),
//                       color: Colours.color_ff1b1c1e,
//                       fontWeight: FontWeight.w500),
//                   Gaps.vGap3,
//                   cText(data.parseDate(),
//                       color: Colours.color_9a9a9a, fontSize: 11)
//                 ],
//               ).intoExpend(),
//               cText('$dirStr${NumberHelper.formatCurrency(data.amount)}',
//                   color: data.way == 0
//                       ? Colours.color_ffff3e47
//                       : Colours.color_1b1c1e,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500)
//             ],
//           ),
//           Gaps.vGap16,
//           Container(
//             height: 0.5,
//             color: AppColors.colorDEDEDE,
//             width: ScreenUtil.screenWidth,
//           )
//         ],
//       ),
//     ).onClick(() {
//       context.router
//           .push(PrepaidHistoryDetailPageRoute(bongLoyCardOrderDto: data));
//     });
//   }
//
//   Widget historyItem(BuildContext context, BongLoyCardOrderDto data) {
//     // var typeStr = '';
//     // if (data.cucoType == 0) {
//     //   typeStr = S.current.recharge;
//     // } else if (data.cucoType == 1) {
//     //   typeStr = S.current.transferTitle;
//     // }
//     var dirStr = '-';
//     if (data.way == 0) {
//       dirStr = '+';
//     }
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   cText(data.getTransferType(),
//                       color: Colours.color_ff1b1c1e,
//                       fontWeight: FontWeight.w500),
//                   Gaps.vGap3,
//                   cText(data.createTime?.replaceAll(' 00:00:00', '') ?? '',
//                       color: Colours.color_9a9a9a, fontSize: 11)
//                 ],
//               ).intoExpend(),
//               cText('$dirStr${NumberHelper.formatCurrency(data.amount)}',
//                   color: data.way == 0
//                       ? Colours.color_ffff3e47
//                       : Colours.color_1b1c1e,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500)
//             ],
//           ).intoContainer(margin: EdgeInsets.symmetric(vertical: 19)),
//           Container().verticalLine(
//               width: double.infinity, color: Colours.color_ffededed)
//         ],
//       ),
//     ).onClick(() {
//       context.router
//           .push(PrepaidHistoryDetailPageRoute(bongLoyCardOrderDto: data));
//     });
//   }
//
//   void _showDataSelect() {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         builder: (BuildContext context) {
//           return SelectDatePage(
//               filterType: state.filterType,
//               selectDate: DateUtil.getDateTime(state.startTime),
//               selectTime: (timeType, time) {
//                 logic.selectTime(timeType, time);
//               });
//         });
//   }
//
//
// }
