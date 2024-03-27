//
// import 'package:flutter/material.dart';
// import 'package:union_pay/extensions/widget_extension.dart';
// import 'package:union_pay/res/images_res.dart';
//
// import '../../constants/style.dart';
// import '../../generated/l10n.dart';
// import '../../helper/colors.dart';
// import '../../model/prepaid/res/union_pay_card_res_model.dart';
// import '../common.dart';
//
// /// ////////////////////////////////////////////
// /// @author: DJW
// /// @Date: 2023/9/16 22:08
// /// @Description:
// /// /////////////////////////////////////////////
//
// class ChooseFromAccount extends StatefulWidget {
//   final List<UnionPayCardResModel> fromAccount;
//   final String selectAccount;
//   final ValueChanged<UnionPayCardResModel>? onSelect;
//
//   const ChooseFromAccount(
//       {super.key,
//       required this.fromAccount,
//       required this.selectAccount,
//       this.onSelect});
//
//   @override
//   State<ChooseFromAccount> createState() => _ChooseFromAccountState();
// }
//
// class _ChooseFromAccountState extends State<ChooseFromAccount> {
//   var selectAccount;
//
//   @override
//   void initState() {
//     super.initState();
//     selectAccount = widget.selectAccount;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     selectAccount ??= widget.selectAccount;
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             cText(S.of(context).choose_account,
//                 color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
//             buildClose()
//           ],
//         ),
//         Gaps.vGap30,
//         ...widget.fromAccount.map((e) => buildItem(e)).toList()
//       ],
//     );
//   }
//
//   Widget buildDefaultRadio() {
//     return const Icon(
//       Icons.radio_button_off,
//       color: Colors.black,
//     );
//   }
//
//   Widget buildSelectRadio() {
//     return const Icon(
//       Icons.radio_button_checked,
//       color: AppColors.colorE40C19,
//     );
//   }
//
//   Widget buildItem(UnionPayCardResModel item) {
//     var icon = Image.asset(ImagesRes.IC_PREPAID_UNIONPAY_BIG);
//     /// warning
//     // if (item.cardId == PrepaidTransferLogic.UPAY_NAME) {
//     //   icon = Image.asset(ImagesRes.ICON_PREPAID_UPAY_V2, width: 37, height: 37);
//     // }
//     var select = selectAccount == item.cardId;
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//               color: select ? AppColors.colorE40C19 : AppColors.color8A8A8E)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           buildSelectAccount(icon, item),
//           select ? buildSelectRadio() : buildDefaultRadio()
//         ],
//       ),
//     ).onClick(() {
//       selectAccount = item.cardId;
//       setState(() {});
//       widget.onSelect?.call(item);
//       Navigator.pop(context);
//     });
//   }
//
//   Widget buildSelectAccount(Widget icon, UnionPayCardResModel item) {
//     return Row(
//       children: [
//         icon,
//         Gaps.hGap10,
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             cText('${item.getCardBankFormat()}' ?? '',
//                 color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15,textAlign: TextAlign.start),
//             cText(
//                 '${S().top_up_available_balance}:${item.getAvailableBalance()}',fontSize: 13,textAlign: TextAlign.start)
//           ],
//         ).intoExpend()
//       ],
//     ).intoExpend();
//   }
//
//   Widget buildClose() {
//     return ClipOval(
//       child: Container(
//         padding: EdgeInsets.all(5),
//         decoration: BoxDecoration(color: AppColors.colorececec),
//         child: Icon(
//           Icons.close,
//           color: AppColors.color3C3C43,
//           size: 20,
//         ),
//       ),
//     ).onClick(() {
//       Navigator.pop(context);
//     });
//   }
// }
