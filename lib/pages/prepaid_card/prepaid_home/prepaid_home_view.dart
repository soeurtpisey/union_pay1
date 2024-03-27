// import 'package:bank_app/base/routing/router.dart';
// import 'package:bank_app/extension/extensions.dart';
// import 'package:bank_app/generated/l10n.dart';
// import 'package:bank_app/helpers/prepaid_card_helper.dart';
// import 'package:bank_app/res/assets_res.dart';
// import 'package:bank_app/style/custom_decoration.dart';
// import 'package:bank_app/utils/colors.dart';
// import 'package:bank_app/utils/styles.dart';
// import 'package:bank_app/widgets/PageError.dart';
// import 'package:bank_app/widgets/common.dart';
// import 'package:bank_app/widgets/prepaid_card/form_common.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:widget_size/widget_size.dart';
//
// import 'prepaid_home_logic.dart';
//
// /// ////////////////////////////////////////////
// /// @author: SJD
// /// @Date: 2022/12/13 18:15
// /// @Description: 预付卡首页
// /// /////////////////////////////////////////////
// class PrepaidHomePage extends StatefulWidget {
//   @override
//   _PrepaidHomePageState createState() => _PrepaidHomePageState();
// }
//
// class _PrepaidHomePageState extends State<PrepaidHomePage> {
//   final logic = Get.put(PrepaidHomeLogic());
//   final state = Get.find<PrepaidHomeLogic>().state;
//
//   @override
//   void dispose() {
//     Get.delete<PrepaidHomeLogic>();
//     // PrepaidCardHelper.blCardList.clear();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return cScaffold(context, S.of(context).prepaid_card,
//         child: GetBuilder(
//             init: logic,
//             builder: (PrepaidHomeLogic controller) {
//               return state.isError
//                   ? PageError(
//                       onRefresh: () => logic.getTemplateList(refresh: true))
//                   : CustomScrollView(
//                       slivers: [
//                         SliverToBoxAdapter(
//                             child: CustomPaint(
//                                 painter: TogView(titleWidth),
//                                 child: Stack(
//                                   children: [
//                                     _buildTitle(),
//                                     _buildFunctionBtn(context),
//                                   ],
//                                 )).intoContainer(
//                           height: 225,
//                           width: double.infinity,
//                           margin: EdgeInsets.symmetric(horizontal: 15),
//                         )),
//                         // .intoContainer(
//                         // decoration:
//                         //     normalDecoration(color: Colors.white),
//                         // height: 220,
//                         // width: double.infinity,
//                         // margin: EdgeInsets.symmetric(horizontal: 15))),
//                         SliverFillRemaining(
//                             child: _buildCreateTemplate(context).intoContainer(
//                                 width: double.infinity,
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 15))),
//                       ],
//                     );
//             }));
//   }
//
//   double? titleWidth;
//
//   Widget _buildTitle() {
//     return Positioned(
//         left: 12,
//         top: 12,
//         child: WidgetSize(
//                 onChange: (Size size) {
//                   print('siz111e ${size.width}');
//                   if (titleWidth != size.width) {
//                     titleWidth = size.width + 50;
//                     setState(() {});
//                   }
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         AssetsRes.ICON_PREPAID_UPAY_V2.UIImage(),
//                         Gaps.hGap4,
//                         cText('U-PAY', color: Colours.black_1e1f20)
//                       ],
//                     ),
//                     cText('&', color: Colours.color_ffff3e47).intoContainer(
//                         margin: EdgeInsets.symmetric(horizontal: 6)),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         AssetsRes.ICON_PREPAID_UNIONPAY_V2.UIImage(),
//                         Gaps.hGap4,
//                         cText('UnionPay', color: Colours.black_1e1f20)
//                       ],
//                     ),
//                   ],
//                 ))
//             .intoContainer(
//                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
//                 decoration: normalDecoration(
//                     color: Colours.gray_f5,
//                     borderRadius: BorderRadius.circular(13))));
//   }
//
//   Widget _buildFunctionBtn(BuildContext context) {
//     return Positioned(
//         left: 12,
//         top: 60,
//         right: 12,
//         bottom: 12,
//         child: Row(
//           children: [
//             Stack(children: [
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 cText(S.current.prepaid_card_manager,
//                     color: Colors.white,
//                     fontSize: 20,
//                     textAlign: TextAlign.left,
//                     maxLine: 1),
//                 cText(S.current.click_there_to_setting_more,
//                     color: AppColors.colorbfffffff,
//                     fontSize: 12,
//                     textAlign: TextAlign.left,
//                     maxLine: 1),
//               ]),
//               Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: Container(
//                     child: AssetsRes.ICON_PREPAID_MANAGER_V2.UIImage(),
//                   ))
//             ])
//                 .intoContainer(
//                     padding: EdgeInsets.only(left: 14, top: 14),
//                     height: double.infinity,
//                     decoration: normalDecoration(color: Colours.color_ffff3e47))
//                 .onClick(() {
//               ///卡管理
//               context.router.push(PrepaidManagerPageRoute());
//               // Get.to(PrepaidManagerPage());
//             }).intoExpend(),
//             Gaps.hGap9,
//             Column(
//               children: [
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   cText(S.current.prepaid_card_account,
//                       color: Colors.white,
//                       fontSize: 20,
//                       textAlign: TextAlign.left,
//                       maxLine: 1),
//                   cText(S.current.prepaid_card_base_info,
//                       color: AppColors.colorbfffffff,
//                       fontSize: 12,
//                       textAlign: TextAlign.left,
//                       maxLine: 1)
//                 ])
//                     .intoContainer(
//                         width: double.infinity,
//                         height: double.infinity,
//                         padding: EdgeInsets.only(left: 14, top: 14),
//                         decoration:
//                             normalDecoration(color: Colours.color_ffff3e47))
//                     .onClick(() {
//                   ///账户
//                   // if (PrepaidCardHelper.blCardList.isEmpty) {
//                   //   showToast(S.current.no_card_goto_apply);
//                   //   return;
//                   // }
//                   context.router.push(PrepaidAccountPageRoute());
//                 }).intoExpend(),
//                 Gaps.vGap9,
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   cText(S.current.fastActionsTransfer,
//                       color: Colors.white,
//                       fontSize: 20,
//                       textAlign: TextAlign.left,
//                       maxLine: 1),
//                   cText(S.current.prepaid_card_can_transfer,
//                       color: AppColors.colorbfffffff,
//                       fontSize: 12,
//                       textAlign: TextAlign.left,
//                       maxLine: 1)
//                 ])
//                     .intoContainer(
//                         width: double.infinity,
//                         height: double.infinity,
//                         padding: EdgeInsets.only(left: 14, top: 14),
//                         decoration:
//                             normalDecoration(color: Colours.color_ffff3e47))
//                     .onClick(() {
//                   ///转账
//                   // if(PrepaidCardHelper.blCardList.isEmpty){
//                   //   showToast(S.current.no_card_goto_apply);
//                   //   return;
//                   // }
//                   context.router.push(PrepaidTransferSelectPageRoute());
//                 }).intoExpend(),
//               ],
//             )
//                 .intoContainer(
//                     height: double.infinity,
//                     width: double.infinity,
//                     decoration: normalDecoration(color: Colors.white))
//                 .intoExpend()
//           ],
//         ));
//   }
//
//   Widget _buildCreateTemplate(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 cText(S.current.prepaid_card_create_template,
//                     fontSize: 16,
//                     color: Colours.color_ff1e1f20,
//                     fontWeight: FontWeight.w500),
//                 cText(S.current.prepaid_card_create_template_cue,
//                     fontSize: 12, color: AppColors.colorBF1E1F20)
//               ],
//             ).intoExpend(),
//             Gaps.hGap10,
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 cText(S.current.create, color: Colors.white),
//                 Gaps.hGap6,
//                 AssetsRes.ICON_PREPAID_ADD_V2.UIImage()
//               ],
//             )
//                 .intoContainer(
//                     decoration: normalDecoration(
//                         color: Colours.color_ffff3e47,
//                         borderRadius: BorderRadius.circular(20)),
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8))
//                 .onClick(() {
//               context.router
//                   .push(PrepaidCreateTemplateListPageRoute())
//                   .then((value) {
//                 logic.getTemplateList(refresh: true);
//               });
//             })
//           ],
//         ).intoContainer(
//           padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//           decoration: normalDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(6),
//                   topRight: Radius.circular(6),
//                   bottomLeft: Radius.zero,
//                   bottomRight: Radius.zero)),
//         ),
//         ClipRRect(
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(6),
//                 bottomRight: Radius.circular(6),
//                 topLeft: Radius.zero,
//                 topRight: Radius.zero),
//             child: SmartRefresher(
//                 controller: logic.refreshController,
//                 onRefresh: () => logic.getTemplateList(refresh: true),
//                 onLoading: () => logic.getTemplateList(),
//                 footer: ClassicFooter(
//                   noDataText: '',
//                 ),
//                 enablePullUp: true,
//                 child: ListView.builder(
//                     itemCount: state.templateList.length,
//                     itemBuilder: (context, index) {
//                       var data = state.templateList[index];
//                       return templateItem(data, context, onTap: () {
//                         context.router
//                             .push(PrepaidTransferPageRoute(
//                                 templateModel: data,
//                                 transferType: data.keyIdType))
//                             .then((value) {
//                           logic.getTemplateList(refresh: true);
//                         });
//                       }, onDelete: () {
//                         logic.deleteTemplate(data);
//                       });
//                     }))).intoFlexible()
//       ],
//     );
//   }
// }
//
// class TogView extends CustomPainter {
//   final double? titleWidth;
//   TogView(this.titleWidth);
//
//   final Paint _paint = Paint()
//     ..color = Colors.white //画笔颜色
//     ..strokeCap = StrokeCap.butt //画笔笔触类型
//     // ..isAntiAlias = true //是否启动抗锯齿
//     // ..blendMode = BlendMode.exclusion //颜色混合模式
//     ..style = PaintingStyle.fill //绘画风格，默认为填充
//     // ..colorFilter = ColorFilter.mode(Colors.redAccent,
//     //     BlendMode.exclusion) //颜色渲染模式，一般是矩阵效果来改变的,但是flutter中只能使用颜色混合模式
//     // ..maskFilter = MaskFilter.blur(BlurStyle.inner, 3.0) //模糊遮罩效果，flutter中只有这个
//     ..filterQuality = FilterQuality.high //颜色渲染模式的质量
//     ..strokeWidth = 1.0; //
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     print('size  ${size.width}  ${size.height}');
//     var topWidth = titleWidth ?? size.width - 150;
//     canvas.drawLine(Offset(20.0, 20.0), Offset(100.0, 100.0), _paint);
//     var zeroPoint = Offset(50, 0); // 开始位置
//     var firstPoint = Offset(0, 0); // 第一个点
//     var secondPoint = Offset(0, size.height); // 第二个点
//     var threePoint = Offset(size.width, size.height); // 第三个点
//     var fourPoint = Offset(size.width, 50); // 第四个点
//     var fivePoint = Offset(topWidth, 50); // 第五个点
//     var sixPoint = Offset(topWidth, 0); // 第六个点
//     var radius = 6;
//     var path = Path();
//     path.moveTo(zeroPoint.dx, zeroPoint.dy);
//     path.lineTo(firstPoint.dx + radius, firstPoint.dy);
//     path.quadraticBezierTo(
//         firstPoint.dx, firstPoint.dy, firstPoint.dx, firstPoint.dy + radius);
//     path.lineTo(secondPoint.dx, secondPoint.dy - radius);
//     path.quadraticBezierTo(
//         secondPoint.dx, secondPoint.dy, secondPoint.dx + radius, threePoint.dy);
//     path.lineTo(threePoint.dx - radius, threePoint.dy);
//     path.quadraticBezierTo(
//         threePoint.dx, threePoint.dy, threePoint.dx, threePoint.dy - radius);
//     path.lineTo(fourPoint.dx, fourPoint.dy + radius);
//     path.quadraticBezierTo(
//         fourPoint.dx, fourPoint.dy, fourPoint.dx - radius, fourPoint.dy);
//     path.lineTo(fivePoint.dx + radius, fivePoint.dy);
//     path.quadraticBezierTo(
//         fivePoint.dx, fivePoint.dy, fivePoint.dx, fivePoint.dy - radius);
//     path.lineTo(sixPoint.dx, sixPoint.dy + radius);
//     path.quadraticBezierTo(
//         sixPoint.dx, sixPoint.dy, sixPoint.dx - radius, sixPoint.dy);
//     path.lineTo(zeroPoint.dx, zeroPoint.dy);
//     // path.quadraticBezierTo(
//     //     startPoint.dx, startPoint.dy, startPoint.dx, startPoint.dy);
//
//     canvas.drawPath(path, _paint);
//   }
//
//   @override
//   bool shouldRepaint(TogView oldDelegate) => false;
//   @override
//   bool shouldRebuildSemantics(TogView oldDelegate) => false;
// }
