import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/double_extension.dart';

import '../helper/colors.dart';

BoxDecoration btnDecoration({Color? color, BorderRadius? borderRadius}) {
  return BoxDecoration(
      color: color ?? AppColors.colorE70013,
      borderRadius: borderRadius ?? BorderRadius.circular(6.0.px));
}

BoxDecoration normalDecoration({
  Color? color,
  BorderRadius? borderRadius,
  Gradient? gradient,
  double circular=6.0
}) {
  return BoxDecoration(
      color: gradient == null ? color ?? AppColors.color60013 : null,
      gradient: gradient,
      borderRadius: borderRadius ?? BorderRadius.circular(circular));
}

BoxDecoration borderDecoration(
    {Color? borderColor, BorderRadius? borderRadius}) {
  return BoxDecoration(
      color: Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(6.0.px),
      border: Border.all(color: borderColor ?? AppColors.color60013));
}

BoxDecoration bottomDialogDecoration(
    {Color? color, BorderRadius? borderRadius}) {
  return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: borderRadius ??
          BorderRadius.only(
              topRight: Radius.circular(16.0.px),
              topLeft: Radius.circular(16.0.px)));
}
