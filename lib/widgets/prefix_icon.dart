
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/widget_extension.dart';

import '../helper/colors.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/2/14 16:36
/// @Description:
/// /////////////////////////////////////////////

class PrefixIcon extends StatelessWidget {
  final String content;
  final VoidCallback onTap;
  final bool? isCanDropDown;
  final IconData? icon;
  final Color iconColor;
  final double prefixFontSize;
  final double paddingRight;
  final double paddingLeft;

  PrefixIcon(
      {Key? key,
        required this.content,
        required this.onTap,
        this.isCanDropDown = true,
        this.icon = Icons.arrow_drop_down,
        this.iconColor = AppColors.colorC6CAD1,
        this.prefixFontSize = 17.0,
        this.paddingRight = 5.0,
        this.paddingLeft = 10.0
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(content,
              style: TextStyle(fontSize: prefixFontSize, fontWeight: FontWeight.w500)),
          isCanDropDown == true
              ? Icon(icon, color: iconColor)
              : Container(
            width: 1,
            height: 16.0,
            margin: EdgeInsets.symmetric(horizontal: 13.0),
            color: Color(0xffDFDFDF),
          ),
        ],
      ).intoContainer(padding: EdgeInsets.only(left: paddingLeft, right: paddingRight)),
    );
  }
}
