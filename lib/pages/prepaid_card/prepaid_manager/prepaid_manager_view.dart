
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:union_pay/app/base/app.dart';
import 'package:union_pay/extensions/double_extension.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/models/prepaid/enums/union_card_state.dart';
import 'package:union_pay/pages/prepaid_card/prepaid_cvv/prepaid_cvv_view.dart';
import 'package:union_pay/pages/prepaid_card/prepaid_manager/prepaid_manager_state.dart';
import 'package:union_pay/pages/prepaid_card/prepaid_modify_card_limit/prepaid_modify_card_limit_view.dart';
import 'package:union_pay/res/font_res.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/utils/bio_util.dart';
import 'package:union_pay/utils/custom_decoration.dart';
import 'package:union_pay/utils/dialog_util.dart';
import 'package:union_pay/utils/screen_util.dart';
import 'package:union_pay/utils/view_util.dart';
import 'package:union_pay/widgets/prepaid_card/form_common.dart';
import 'package:union_pay/widgets/prepaid_card/rename_card_bottom.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../widgets/common.dart';
import 'prepaid_manager_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/14 10:13
/// @Description: 卡管理
/// /////////////////////////////////////////////
class PrepaidManagerPage extends StatefulWidget {
  final UnionPayCardResModel? model;

  const PrepaidManagerPage({super.key, this.model});

  @override
  _PrepaidManagerPageState createState() => _PrepaidManagerPageState();
}

class _PrepaidManagerPageState extends State<PrepaidManagerPage> {
  late PrepaidManagerLogic logic;
  late PrepaidManagerState state;

  @override
  void initState() {
    super.initState();
    logic = Get.put(PrepaidManagerLogic());
    state = Get.find<PrepaidManagerLogic>().state;
    state.currentModel = widget.model;
    logic.getQueryCardLimit();
  }

  @override
  void dispose() {
    Get.delete<PrepaidManagerLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: logic,
        builder: (viewModel) {
          return cScaffold(
              context,
              state.currentModel?.isVirtual() == true
                  ? S.of(context).vcCardTitle
                  : S.of(context).physical_card,
              backgroundColor: AppColors.colorE9EBF5,
              appBarBgColor: AppColors.colorE9EBF5,
              resizeToAvoidBottomInset: false,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: PrepaidCardHelper.blCardList.isNotEmpty
                          ? hasCard(context)
                          : noCard(),
                    ),
                  ),
                  buildLoadingStack(state.loading.value)
                ],
              ));
        });
  }

  //有卡
  Widget hasCard(BuildContext context) {
    return Column(
      children: [
        // cardPageView(),
        if (state.currentModel?.hasCard() == true) ...activationFunction(),
        // if (state.currentModel?.hasCard() != true) ...inactiveFunction()
      ],
    );
  }

  //激活后的功能
  List<Widget> activationFunction() {
    return [
      functionLine(context),
      Gaps.vGap12,
      functionBottom(),
    ];
  }

  // Widget _buildStep() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildStepTip(
  //           '1',
  //           state.currentModel?.cardType() == UnionCardType.virtualCard
  //               ? S.of(context).find_your_virtual_card_view
  //               : S.current.find_your_physical_card_view,
  //           S.of(context).card_back),
  //       Container(
  //         height: 30,
  //         width: 0.5,
  //         margin: EdgeInsets.only(left: 12, bottom: 2, top: 2),
  //         color: AppColors.colorFF3E47,
  //       ),
  //       _buildStepTip('2', S.of(context).the_numbers_on_the_card,
  //           S.of(context).fill_in_the_corresponding_box),
  //     ],
  //   ).intoContainer(
  //       margin: EdgeInsets.only(top: 30),
  //       padding: EdgeInsets.only(left: 70, right: 70));
  // }

  Row _buildStepTip(String no, String title, String title2) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.colorFF3E47,
              width: 1,
            ),
          ),
          child: cText(no, color: AppColors.colorFF3E47).intoCenter(),
        ),
        Gaps.hGap12,
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: title,
                style: TextStyle(color: AppColors.colorB31E1F20, fontSize: 15, fontFamily: isKm() ? FontRes.KHMER_OS_BATTAMBONG : '',)),
            TextSpan(
                text: title2,
                style: TextStyle(
                    color: AppColors.color1E1F20,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: isKm() ? FontRes.KHMER_OS_BATTAMBONG : '',
                ))
          ]),
        ).intoExpend()
      ],
    );
  }

  Expanded btnItem(String title, String icon, {VoidCallback? onTap}) {
    return Column(
      children: [
        ClipOval(
          child: icon.UIImage().intoContainer(
              padding: const EdgeInsets.all(10),
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(228, 12, 25, 0.08))),
        ),
        Gaps.vGap8,
        cText(title, color: Colors.black, fontWeight: FontWeight.w500)
      ],
    ).onDebounce(() {
      if (onTap != null) {
        onTap();
      }
    }).intoExpend();
  }

  //底部功能
  Widget functionBottom() {
    var freezeTitle = S.current.frozen;
    if (state.currentModel?.cardState() == UnionCardState.FREEZE) {
      freezeTitle = S.current.has_freeze;
    }
    var isVirtual = state.currentModel?.isVirtual() ?? false;
    return Column(
      children: [
        buildFunctionItem(S.of(context).favorite,
            leading: ImagesRes.IC_CARD_MANAGER_FAVORITE.UIImage(), onTap: () {
          if (state.currentModel?.isFrozen() == true) {
            showToast(S.current.merchant_unbind_frozen_tip2);
            return;
          }
          /// warning
          // context.router.push(PrepaidSelectTemplatePageRoute(
          //     fromAccount: state.currentModel?.cardId));
        }),
        buildFunctionItem(S.of(context).rename_card,
            leading: ImagesRes.IC_CARD_MANAGER_RENAME.UIImage(), onTap: () {
          showSheet(context, RenameCardBottom(model: state.currentModel!))
              .then((value) {
            if (value != null && value is UnionPayCardResModel) {
              logic.updateAccountName(value.accountName);
            }
          });
        }),
        if (!isVirtual)
          buildFunctionItem(S.current.reset_atm_pwd,
              leading: ImagesRes.IC_CARD_MANAGER_TIME_LIMIT.UIImage(),
              onTap: () {
            /// warning
            // context.router.push(
            //     PrepaidOldAtmPasswordPageRoute(cardId: state.currentModel?.id));
          }),
        buildFunctionItem(freezeTitle,
            leading: ImagesRes.IC_CARD_MANAGER_FREEZE.UIImage(), onTap: () {
              /// warning
          // context.pushRoute(PrepaidFreezePageRoute(
          //     freezeState: FreezeState.FREEZE, model: state.currentModel!));
        }),

        // arrowUnderLineItem(S.current.loss_reporting_card,
        //     onTap: () {}, needUnderLine: false),
      ],
    ).intoContainer(
      padding: const EdgeInsets.only(top: 13),
      margin: EdgeInsets.symmetric(horizontal: 15.0.px),
    );
  }

  Widget buildFunctionItem(String title,
      {Widget? leading, VoidCallback? onTap}) {
    return Row(
      children: [
        leading!,
        Gaps.hGap16,
        cText(title, fontSize: 16, color: AppColors.color333333)
      ],
    )
        .intoContainer(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 19),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)))
        .onClick(onTap);
  }

  //卡片信息和余额展开
  Widget buildCardInfoExpanded() {
    return ExpandableNotifier(
        child: Stack(
      children: [
        Expandable(
          expanded: Column(
            children: [
              buildCollapseItem(),
              buildExpandedItem().paddingOnly(top: 23)
            ],
          ),
          collapsed: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCollapseItem(),
              SizedBox(
                height: 0.1,
                width: ScreenUtil.screenWidth * 3 / 4,
              )
            ],
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: Builder(
              builder: (context) {
                var controller =
                    ExpandableController.of(context, required: true)!;
                return IconButton(
                    onPressed: () {
                      controller.toggle();
                    },
                    icon: Icon(
                      controller.expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.colorE40C19,
                      size: 27,
                    ));
              },
            ))
      ],
    ));
  }

  Widget buildExpandedItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(S.of(context).daily_transaction_limit,
            color: AppColors.color333333,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        Gaps.vGap16,
        baseLimitContainer(Column(
          children: [
            buildLimitItem(
                title: S.of(context).spending_limit_unit,
                value:
                    '\$${state.limitModel?.sysConsumeDayMax?.toString().formatCurrency()}'),
            buildLimitItem(
                title: S.of(context).single_consumption_limit_unit,
                value:
                    '\$${state.limitModel?.sysConsumeSingleMax?.toString().formatCurrency()}'),
            buildLimitItem(
                title: S.of(context).number_of_expenditures_unit,
                value: '${state.limitModel?.sysConsumeDayMaxNum?.toString()}')
          ],
        )),
        if (state.currentModel?.isVirtual() != true) Gaps.vGap10,
        if (state.currentModel?.isVirtual() != true)
          baseLimitContainer(Column(
            children: [
              buildLimitItem(
                  title: S.of(context).withdrawal_amount_unit,
                  value:
                      '\$${state.limitModel?.sysWithdrawDayMax?.toString().formatCurrency()}'),
              buildLimitItem(
                  title: S.of(context).single_withdrawal_limit_unit,
                  value:
                      '\$${state.limitModel?.sysWithdrawSingleMax?.toString().formatCurrency()}'),
              buildLimitItem(
                  title: S.of(context).number_withdrawal_unit,
                  value:
                      '${state.limitModel?.sysWithdrawDayMaxNum?.toString()}')
            ],
          )),
      ],
    );
  }

  Widget baseLimitContainer(Widget child) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(243, 242, 245, 0.5),
            borderRadius: BorderRadius.circular(8)),
        child: child);
  }

  Widget buildLimitItem({String title = '', String value = ''}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cText(title, color: AppColors.color333333),
        cText(value, color: AppColors.color333333),
      ],
    ).paddingOnly(top: 10);
  }

  Widget buildCollapseItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText('${state.currentModel?.getAccountName()}',
                textAlign: TextAlign.start,
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600)
            .paddingOnly(right: 50),
        Gaps.vGap2,
        Row(
          children: [
            cText('${S.of(context).merchant_withdrawal_balance}: ',
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            cText(
                '${state.currentModel?.availableAmount.toString().formatCurrency()} ${state.currentModel?.currency()}',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ],
        )
      ],
    );
  }

  //卡片功能行
  Widget functionLine(BuildContext context) {
    if (state.currentModel == null) {
      return Container();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      cardPageView().paddingSymmetric(horizontal: 18),
      buildCardInfoExpanded().paddingSymmetric(horizontal: 18, vertical: 22),
      Gaps.vGap10,
      Row(
        children: [
          btnItem(S.current.fastActionsTransfer, ImagesRes.IC_MANAGER_TRANSFER,
              onTap: () {
            if (state.currentModel?.isFrozen() == true) {
              showToast(S.current.merchant_unbind_frozen_tip2);
              return;
            }
            /// warning
            // context.router.push(PrepaidTransferSelectPageRoute(
            //     fromAccount: state.currentModel?.cardId));
          }),
          btnItem(S.current.topUp, ImagesRes.IC_MANAGER_TOP_UP,
              onTap: () async {
            if (state.currentModel?.isFrozen() == true) {
              showToast(S.current.merchant_unbind_frozen_tip2);
              return;
            }
            if (!state.loading.value) {
              /// warning
              // var model = await logic.onGetAccount();
              // if (model != null) {
              //   await context.router.push(PrepaidTopUpPageRoute(
              //       accountModel: model, bankModel: logic.nbcMemberBank));
              // }
            }
          }),
          btnItem(S.current.history, ImagesRes.IC_MANAGER_RECEIPT_HISTORY,
              onTap: () {
                /// warning
            // context.router
            //     .push(PrepaidHistoryPageRoute(model: state.currentModel!));
          }),
          btnItem(S.current.show_cvv, ImagesRes.IC_MANAGER_CVV, onTap: () {
            BioUtil.getInstance().showPasscodeModal(context, '', '', (value) {
              _showCvvBottomSheet();
            });
          })
        ],
      )
    ]).intoContainer(
        decoration: normalDecoration(color: Colors.white, circular: 16),
        margin: EdgeInsets.symmetric(horizontal: 15.0.px),
        padding: EdgeInsets.symmetric(vertical: 20.0.px));
  }

  //无卡
  Widget noCard() {
    return Column(
      children: [
        Gaps.vGap85,
        ImagesRes.ICON_PREPAID_WARNING_V2.UIImage(),
        Gaps.vGap26,
        cText(S.current.you_have_no_prepaid_card),
        Gaps.vGap16,
        cText(S.current.click_add_prepaid_card_and_use),
        Gaps.vGap50,
        btnWithLoading(
            title: S.current.add_prepaid_card,
            onTap: () {
              /// warning
              // context.pushRoute(ApplyCardPageRoute());
            })
      ],
    ).intoContainer(
      alignment: Alignment.center,
      width: double.infinity,
    );
  }

  //卡面
  Widget cardPageView() {
    return SizedBox(
      height: 206.0,
      child: cardView(context, state.currentModel!,
          cardNumVisible: state.cardNumVisible.value, onVisibleClick: () {
        if (state.cardNumVisible.value == true) {
          logic.setCardNumVisible();
        } else {
          BioUtil.getInstance().showPasscodeModal(context, '', '', (value) {
            logic.setCardNumVisible();
          });
        }
      }),
    );
  }

  //修改限额弹窗
  void _showModifyLimitBottomSheet() {
    DialogUtil.showBottomDateDialog(
      context,
      PrepaidModifyCardLimitPage(
        unionPayCardResModel: state.currentModel!,
      ),
    );
  }

  //ccv弹窗
  void _showCvvBottomSheet() {
    DialogUtil.showBottomDateDialog(
        context,
        PrepaidCvvPage(
          unionPayCardResModel: state.currentModel!,
        ));
  }
}
