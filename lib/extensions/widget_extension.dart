
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:union_pay/helper/colors.dart';

import '../widgets/debounce.dart';
import '../widgets/scroll_behavior.dart';

extension WidgetExtension on Widget {
  // 高度一样
  Widget get intrinsicHeight {
    return IntrinsicHeight(
      child: this,
    );
  }

  Expanded intoExpend({
    Key? key,
    int flex = 1,
  }) {
    return Expanded(
      key: key,
      flex: flex,
      child: this,
    );
  }

  ScrollConfiguration intoScrollConfiguration() {
    return ScrollConfiguration(behavior: MyBehavior(), child: this);
  }

  SingleChildScrollView intoSingleScroll() {
    return SingleChildScrollView(
      child: this,
    );
  }

  Flexible intoFlexible({
    Key? key,
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) {
    return Flexible(
      key: key,
      flex: flex,
      fit: fit,
      child: this,
    );
  }

  Column intoColumn(
      {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: [this],
    );
  }

  Widget intoCenter() {
    return Center(
      child: this,
    );
  }

  SafeArea intoSafeArea(){
    return SafeArea(child: this);
  }

  Container intoContainer({
    //复制Container构造函数的所有参数（除了child字段）
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
  }) {
    //调用Container的构造函数，并将当前widget对象作为child参数
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      child: this,
    );
  }

  Positioned intoPositioned(
      {double? left,
        double? right,
        double? top,
        double? bottom,
        double? width,
        double? height}) {
    return Positioned(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        width: width,
        height: height,
        child: this);
  }

  Padding intoPadding({required EdgeInsetsGeometry padding}) {
    return Padding(padding: padding, child: this);
  }

  Widget verticalLine(
      {Color? color,
        double? width = 1.0,
        double? height = 1.0,
        double? horizontalMargin = 0.0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin!),
      color: color ?? AppColors.colorDDDDDD,
      width: width,
      height: height,
    );
  }

  Widget setOpacity({double? value = 0.3}) {
    return Opacity(opacity: value!, child: this);
  }

  Widget when(bool showWidget) {
    return showWidget ? this : Container();
  }

  Widget onClick(callback) {
    return InkWell(
      onTap: callback,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: this,
    );
  }

  Widget intoSliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: this,
    );
  }

  Widget onDebounce(callback){
    return DebounceWidget(
      child: onClick(callback),
    );
  }
}
