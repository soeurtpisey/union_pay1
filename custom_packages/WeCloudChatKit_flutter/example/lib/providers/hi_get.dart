import 'package:flutter/material.dart';
import 'package:get/get.dart';

///跳转页面
///如果你使用多个Bindings，不要使用SmartManagement.keepFactory。它被设计成在没有Bindings的情况下使用，或者在GetMaterialApp的初始Binding中链接一个Binding。
// 使用Bindings是完全可选的，你也可以在使用给定控制器的类上使用Get.put()和Get.find()。 然而，如果你使用Services或任何其他抽象，我建议使用Bindings来更好地组织。
///class HomeBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<HomeController>(() => HomeController());
//     Get.put<Service>(()=> Api());
//   }
// }
///opaque 透明度
///transition 过渡
///Curve 动画曲线
///duration 持续时间
///id  means id
///routeName 别名跳转用的
///fullscreenDialog 是否是全屏dialog
///arguments 参数
///Bindings 通常用于service 之类的，即跳转的时候就初始化
///preventDuplicates 防止重复
///popGesture 手势开启
///gestureWidth 手势宽度
///页面返回值的获取方式
///var data = await Get.to(NewScreen(),arguments: "111222333");
// // ignore: unrelated_type_equality_checks
// print(data);
// if(data == 1){
//   setState((){
//      widget._content = "successFisNull";
//   });
// }
Future<T?>? Hito<T>(
  dynamic page, {
  bool? opaque,
  Transition? transition,
  Curve? curve,
  Duration? duration,
  int? id,
  String? routeName,
  bool fullscreenDialog = false,
  dynamic arguments,
  Bindings? binding,
  bool preventDuplicates = true,
  bool? popGesture,
  double Function(BuildContext context)? gestureWidth,
}) {
  return Get.to<T>(
    page,
    opaque: opaque,
    transition: transition,
    curve: curve,
    duration: duration,
    id: id,
    routeName: routeName,
    fullscreenDialog: fullscreenDialog,
    arguments: arguments,
    binding: binding,
    preventDuplicates: preventDuplicates,
    popGesture: popGesture,
    gestureWidth: gestureWidth,
  );
}

///返回上一页，可带参数
///result 返回结果 类似onActivityforreslut
///closeOverlays 默认值
///canPop 默认值
///id means id
void Hiback<T>({
  T? result,
  bool closeOverlays = false,
  bool canPop = true,
  int? id,
}) {
  Get.back(
      result: result, closeOverlays: closeOverlays, canPop: canPop, id: id);
}

///跳转下一个页面，但是不能返回上一个页面
///一般用于Splash 页面的下一个跳转 或者登陆
///参数参考 to()
void Hioff(
  dynamic page, {
  bool opaque = false,
  Transition? transition,
  Curve? curve,
  bool? popGesture,
  int? id,
  String? routeName,
  dynamic arguments,
  Bindings? binding,
  bool fullscreenDialog = false,
  bool preventDuplicates = true,
  Duration? duration,
  double Function(BuildContext context)? gestureWidth,
}) {
  Get.off(page,
      opaque: opaque,
      transition: transition,
      curve: curve,
      popGesture: popGesture,
      id: id,
      routeName: routeName,
      arguments: arguments,
      binding: binding,
      fullscreenDialog: fullscreenDialog,
      preventDuplicates: preventDuplicates,
      duration: duration,
      gestureWidth: gestureWidth);
}

///进入下一个界面并取消之前的所有路由（在购物车、投票和测试中很有用）。
///RoutePredicate 路线:应该是规定要关闭的路由线路
void HioffAll(
  dynamic page, {
  RoutePredicate? predicate,
  bool opaque = false,
  bool? popGesture,
  int? id,
  String? routeName,
  dynamic arguments,
  Bindings? binding,
  bool fullscreenDialog = false,
  Transition? transition,
  Curve? curve,
  Duration? duration,
  double Function(BuildContext context)? gestureWidth,
}) {
  Get.offAll(page,
      predicate: predicate,
      opaque: opaque,
      popGesture: popGesture,
      id: id,
      routeName: routeName,
      arguments: arguments,
      binding: binding,
      fullscreenDialog: fullscreenDialog,
      transition: transition,
      curve: curve,
      duration: duration,
      gestureWidth: gestureWidth);
}

///show 弹出 提示
/// snackbar('Hi', 'i am a modern snackbar');
/// snackbar(
//   "Hey i'm a Get SnackBar!", // title
//   "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
//   icon: Icon(Icons.alarm),
//   shouldIconPulse: true,
//   onTap:(){},
//   barBlur: 20,
//   isDismissible: true,
//   duration: Duration(seconds: 3),
// );
void HigetSnackbar(
  String title,
  String message, {
  Color? colorText,
  Duration? duration,

  /// with instantInit = false you can put snackbar on initState
  bool instantInit = true,
  SnackPosition? snackPosition,
  Widget? titleText,
  Widget? messageText,
  Widget? icon,
  bool? shouldIconPulse,
  double? maxWidth,
  EdgeInsets? margin,
  EdgeInsets? padding,
  double? borderRadius,
  Color? borderColor,
  double? borderWidth,
  Color? backgroundColor,
  Color? leftBarIndicatorColor,
  List<BoxShadow>? boxShadows,
  Gradient? backgroundGradient,
  TextButton? mainButton,
  OnTap? onTap,
  bool? isDismissible,
  bool? showProgressIndicator,
  AnimationController? progressIndicatorController,
  Color? progressIndicatorBackgroundColor,
  Animation<Color>? progressIndicatorValueColor,
  SnackStyle? snackStyle,
  Curve? forwardAnimationCurve,
  Curve? reverseAnimationCurve,
  Duration? animationDuration,
  double? barBlur,
  double? overlayBlur,
  SnackbarStatusCallback? snackbarStatus,
  Color? overlayColor,
  Form? userInputForm,
}) {
  Get.snackbar(title, message,
      colorText: colorText,
      duration: duration,
      instantInit: instantInit,
      snackPosition: snackPosition,
      titleText: titleText,
      messageText: messageText,
      icon: icon,
      shouldIconPulse: shouldIconPulse,
      maxWidth: maxWidth,
      margin: margin,
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      backgroundColor: backgroundColor,
      leftBarIndicatorColor: leftBarIndicatorColor,
      boxShadows: boxShadows,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      isDismissible: isDismissible,
      showProgressIndicator: showProgressIndicator,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      snackStyle: snackStyle,
      forwardAnimationCurve: forwardAnimationCurve,
      reverseAnimationCurve: reverseAnimationCurve,
      animationDuration: animationDuration,
      barBlur: barBlur,
      overlayBlur: overlayBlur,
      snackbarStatus: snackbarStatus,
      overlayColor: overlayColor,
      userInputForm: userInputForm);
}

///barrierDismissible 是否能取消
///barrierColor 背景色吧应该
///arguments参数
///transitionDuration动画过渡时间
///transitionCurve 动画曲线
///name：means name
///routeSettings：路由设置
///例子
///Get.dialog(YourDialogWidget());
void Hidialog(
  Widget widget, {
  bool barrierDismissible = true,
  Color? barrierColor,
  bool useSafeArea = true,
  GlobalKey<NavigatorState>? navigatorKey,
  Object? arguments,
  Duration? transitionDuration,
  Curve? transitionCurve,
  String? name,
  RouteSettings? routeSettings,
}) {
  Get.dialog(widget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      navigatorKey: navigatorKey,
      arguments: arguments,
      transitionDuration: transitionDuration,
      transitionCurve: transitionCurve,
      name: name,
      routeSettings: routeSettings);
}

///打开默认对话框。
///例子
/// Get.defaultDialog(
//   onConfirm: () => print("Ok"),
//   middleText: "Dialog made in 3 lines of code"
// );
void HidefaultDialog({
  String title = "Alert",
  EdgeInsetsGeometry? titlePadding,
  TextStyle? titleStyle,
  Widget? content,
  EdgeInsetsGeometry? contentPadding,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  VoidCallback? onCustom,
  Color? cancelTextColor,
  Color? confirmTextColor,
  String? textConfirm,
  String? textCancel,
  String? textCustom,
  Widget? confirm,
  Widget? cancel,
  Widget? custom,
  Color? backgroundColor,
  bool barrierDismissible = true,
  Color? buttonColor,
  String middleText = "Dialog made in 3 lines of code",
  TextStyle? middleTextStyle,
  double radius = 20.0,
  //   ThemeData themeData,
  List<Widget>? actions,

  // onWillPop Scope
  WillPopCallback? onWillPop,

  // the navigator used to push the dialog
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  Get.defaultDialog(
      title: title,
      titlePadding: titlePadding,
      titleStyle: titleStyle,
      content: content,
      contentPadding: contentPadding,
      onConfirm: onConfirm,
      onCancel: onCancel,
      onCustom: onCustom,
      cancelTextColor: cancelTextColor,
      confirmTextColor: confirmTextColor,
      textConfirm: textConfirm,
      textCancel: textCancel,
      textCustom: textCustom,
      confirm: confirm,
      cancel: cancel,
      custom: custom,
      backgroundColor: backgroundColor,
      barrierDismissible: barrierDismissible,
      buttonColor: buttonColor,
      middleText: middleText,
      middleTextStyle: middleTextStyle,
      radius: radius,
      actions: actions,
      onWillPop: onWillPop,
      navigatorKey: navigatorKey);
}

///显示地步弹窗
///例子
///Get.bottomSheet(
//   Container(
//     child: Wrap(
//       children: <Widget>[
//         ListTile(
//           leading: Icon(Icons.music_note),
//           title: Text('Music'),
//           onTap: () => {}
//         ),
//         ListTile(
//           leading: Icon(Icons.videocam),
//           title: Text('Video'),
//           onTap: () => {},
//         ),
//       ],
//     ),
//   )
// );
///
HibottomSheet(
  Widget bottomsheet, {
  Color? backgroundColor,
  double? elevation,
  bool persistent = true,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool? ignoreSafeArea,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? settings,
  Duration? enterBottomSheetDuration,
  Duration? exitBottomSheetDuration,
}) {
  Get.bottomSheet(bottomsheet,
      backgroundColor: backgroundColor,
      elevation: elevation,
      persistent: persistent,
      shape: shape,
      clipBehavior: clipBehavior,
      ignoreSafeArea: ignoreSafeArea,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      settings: settings,
      enterBottomSheetDuration: enterBottomSheetDuration,
      exitBottomSheetDuration: exitBottomSheetDuration);
}

double get width => Get.width;

double get height => Get.height;

double get statusBarHeight => Get.statusBarHeight;

double get bottomBarHeight => Get.bottomBarHeight;

BuildContext? get context => Get.context;

/// give current arguments
dynamic get hiArguments => Get.routing.args;

void HiUpdateLocale(Locale l) {
  Get.updateLocale(l);
}

/// 你想得到保存的类，比如控制器或其他东西。
S Hiput<S>(S s, {Key? key, String? tag, bool permanent = false}) {
  return Get.put(s, tag: tag, permanent: permanent);
}

/// 一个将被执行的异步方法，用于实例化你的类。
Future<S> HiputAsync<S>(AsyncInstanceBuilderCallback<S> builder,
    {String? tag, bool permanent = false}) {
  return Get.putAsync(builder, tag: tag, permanent: permanent);
}

/// 只有在第一次调用Get.find<S>时，S才会被返回。这不是废话吗
void HiputLazy<S>(InstanceBuilderCallback<S> builder,
    {String? tag, bool fenix = false}) {
  Get.lazyPut(() => builder, tag: tag, fenix: fenix);
}

/// 一个返回每次调用"Get.find() "都会被新建的类的函数。
/// Get.create(() => Text("测试GetX1",style: TextStyle(fontSize: 10,color: Colors.blue),),tag:"blueTxt");
// 注意一定要设置 tag 方便 这样取
// Get.find<Text>(tag: "blueTxt").build(context)
void Hicreate<S>(InstanceBuilderCallback<S> builder,
    {String? tag, bool permanent = true}) {
  return Get.create(() => builder, tag: tag, permanent: permanent);
}

///找到对应的类
S Hifind<S>({Key? key, String? tag}) {
  return Get.find<S>(tag: tag);
}

class HiObx extends Obx {
  HiObx(WidgetCallback builder) : super(builder);
}

class HiGetBuilder<T extends GetxController> extends GetBuilder<T> {
  final GetControllerBuilder<T> builder;
  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(GetBuilderState<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(GetBuilder oldWidget, GetBuilderState<T> state)?
      didUpdateWidget;
  final T? init;

  HiGetBuilder({
    Key? key,
    this.init,
    this.global = true,
    required this.builder,
    this.autoRemove = true,
    this.assignId = false,
    this.initState,
    this.filter,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  }) : super(
            builder: builder,
            global: global,
            id: id,
            tag: tag,
            autoRemove: autoRemove,
            assignId: assignId,
            filter: filter,
            initState: initState,
            dispose: dispose,
            didChangeDependencies: didChangeDependencies,
            didUpdateWidget: didUpdateWidget,
            init: init);
}

class HiGetX<T extends GetxController> extends GetX<T> {
  final GetXControllerBuilder<T> builder;
  final bool global;

  // final Stream Function(T) stream;
  // final StreamController Function(T) streamController;
  final bool autoRemove;
  final bool assignId;
  final void Function(GetXState<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(GetX oldWidget, GetXState<T> state)? didUpdateWidget;
  final T? init;
  final String? tag;

  HiGetX({
    this.tag,
    required this.builder,
    this.global = true,
    this.autoRemove = true,
    this.initState,
    this.assignId = false,
    //  this.stream,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.init,
    // this.streamController
  }) : super(
          builder: builder,
          global: global,
          autoRemove: autoRemove,
          assignId: assignId,
          initState: initState,
          dispose: dispose,
          didChangeDependencies: didChangeDependencies,
          didUpdateWidget: didUpdateWidget,
          init: init,
          tag: tag,
        );
}

class HiGetController extends GetxController {}

extension StringExtension on String {
  /// Returns a `RxString` with [this] `String` as initial value.
  RxString get hiobs => RxString(this);
}

extension IntExtension on int {
  /// Returns a `RxInt` with [this] `int` as initial value.
  RxInt get hiobs => RxInt(this);
}

extension DoubleExtension on double {
  /// Returns a `RxDouble` with [this] `double` as initial value.
  RxDouble get hiobs => RxDouble(this);
}

extension BoolExtension on bool {
  /// Returns a `RxBool` with [this] `bool` as initial value.
  RxBool get hiobs => RxBool(this);
}

extension RxT<T> on T {
  /// Returns a `Rx` instance with [this] `T` as initial value.
  Rx<T> get hiobs => Rx<T>(this);
}
