// import 'package:bank_app/base/routing/router.dart';
// import 'package:bank_app/extension/extensions.dart';
// import 'package:bank_app/generated/l10n.dart';
// import 'package:bank_app/models/prepaid/res/union_pay_card_res_model.dart';
// import 'package:bank_app/pages/prepaid_card/prepaid_change_account_name/prepaid_change_account_logic.dart';
// import 'package:bank_app/res/assets_res.dart';
// import 'package:bank_app/utils/styles.dart';
// import 'package:bank_app/widgets/app_text_input.dart';
// import 'package:bank_app/widgets/common.dart';
// import 'package:bank_app/widgets/prepaid_card/form_common.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// /// ////////////////////////////////////////////
// /// @author: DJW
// /// @Date: 2023/9/17 22:50
// /// @Description:
// /// /////////////////////////////////////////////
//
// class RenameCardBottom extends StatefulWidget {
//   final UnionPayCardResModel model;
//
//   const RenameCardBottom({super.key, required this.model});
//
//   @override
//   State<RenameCardBottom> createState() => _RenameCardBottomState();
// }
//
// class _RenameCardBottomState extends State<RenameCardBottom> {
//   final logic = Get.put(PrepaidChangeAccountNameLogic());
//   final state = Get.find<PrepaidChangeAccountNameLogic>().state;
//
//   @override
//   void initState() {
//     super.initState();
//     logic.accountNameController.text=widget.model.accountName??'';
//   }
//
//   @override
//   void dispose() {
//     Get.delete<PrepaidChangeAccountNameLogic>();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedPadding(
//       padding: MediaQuery.of(context).viewInsets,
//       duration: Duration(milliseconds: 100),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           buildCardBottomTitle(S.of(context).rename_card,
//               onTap: () => context.popRoute()),
//           Gaps.vGap30,
//           AppTextInput(
//             controller: logic.accountNameController,
//             focusNode: logic.accountNameFocus,
//             maxLength: 20,
//             style: TextStyle(color: Colors.black, fontSize: 16),
//             hint: S.of(context).card_name,
//             prefixIcon: AssetsRes.IC_CARD_RENAME_PREFIX
//                 .UIImage()
//                 .intoContainer(margin: EdgeInsets.only(right: 10)),
//           ),
//           Gaps.vGap20,
//           Obx(() => Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               btnWithLoading2(
//                   isLoading: state.isLoading.value,
//                   title: S.current.save,
//                   onTap: () async {
//                     var result = await logic.accountName(widget.model);
//                     if (result!=null) {
//                       Navigator.pop(context, result);
//                     }
//                   }),
//             ],
//           )),
//         ],
//       ),
//     );
//   }
// }
