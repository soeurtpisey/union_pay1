import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';

import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../models/prepaid/enums/union_card_menu_type.dart';
import '../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../utils/custom_decoration.dart';
import '../common.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/22 10:32
/// @Description: 账户item
/// /////////////////////////////////////////////
///

typedef _OnMenuSelect = void Function(UnionCardMenuType type);

class PrepaidAccountView extends StatefulWidget {
  final UnionPayCardResModel? model;
  final _OnMenuSelect? onMenuSelect;
  const PrepaidAccountView({Key? key, this.onMenuSelect, this.model})
      : super(key: key);

  @override
  State<PrepaidAccountView> createState() => _PrepaidAccountViewState();
}

class _PrepaidAccountViewState extends State<PrepaidAccountView> {
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          ImagesRes.ICON_PREPAID_UNIONPAY_V2.UIImage(),
          Gaps.hGap10,
          cText(widget.model?.cardNumber() ?? '',
                  textAlign: TextAlign.left, color: AppColors.color777777)
              .intoExpend(),
          CustomPopupMenu(
            horizontalMargin: 0,
            verticalMargin: 0,
            menuBuilder: () => _buildLongPressMenu(),
            barrierColor: AppColors.color1F000000,
            arrowColor: Colors.white,
            pressType: PressType.singleClick,
            controller: _controller,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 40, minHeight: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: const Icon(
                Icons.more_horiz,
                color: AppColors.color777777,
              ),
            ),
          )
        ]),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.vGap10,
            cText(widget.model?.getAccountName() ?? '',
                textAlign: TextAlign.left,
                color: AppColors.color282828,
                fontWeight: FontWeight.w600),
            Gaps.vGap10,
            cText(
                widget.model?.availableAmount?.toString().formatCurrency() ??
                    '',
                textAlign: TextAlign.left,
                color: AppColors.colorFF3E47,
                fontSize: 18,
                fontWeight: FontWeight.w500)
          ],
        ).intoExpend()
      ],
    ).intoContainer(
        height: 115,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        margin: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 12,
        ),
        decoration: normalDecoration(color: Colors.white));
  }

  Widget _buildLongPressMenu() {
    var menuItems = [
      AccountItemType(
          UnionCardMenuType.CHANGE_ACCOUNT_NAME, S.current.change_account_name),
    ];
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
            color: Colors.white,
            margin: const EdgeInsets.only(right: 15),
            child: IntrinsicWidth(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (item) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.onMenuSelect?.call(item.type);
                        _controller.hideMenu();
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.colorEEEEEE, width: 1))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: cText(item.title,
                                    color: AppColors.color282828,
                                    textAlign: TextAlign.left),
                              ),
                            ),
                            if (item.type == UnionCardMenuType.DEFAULT)
                              Transform.scale(
                                  scale: 0.5,
                                  alignment: Alignment.centerRight,
                                  child: CupertinoSwitch(
                                      activeColor: AppColors.colorFF3E47,
                                      value: true,
                                      onChanged: (v) {}))
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ))));
  }
}

class AccountItemType {
  UnionCardMenuType type;
  String title;
  AccountItemType(this.type, this.title);
}
