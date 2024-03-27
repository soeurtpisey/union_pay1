
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../utils/custom_decoration.dart';
import '../../../utils/view_util.dart';
import '../../../widgets/common.dart';
import 'prepaid_change_account_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/23 15:30
/// @Description: 修改账户名
/// /////////////////////////////////////////////
class PrepaidChangeAccountNamePage extends StatefulWidget {
  final UnionPayCardResModel model;

  const PrepaidChangeAccountNamePage({Key? key, required this.model})
      : super(key: key);

  @override
  _PrepaidChangeAccountNamePageState createState() =>
      _PrepaidChangeAccountNamePageState();
}

class _PrepaidChangeAccountNamePageState
    extends State<PrepaidChangeAccountNamePage> {
  final logic = Get.put(PrepaidChangeAccountNameLogic());
  final state = Get.find<PrepaidChangeAccountNameLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: normalDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                cText(S.current.change_account_name,
                    color: AppColors.color1F1F1F,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                Gaps.vGap15,
                TextField(
                  keyboardType: TextInputType.number,
                  controller: logic.accountNameController,
                  style: const TextStyle(color: AppColors.color151736),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      hintText: S.current.pleaseEnter,
                      hintStyle: const TextStyle(color: AppColors.colorBBBBBB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      errorBorder: InputBorder.none,
                      fillColor: AppColors.colorF5F5F5,
                      filled: true),
                  textAlign: TextAlign.left,
                ).intoContainer(
                  height: 35,
                )
              ],
            ).intoContainer(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: AppColors.colorD8D8D8, width: 0.5))),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
            Row(
              children: [
                cText(S.current.cancel)
                    .intoContainer(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors.colorD8D8D8, width: 0.5))))
                    .onClick(() {
                  Navigator.of(context).pop();
                }).intoExpend(),
                cText(S.current.confirm, color: AppColors.color3478f5)
                    .onClick(() async {
                  var result = await logic.accountName(widget.model);
                  if (result!=null) {
                    Navigator.of(context).pop(result);
                  }
                }).intoExpend()
              ],
            ).intoContainer(height: 50)
          ],
        ),
        Obx(() => buildLoadingStack(state.isLoading.value))
      ]),
    );
  }

  @override
  void dispose() {
    Get.delete<PrepaidChangeAccountNameLogic>();
    super.dispose();
  }
}
