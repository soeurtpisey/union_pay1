
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/constants/style.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/utils/screen_util.dart';
import 'package:union_pay/widgets/common.dart';
import 'package:union_pay/widgets/page_error.dart';
import 'package:union_pay/widgets/prepaid_card/form_common.dart';
import '../../../widgets/custom_easy_refresh.dart';
import 'prepaid_select_template_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/14 14:11
/// @Description: 模版选择
/// /////////////////////////////////////////////
class PrepaidSelectTemplatePage extends StatefulWidget {
  final String? fromAccount;

  const PrepaidSelectTemplatePage({super.key, this.fromAccount});

  @override
  _PrepaidSelectTemplatePageState createState() =>
      _PrepaidSelectTemplatePageState();
}

class _PrepaidSelectTemplatePageState extends State<PrepaidSelectTemplatePage> {
  final logic = Get.put(PrepaidSelectTemplateLogic());
  final state = Get.find<PrepaidSelectTemplateLogic>().state;

  @override
  void dispose() {
    Get.delete<PrepaidSelectTemplateLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: logic,
        builder: (viewModel) {
          return cScaffold(context, S.of(context).favorite,
              backgroundColor: AppColors.colorE9EBF5,
              appBarBgColor: AppColors.colorE9EBF5,
              floatingActionButton: state.templateList.isEmpty
                  ? null
                  : FloatingActionButton(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      onPressed: () {
                        /// warning
                        // context.router
                        //     .push(PrepaidCreateTemplatePageRoute(
                        //         transferType:
                        //             UnionCardTransferType.toBonglogCard.value))
                        //     .then((value) {
                        //   logic.getTemplateList(refresh: true);
                        // });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: ImagesRes.IC_CARD_FAVORITE_ADD.UIImage(),
                      ),
                    ),
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: state.isError
                      ? PageError(
                          onRefresh: () => logic.getTemplateList(refresh: true),
                        )
                      : Column(children: [
                          (state.templateList.isEmpty && !state.isLoading)
                              ? emptyTemplate()
                              : templateList(),
                        ])));
        });
  }

  Widget templateList() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CustomEasyRefresh(
            controller: logic.refreshController,
            onRefresh: () async {
              logic.getTemplateList(refresh: true);
            },
            onLoadMore: () async {
              logic.getTemplateList();
            },
            // loading: state.isLoading,
            child: ListView.builder(
                itemCount: state.templateList.length,
                itemBuilder: (context, index) {
                  var data = state.templateList[index];
                  return templateNewItem(data, context,
                      updateTemplate: (value) {
                    logic.getTemplateList(refresh: true);
                  }, onTap: () {
                    /// warning
                    // context.router
                    //     .push(PrepaidTransferPageRoute(
                    //         fromAccount: widget.fromAccount,
                    //         templateModel: data,
                    //         transferType: data.keyIdType))
                    //     .then((value) {
                    //   logic.getTemplateList(refresh: true);
                    // });
                  }, onDelete: () {
                    logic.deleteTemplate(data);
                  });
                }))).intoFlexible();
  }

  Widget emptyTemplate() {
    return Column(
      children: [
        Gaps.vGap48,
        ImagesRes.IC_CARD_FAVORTE_NO_LIST.UIImage(),
        Gaps.vGap30,
        cText(S.of(context).no_favorite_here,
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 24),
        Gaps.vGap20,
        buildNewCardBtn()
      ],
    ).intoContainer(width: ScreenUtil.screenWidth);
  }

  Widget buildNewCardBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.colorE40C19,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImagesRes.IC_FAVORITE_NO_LIST_ADD.UIImage(),
          Gaps.hGap10,
          cText(S.of(context).new_favorite,
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ],
      ),
    ).onClick(() {
      /// warning
      // context.router
      //     .push(PrepaidCreateTemplatePageRoute(
      //     transferType:
      //     UnionCardTransferType.toBonglogCard.value))
      //     .then((value) {
      //   logic.getTemplateList(refresh: true);
      // });
    });
  }
}
