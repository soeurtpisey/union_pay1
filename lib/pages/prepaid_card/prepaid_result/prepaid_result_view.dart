
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/widgets/common.dart';
import '../../../constants/style.dart';
import 'prepaid_result_logic.dart';

class PrepaidResultPage extends StatefulWidget {
  final String? title;
  final String? resultTitle;
  final String? description;

  PrepaidResultPage({Key? key, this.title, this.resultTitle, this.description})
      : super(key: key);

  @override
  State<PrepaidResultPage> createState() => _PrepaidResultPageState();
}

class _PrepaidResultPageState extends State<PrepaidResultPage> {
  final logic = Get.put(PrepaidResultLogic());
  final state = Get.find<PrepaidResultLogic>().state;

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, widget.title ?? '',
        hasLeading:widget.title != S.current.prepaid_activate_result,
        onPressed: () {
        /// warning
        //   context.router.popUntil((Route<dynamic> route){
        //     if (route.settings.name == WalletManagePageRoute.name) {
        //       return true;
        //     }
        //     if (route.settings.name == DashboardPageRoute.name) {
        //       return true;
        //     }
        //     return false;
        //   });
        },
        backgroundColor: AppColors.colorE9EBF5,
        appBarBgColor: AppColors.colorE9EBF5,
        child: widget.title == S.current.prepaid_activate_result
            ? Column(
                children: [
                  Gaps.vGap50,
                  ImagesRes.IC_CARD_ACTIVATED.UIImage(),
                  Gaps.vGap30,
                  cText(S.of(context).card_activated,
                      color: Colors.black, fontSize: 22),
                  Gaps.vGap10,
                  cText(S.of(context).card_ready_to_use,
                      fontWeight: FontWeight.w500,
                      color: AppColors.color79747E,
                      fontSize: 16),
                  cBottomButton(S.of(context).back_to_card_manager, onTap: () {
                    /// warning
                    // context.router.popUntil((Route<dynamic> route){
                    //   if (route.settings.name == WalletManagePageRoute.name) {
                    //     return true;
                    //   }
                    //   if (route.settings.name == DashboardPageRoute.name) {
                    //     return true;
                    //   }
                    //   return false;
                    // });
                  })
                ],
              )
            : Column(
                children: [
                  Gaps.vGap80,
                  ImagesRes.IC_SUCCESS_80.UIImage(),
                  Gaps.vGap24,
                  cText(widget.resultTitle ?? '',
                      color: AppColors.colorFFE1F20,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                  Gaps.vGap12,
                  cText(widget.description ?? '',
                      color: AppColors.colorFFE1F20),
                  cBottomButton(S.of(context).back_to_card_manager, onTap: () {
                    /// warning
                    // context.router.popUntil((Route<dynamic> route){
                    //   if (route.settings.name == WalletManagePageRoute.name) {
                    //     return true;
                    //   }
                    //   if (route.settings.name == DashboardPageRoute.name) {
                    //     return true;
                    //   }
                    //   return false;
                    // });
                  })
                ],
              ));
  }

  @override
  void dispose() {
    Get.delete<PrepaidResultLogic>();
    super.dispose();
  }
}
