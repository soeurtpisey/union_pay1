import 'package:flutter/material.dart';

import '../../helper/colors.dart';
import '../../utils/dimen.dart';
import '../../utils/screen_util.dart';
import '../common.dart';

/*
 * 带水波纹点击效果的按钮
 */
class RippleButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Widget? child;
  final BorderRadius? borderRadius;
  final Color? bgColor;
  Decoration? decoration;

  RippleButton(
      {this.child,
      this.onTap,
      this.bgColor = Colors.white,
      this.borderRadius,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    decoration ??= BoxDecoration(
        //不能同时”使用Ink的变量color属性以及decoration属性，两个只能存在一个
        color: bgColor,
        //设置圆角
        borderRadius: borderRadius);
    return Center(
        child: Material(
            //INK可以实现装饰容器
            child: Ink(
                decoration: decoration,
                child: InkWell(
                    //圆角设置,给水波纹也设置同样的圆角
                    //如果这里不设置就会出现矩形的水波纹效果
                    borderRadius: borderRadius,
                    //设置点击事件回调
                    onTap: onTap,
                    child: child))));
  }
}

Widget cRippleButton(String text,
    {VoidCallback? onTap,
    bool isEnable = true,
    double? width,
    Color? textColor,
    BoxDecoration? decoration,
    double? radius,
    Color? color}) {
  return RippleButton(
    onTap: isEnable == true ? onTap : null,
    bgColor: color,
    borderRadius: BorderRadius.circular(radius ?? Dimens.gap_dp6),
    child: Container(
      width: width ?? ScreenUtil.screenWidth,
      height: Dimens.gap_dp40,
      decoration: decoration ??
          BoxDecoration(
              color: color ??
                  (isEnable ? AppColors.colorE60013 : AppColors.colorE6001350),
              borderRadius: BorderRadius.circular(radius ?? Dimens.gap_dp6)),
      child: Center(
        child: cText(text, color: textColor ?? Colors.white),
      ),
    ),
  );
}
