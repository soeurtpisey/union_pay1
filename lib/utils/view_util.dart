import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/colors.dart';
import '../widgets/common.dart';
import '../widgets/page_loading_indicator.dart';

Future<T?> showSheet<T>(
    BuildContext context,
    Widget body, {
      bool scrollControlled = true,
      Color bodyColor = Colors.white,
      bool isDismissible = true,
      EdgeInsets? bodyPadding,
      BorderRadius? borderRadius,
    }) {
  const radius = Radius.circular(16);
  borderRadius ??= const BorderRadius.only(topLeft: radius, topRight: radius);
  bodyPadding ??= const EdgeInsets.all(20);
  return showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: bodyColor,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      barrierColor: Colors.black.withOpacity(0.25),
      // A处
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top),
      isScrollControlled: scrollControlled,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: bodyPadding!.left,
          top: bodyPadding.top,
          right: bodyPadding.right,
          // B处
          bottom:
          bodyPadding.bottom + MediaQuery.of(ctx).viewPadding.bottom,
        ),
        child: body,
      ));
}

Container buildBottomTitle(BuildContext context, String title,
    {EdgeInsetsGeometry? margin}) {
  return Container(
    margin: margin ?? const EdgeInsets.only(bottom: 19),
    child: Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          iconSize: 25,
          icon: const Icon(
            Icons.close,
            color: Color(0xff666666),
          ),
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: cText(title, fontSize: 18, fontWeight: FontWeight.w500),
            ))
      ],
    ),
  );
}

Positioned buildLoadingStack(bool? visible) {
  return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Visibility(
          visible: visible == true,
          child: const Center(
            child: CupertinoActivityIndicator(),
          )));
}

Positioned buildPageLoadingStack(bool? visible, {Color? color}) {
  return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Visibility(
          visible: visible == true,
          child: Center(
            child: PageLoadingIndicator(
              color: color ?? AppColors.colorEE290B,
            ),
          )));
}

Widget buildLoading(bool? visible) {
  return Visibility(
      visible: visible == true,
      child: const Center(
        child: CupertinoActivityIndicator(),
      ));
}

SystemUiOverlayStyle getSystemOverlay = const SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarDividerColor: null,
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);