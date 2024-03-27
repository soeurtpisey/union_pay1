
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/double_extension.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/widgets/prepaid_card/slider_button/src/slider.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../models/prepaid/enums/freeze_state.dart';
import '../../models/prepaid/enums/union_card_state.dart';
import '../../models/prepaid/enums/union_card_transfer_type.dart';
import '../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../models/prepaid/res/union_pay_template_model.dart';
import '../../utils/dialog_util.dart';
import '../../utils/dimen.dart';
import '../../utils/screen_util.dart';
import '../../utils/view_util.dart';
import '../button/ripple_button.dart';
import '../common.dart';
import '../custom_text_field.dart';
import '../drop_down/dropdown_button2.dart';
import 'favorite_edit_bottom.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/3 16:45
/// @Description: kyc页面的复用widget
/// /////////////////////////////////////////////

Widget cFormItem(String label, {Widget? child, EdgeInsetsGeometry? padding}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      cText(label,
          color: Colors.black.withOpacity(0.55),
          fontSize: 16,
          fontWeight: FontWeight.w500),
      Gaps.vGap12,
      child ?? Container()
    ],
  ).intoPadding(padding: padding ?? const EdgeInsets.only(top: 16));
}

Widget cFormItem3({Widget? child, EdgeInsetsGeometry? padding}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Gaps.vGap12, child ?? Container()],
  ).intoPadding(padding: padding ?? const EdgeInsets.only(top: 10));
}

Widget cFormItem2(Widget label, {Widget? child, EdgeInsetsGeometry? padding}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [label, Gaps.vGap12, child ?? Container()],
  ).intoPadding(padding: padding ?? const EdgeInsets.only(top: 16));
}

Widget cFormPhoneInput(
    {TextEditingController? controller, FocusNode? focusNode}) {
  return CustomTextFiled(
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.phone,
    hintFontSize: 14,
    hintText: S.current.please_enter,
    prefixIcon: Container(
      width: 65,
      padding: const EdgeInsets.only(left: 10),
      child: InkWell(
        child: Row(
          children: [
            cText('+855', color: AppColors.color282828),
            Gaps.hGap5,
            Container(
              width: 0.5,
              height: 16.0,
              margin: const EdgeInsets.only(right: 13),
              color: AppColors.colorDDDDDD,
            )
          ],
        ),
      ),
    ),
    fillColor: AppColors.colorF5F5F5,
    radius: Dimens.gap_dp6,
  );
}

Widget cDropdown(
    {String? hint,
    required List<DropdownMenuItem<dynamic>>? items,
    int? initValue,
    bool? isDecoration = true,
    double height = 48,
    ValueChanged<dynamic>? onSelect,
    dynamic value}) {
  var v;
  if (items?.isEmpty == true) {
    v = S.current.validation_select;
  } else {
    if (initValue != null) {
      v = items![initValue].value;
    } else {
      v = items?.first.value;
    }
    onSelect?.call(v);
  }
  return DropdownButtonFormField2<dynamic>(
    decoration: const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
    ),
    isExpanded: true,
    hint: cText(hint ?? '', color: AppColors.color9A9A9A),
    icon: const Icon(
      Icons.arrow_drop_down,
      color: Colors.black45,
    ),
    value: v,
    buttonHeight: height,
    itemHeight: height,
    dropdownDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    items: items?.isEmpty == true
        ? [
            DropdownMenuItem<dynamic>(
              value: S.current.validation_select,
              child: cText(S.current.validation_select),
            )
          ]
        : items,
    onChanged: (value) {
      onSelect?.call(value);
    },
  ).intoContainer(
      decoration: isDecoration == true
          ? BoxDecoration(
              color: AppColors.colorF5F5F5,
              borderRadius: BorderRadius.circular(Dimens.gap_dp6))
          : null);
}

Widget cDropdownUnderLine(
    {String? hint,
    required List<DropdownMenuItem<dynamic>>? items,
    int? initValue,
    ValueChanged<dynamic>? onSelect,
    dynamic value}) {
  var v;
  if (items?.isEmpty == true) {
    v = S.current.validation_select;
  } else {
    if (initValue != null) {
      v = items![initValue].value;
    } else {
      v = items?.first.value;
    }
    onSelect?.call(v);
  }
  return DropdownButtonFormField2<dynamic>(
    decoration: const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
    ),
    isExpanded: true,
    hint: cText(hint ?? '', color: AppColors.color9A9A9A),
    icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 35),
    value: v,
    buttonHeight: 48,
    itemHeight: 48,
    itemPadding: EdgeInsets.zero,
    dropdownDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    items: items?.isEmpty == true
        ? [
            DropdownMenuItem<dynamic>(
              value: S.current.validation_select,
              child: cText(S.current.validation_select),
            )
          ]
        : items,
    onChanged: (value) {
      onSelect?.call(value);
    },
  );
}

Widget buildForm({required List<Widget> children, String? title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        cText(title,
                color: Colors.black.withOpacity(0.45),
                fontWeight: FontWeight.w500,
                fontSize: 15)
            .paddingOnly(left: 30, bottom: 8, top: 8),
      Column(
        children: children,
      ).intoContainer(
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
          margin: EdgeInsets.only(
              left: Dimens.gap_dp15,
              right: Dimens.gap_dp15,
              top: title == null ? Dimens.gap_dp15 : 0,
              bottom: Dimens.gap_dp15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.gap_dp16)))
    ],
  );
}

Widget baseScaffold(
  BuildContext context,
  String title, {
  Widget? child,
  bool resizeToAvoidBottomInset = false,
  Color? appBarBgColor,
  Color? appBarColor,
  Color? backgroundColor,
}) {
  return cScaffold(
    context,
    title,
    backgroundColor: backgroundColor,
    appBarBgColor: appBarBgColor,
    appBarColor: appBarColor,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    child: SingleChildScrollView(
      child: child,
    ).intoScrollConfiguration(),
  );
}

Widget cardView(BuildContext context, UnionPayCardResModel model,
    {bool? cardNumVisible = true,
    VoidCallback? onVisibleClick,
    VoidCallback? onDetail}) {
  // if (model.isVirtual()) {
  //   return virtualCard(context, model,
  //       cardNumVisible: cardNumVisible, onVisibleClick: onVisibleClick);
  // } else {
  return prepaidCardNewStyle(context, model, onDetail: onDetail);
  // }
}

Widget prepaidCard(BuildContext context, UnionPayCardResModel model,
    {bool? cardNumVisible = true, VoidCallback? onVisibleClick}) {
  return Container(
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
            colorFilter: model.cardState() == UnionCardState.INACTIVATED
                ? const ColorFilter.mode(
                    AppColors.color80000000, BlendMode.color)
                : null,
            image: AssetImage(model.getCardUI()),
            fit: BoxFit.fill)),
    child: Stack(children: [
      if (model.cardState() != UnionCardState.INACTIVATED)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: model
                  .cardNumberSplit()
                  .map((e) => cText(e,
                      fontFamily: 'CreditCard',
                      fontSize: 15,
                      color: model.getCardTextColor()))
                  .toList(),
            ).paddingSymmetric(horizontal: 20, vertical: 10),
            Row(
              children: [
                cText('VALID\nTHRU',
                    fontSize: 8, color: model.getCardTextColor()),
                Gaps.hGap10,
                Column(
                  children: [
                    cText('MONTH/YEAR',
                        fontSize: 8, color: model.getCardTextColor()),
                    Gaps.vGap4,
                    cText('${model.endDateMonth()}/${model.endDateYear()}',
                        fontFamily: 'CreditCard',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: model.getCardTextColor()),
                  ],
                )
              ],
            ).paddingOnly(left: 20, bottom: 5),
            cText('${model.cardCusName}',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: model.getCardTextColor())
                .paddingSymmetric(horizontal: 20),
          ],
        ),
      if (model.cardState() == UnionCardState.INACTIVATED)
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImagesRes.IC_WARNING_54.UIImage(color: Colors.white),
            Gaps.vGap12,
            cText('${S.current.physical_card_not_activated}(${model.cardId4})',
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
            Gaps.vGap8,
            cText(S.current.prepaid_activate_tip, color: Colors.white),
          ],
        ))
    ]),
  );
}

//虚拟卡
Widget virtualCard(BuildContext context, UnionPayCardResModel model,
    {bool? cardNumVisible = true, VoidCallback? onVisibleClick}) {
  return Container(
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
            colorFilter: model.cardState() == UnionCardState.INACTIVATED
                ? const ColorFilter.mode(
                    AppColors.color80000000, BlendMode.color)
                : null,
            image: const AssetImage(ImagesRes.ICON_PREPAID_VIRTUAL_V2),
            fit: BoxFit.fill)
    ),
    child: Stack(children: [
      if (model.cardState() != UnionCardState.INACTIVATED)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Row(
              children: [
                Row(
                  children: [
                    cText(
                            cardNumVisible == true
                                ? (model.cardNumber())
                                : 'xxxx xxxx xxxx ${model.cardId4}',
                            color: model.getCardTextColor(),
                            fontSize: 15)
                        .intoFlexible(),
                    Gaps.hGap5,
                    ImagesRes.IC_CARD_VISIBLE_V2
                        .UIImage(color: Colors.white)
                        .onClick(() async {
                      onVisibleClick?.call();
                    })
                  ],
                ).intoExpend(),
                // AssetsRes.ICON_PREPAID_UNIONPAY_WHITE_V2.UIImage(),
              ],
            ),
            // Gaps.vGap5,
          ],
        ),
      if (model.cardState() == UnionCardState.INACTIVATED)
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImagesRes.IC_WARNING_54.UIImage(color: Colors.white),
            Gaps.vGap12,
            cText(S.current.virtual_card_not_activated,
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
            Gaps.vGap8,
            cText(S.current.prepaid_activate_tip, color: Colors.white),
          ],
        ))
    ]),
  );
}

//实体卡
Widget prepaidCardNewStyle(BuildContext context, UnionPayCardResModel model,
    {bool? cardNumVisible = true,
    VoidCallback? onVisibleClick,
    VoidCallback? onDetail}) {
  return Container(
    clipBehavior: Clip.hardEdge,
    width: ScreenUtil.screenWidth,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
            image: AssetImage(model.getCardUI()), fit: BoxFit.fill)),
    child: Stack(
      children: [
        Stack(children: [
          if (model.cardState() != UnionCardState.INACTIVATED)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: model
                      .cardNumberSplit()
                      .map((e) => cText(e,
                          fontFamily: 'CreditCard',
                          fontSize: 15,
                          color: model.getCardTextColor()))
                      .toList(),
                ).paddingSymmetric(horizontal: 20, vertical: 10),
                Row(
                  children: [
                    cText('VALID\nTHRU',
                        fontSize: 8, color: model.getCardTextColor()),
                    Gaps.hGap10,
                    Column(
                      children: [
                        cText('MONTH/YEAR',
                            fontSize: 8, color: model.getCardTextColor()),
                        Gaps.vGap4,
                        cText('${model.endDateMonth()}/${model.endDateYear()}',
                            fontFamily: 'CreditCard',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: model.getCardTextColor()),
                      ],
                    )
                  ],
                ).paddingOnly(left: 20, bottom: 5),
                cText('${model.cardCusName}',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: model.getCardTextColor())
                    .paddingSymmetric(horizontal: 20),
              ],
            ).onClick(() {
              onDetail?.call();
            }),
        ]).paddingSymmetric(vertical: 10, horizontal: 16),
        Visibility(
            visible: model.cardState() == UnionCardState.INACTIVATED,
            child: Container(
              color: AppColors.colorCC000000,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImagesRes.IC_BANK_CARD_DONE.UIImage(),
                    Gaps.vGap10,
                    cText(
                        '${S.current.physical_card_not_activated}(${model.cardId4})',
                        color: Colors.white),
                    Gaps.vGap10,
                    //Activate button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(60, 60, 67, 0.7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          cText(S.of(context).activate_now,
                              color: Colors.white),
                          Gaps.hGap10,
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ).onClick(() {
                      /// warning
                      // context.router
                      //     .push(PrepaidActivateFormPageRoute(model: model))
                      //     .then((value) {
                      //   print('返回  刷新卡管理');
                      // });
                    })
                  ],
                ),
              ),
            ))
      ],
    ),
  );
}

Widget buildSliderButton(BuildContext context,
    {FreezeState state = FreezeState.NORMAL,
    VoidCallback? action,
    bool? flag}) {
  var text = S.of(context).swipe_right_to_confirm;
  var icon = ImagesRes.IC_SLIDER_NORMAL_24;
  if (state == FreezeState.NORMAL) {
    //
    icon = ImagesRes.IC_SLIDER_NORMAL_24;
    text = S.of(context).swipe_right_to_confirm;
  } else if (state == FreezeState.FREEZE) {
    icon = ImagesRes.IC_FREEZE_24;
    text = S.of(context).swipe_right_to_freeze;
  } else if (state == FreezeState.UNFREEZE) {
    icon = ImagesRes.IC_UNFREEZE_20;
    text = S.of(context).swipe_right_to_unfreeze;
  }

  return SliderButton(
    flag: flag!,
    dismissible: false,
    action: () {
      action?.call();
    },
    alignLabel: Alignment.center,
    label: Text(
      text,
      style: const TextStyle(
          color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
    ),
    width: ScreenUtil.screenWidth - 50,
    backgroundColor: Colors.white,
    radius: 10,
    height: 50,
    dismissThresholds: 0.4,
    icon: Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: AppColors.colorFF3E47,
          borderRadius: BorderRadius.circular(10)),
      child: icon.UIImage(),
    ),
  )
      .intoColumn(mainAxisAlignment: MainAxisAlignment.end)
      .paddingOnly(bottom: 150)
      .intoExpend();
}

Widget buildTip(String tip) {
  return Row(
    children: [
      ClipOval(
        child: Container(
          color: AppColors.color3478f5,
          width: 6,
          height: 6,
        ),
      ),
      Gaps.hGap10,
      cText(tip,
              color: AppColors.color666666,
              fontSize: 12,
              textAlign: TextAlign.start)
          .intoExpend()
    ],
  );
}

Widget buildTextInput(BuildContext context,
    {TextEditingController? controller,
    bool enable = true,
    bool amountInput = false,
    FocusNode? focusNode}) {
  return CustomTextFiled(
    fillColor: AppColors.colorF5F5F5,
    controller: controller,
    focusNode: focusNode,
    hintFontSize: 14,
    hasPrefixIcon: false,
    enable: enable,
    amountInput: amountInput,
    radius: Dimens.gap_dp6,
    hintColor: AppColors.color9A9A9A,
    hintText: enable ? S.of(context).please_enter : '',
  ).intoContainer(height: 48);
}

Widget buildNextButton(String text,
    {VoidCallback? onTap, bool isEnable = true, double top = 40}) {
  return cRippleButton(text, onTap: onTap, isEnable: isEnable).intoPadding(
      padding: EdgeInsets.only(bottom: 80, left: 15, right: 15, top: top));
}

Widget arrowUnderLineItem(String title,
    {VoidCallback? onTap, bool? needUnderLine = true, Widget? leading}) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    ListTile(
      onTap: onTap,
      leading: leading,
      title: cText(title,
          fontSize: 16,
          color: AppColors.color1E1F20,
          textAlign: TextAlign.start),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: AppColors.color858B9C,
      ),
    ),
    if (needUnderLine == true)
      Container().verticalLine(
        horizontalMargin: 15.0.px,
        width: double.infinity,
        color: AppColors.colorEEEEEE,
      ),
  ]);
}

Widget templateNewItem(UnionPayTemplateModel data, BuildContext context,
    {VoidCallback? onTap,
    VoidCallback? onDelete,
    ValueChanged<UnionPayTemplateModel>? updateTemplate}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  data.getIcon().UIImage(),
                  Gaps.hGap10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cText(data.name ?? '',
                          textAlign: TextAlign.left,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.color333333,
                          maxLine: 1),
                      cText(data.keyId ?? '',
                          textAlign: TextAlign.right,
                          color: AppColors.color79747E,
                          maxLine: 1),
                    ],
                  ).intoExpend()
                ],
              ).intoExpend(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showSheet(
                                context,
                                FavoriteEditBottom(
                                    transferType: UnionCardTransferType
                                        .toBonglogCard.value,
                                    templateModel: data))
                            .then((value) {
                          if (value != null) {
                            updateTemplate
                                ?.call(value as UnionPayTemplateModel);
                          }
                        });
                      },
                      icon: ImagesRes.IC_CARD_FAVORITE_EDIT.UIImage()),
                  IconButton(
                      onPressed: () {
                        DialogUtil.showTextDialog(
                            context, S.current.is_delete_template, () {
                          onDelete?.call();
                        }, rightText: S.current.pop_button_delete);
                      },
                      icon: ImagesRes.IC_CARD_FAVORITE_DELETE.UIImage()),
                ],
              )
            ],
          ).intoPadding(padding: const EdgeInsets.symmetric(vertical: 14)),
        ]),
      ));
}

Widget templateItem(UnionPayTemplateModel data, BuildContext context,
    {VoidCallback? onTap, VoidCallback? onDelete}) {
  return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        DialogUtil.showSimpleDialog(context, S.current.is_delete_template, () {
          onDelete?.call();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(children: [
          Row(
            children: [
              data.getIcon().UIImage(),
              Gaps.hGap12,
              cText(data.name ?? '',
                      textAlign: TextAlign.left,
                      color: AppColors.color1E1F20,
                      maxLine: 1)
                  .intoExpend(),
              Gaps.hGap12,
              cText(data.keyId ?? '',
                  textAlign: TextAlign.right,
                  color: AppColors.color858B9C,
                  maxLine: 1),
              Gaps.hGap12,
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: AppColors.color858B9C,
              )
            ],
          ).intoPadding(padding: const EdgeInsets.symmetric(vertical: 14)),
          Container().verticalLine(
            width: double.infinity,
            height: 1,
            color: AppColors.colorEEEEEE,
          )
        ]),
      ));
}

Widget buildCardBottomTitle(String title, {VoidCallback? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      cText(title,
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
      ClipOval(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(color: AppColors.colorECECEC),
          child: const Icon(
            Icons.close,
            color: AppColors.color3C3C43,
            size: 20,
          ),
        ),
      ).onClick(onTap)
    ],
  );
}
