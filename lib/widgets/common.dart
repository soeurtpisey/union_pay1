
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:union_pay/extensions/double_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../helper/colors.dart';
import '../utils/custom_decoration.dart';
import 'button/ripple_button.dart';
import 'debounce.dart';

Widget cText(String content,
    {Color color = Colors.grey,
      double fontSize = 14,
      int? maxLine,
      TextAlign textAlign = TextAlign.start,
      TextOverflow? overflow,
      bool? softWrap,
      double? letterSpacing,
      double? wordSpacing,
      double? height,
      Shader? shader,
      String? fontFamily,
      FontWeight fontWeight = FontWeight.w400,
      TextDecoration decoration = TextDecoration.none,
      FontStyle? fontStyle}) {
  //升级新版本dart后，字体统一变大了
  return Text(
    content,
    textAlign: textAlign,
    maxLines: maxLine,
    softWrap: softWrap,
    overflow: overflow ?? (maxLine != null ? TextOverflow.ellipsis : null),
    style: TextStyle(
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      fontFamily: fontFamily,
      height: height,
      foreground: shader == null ? null : (Paint()..shader = shader),
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
    ),
  );
}

Widget btnWithLoading(
    {required String? title,
      bool isEnable = true,
      bool? isLoading = false,
      bool isLoadingWithTitle = false,
      VoidCallback? onTap,
      Color? backgroundColor,
      Color? textColor,
      Widget? leading,
      Color? disableBackGroundColor = AppColors.colorD1D3D9,
      Color? disableTitleColor,
      double circular = 6.0,
      Color? fontColor,
      double? height = 40,
      bool? debounce = false,
      EdgeInsetsGeometry? margin,
      bool? isBorder}) {
  return Material(
      color: AppColors.background,
      child: Ink(
          height: height,
          width: double.infinity,
          decoration: isBorder == true
              ? BoxDecoration(
              border: Border.all(color: AppColors.colorE70013),
              borderRadius: BorderRadius.circular(circular))
              :
          normalDecoration(
              circular: circular,
              color: isEnable
                  ? (backgroundColor ?? AppColors.colorE70013)
                  : disableBackGroundColor),
          child: debounce == true
              ? DebounceWidget(
              child: InkWell(
                  onTap: () {
                    if (onTap != null &&
                        isLoading == false &&
                        isEnable == true) {
                      onTap();
                    }
                  },
                  borderRadius: BorderRadius.circular(circular),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading!
                            ? isLoadingWithTitle
                            ? Row(
                          children: [
                            if (leading != null) leading,
                            cText(title ?? '',
                                fontSize: 15.0,
                                color: textColor ?? Colors.white,
                                fontWeight: FontWeight.w500),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                AlwaysStoppedAnimation(
                                  isBorder == true
                                      ? AppColors.colorE70013
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                            : Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation(
                              isBorder == true
                                  ? AppColors.colorE70013
                                  : Colors.white,
                            ),
                          ),
                        ).intoContainer(width: 20, height: 20)
                            : Row(
                          children: [
                            if (leading != null) leading,
                            cText(title ?? '',
                                fontSize: 15.0,
                                color: textColor ?? Colors.white,
                                fontWeight: FontWeight.w500)
                          ],
                        )
                      ])))
              : InkWell(
              onTap: () {
                if (onTap != null &&
                    isLoading == false &&
                    isEnable == true) {
                  onTap();
                }
              },
              borderRadius: BorderRadius.circular(circular),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading!
                        ? isLoadingWithTitle
                        ? Row(
                      children: [
                        if (leading != null) leading,
                        cText(title ?? '',
                            fontSize: 15.0,
                            color: textColor ?? Colors.white,
                            fontWeight: FontWeight.w500),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation(
                              isBorder == true
                                  ? AppColors.colorE70013
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          isBorder == true
                              ? AppColors.colorE70013
                              : Colors.white,
                        ),
                      ),
                    ).intoContainer(width: 20, height: 20)
                        : Row(
                      children: [
                        if (leading != null) leading,
                        cText(title ?? '',
                            fontSize: 15.0,
                            color: textColor ?? Colors.white,
                            fontWeight: FontWeight.w500)
                      ],
                    )
                  ]))))
      .intoContainer(
    margin: margin ?? EdgeInsets.symmetric(horizontal: 30.0.px),
  );
}

Widget cScaffold(BuildContext context, String title,
    {Widget? child,
      Widget? floatingActionButton,
      PreferredSizeWidget? bottom,
      bool resizeToAvoidBottomInset = false,
      bool hasLeading = true,
      List<Widget>? actions,
      VoidCallback? onPressed,
      Color? appBarBgColor,
      Color? appBarColor,
      Color? backgroundColor,
      Widget? bottomNavigationBar}) {
  return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar(context, title,
          backgroundColor: appBarBgColor ?? AppColors.background,
          backBtnColor: appBarColor,
          titleColor: appBarColor,
          hasLeading: hasLeading,
          onPressed: onPressed,
          bottom: bottom,
          actions: actions),
      floatingActionButton: floatingActionButton,
      body: child,
      bottomNavigationBar: bottomNavigationBar);
}

Widget cPinPut(
    {bool? autofocus,
      int? fieldsCount,
      String? obscureText,
      bool useNativeKeyboard = true,
      TextStyle? textStyle,
      ValueChanged<String>? onSubmit,
      ValueChanged<String>? onChanged,
      FocusNode? focusNode,
      TextEditingController? controller,
      BoxDecoration? selectedFieldDecoration,
      BoxDecoration? followingFieldDecoration,
      BoxDecoration? submittedFieldDecoration,
      bool forceErrorState = false,
      String? preFilledChar,
      PinTheme? pinTheme,
      PinTheme? errorTheme,
      double? separatorWidth = 10}) {
  final defaultPinTheme = PinTheme(
    width: 50,
    height: 42,
    textStyle:
    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500, color: Colors.black), //GoogleFonts.poppins(fontSize: 20, color: Color.fromRGBO(70, 69, 66, 1)),
    decoration: followingFieldDecoration,
  );
  final errorPinTheme = PinTheme(
    width: 50,
    height: 42,
    textStyle: const TextStyle(fontSize: 20, color: AppColors.colorE60013),
    decoration: followingFieldDecoration ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0xffEFEFEF),
          border: Border.all(
            color: AppColors.colorE60013,
          ),
        ),
  );
  return Pinput(
    autofocus: autofocus ?? true,
    length: fieldsCount ?? 4,
    useNativeKeyboard: useNativeKeyboard,
    obscureText: obscureText?.isNotEmpty == true,
    obscuringWidget: Text(
      obscureText ?? '',
      style: textStyle,
    ),
    validator: (v) {
      var value = v ?? '';
      onSubmit?.call(value);
    },
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    onChanged: (value) {
      onChanged?.call(value);
    },
    focusNode: focusNode,
    forceErrorState: forceErrorState,
    controller: controller,
    defaultPinTheme: pinTheme ?? defaultPinTheme,
    focusedPinTheme: (pinTheme ?? defaultPinTheme).copyWith(
      decoration: followingFieldDecoration,
    ),
    errorPinTheme: errorTheme ?? errorPinTheme,
    showCursor: false,
  );
}

Widget buildBottomTop() {
  return Container(
    decoration: BoxDecoration(
        color: AppColors.color3C434D,
        borderRadius: BorderRadius.circular(100)),
    height: 5,
    width: 36,
  );
}

Widget cBottomButton(String text,
    {VoidCallback? onTap,
      bool isEnable = true,
      double? width,
      Color? textColor,
      BoxDecoration? decoration,
      double? radius,
      Color? color,
      bool isExpend = true}) {
  var btn = cRippleButton(text, onTap: onTap, isEnable: isEnable)
      .intoPadding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80))
      .intoColumn(mainAxisAlignment: MainAxisAlignment.end);
  if (!isExpend) {
    return btn;
  }
  return btn.intoExpend();
}

PreferredSizeWidget appBar(BuildContext context, String title,
    {List<Widget>? actions,
      Widget? leadingWidget,
      bool? overlay = true,
      VoidCallback? onPressed,
      PreferredSizeWidget? bottom,
      bool? hasLeading = true,
      Color? backBtnColor,
      Color? titleColor,
      Color? backgroundColor}) {
  return AppBar(
    backgroundColor: backgroundColor,
    centerTitle: true,
    actions: actions,
    bottom: bottom,
    automaticallyImplyLeading: hasLeading == true,
    // systemOverlayStyle:
    // overlay == null || overlay == true ? getSystemOverlay : null,
    leading: hasLeading == true
        ? IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: backBtnColor ?? AppColors.color151515, size: 17.0),
        onPressed: () => {
          if (onPressed == null)
            {
              Navigator.of(context).pop(),
            }
          else
            {
              onPressed.call(),
            }
        })
        : null,
    title: cText(title,
        color: titleColor ?? AppColors.color151515,
        fontSize: 20.0,
        fontWeight: FontWeight.w600),
  );
}

Widget btnWithLoading2(
    {required String? title,
      bool isEnable = true,
      bool? isLoading = false,
      bool isLoadingWithTitle = false,
      VoidCallback? onTap,
      Color? backgroundColor,
      Widget? leading,
      Color? disableBackGroundColor = AppColors.colorD1D3D9,
      Color? disableTitleColor,
      double circular = 50.0,
      Color? fontColor,
      bool? debounce = false,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding,
      bool? isBorder}) {
  return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 25,vertical: 8),
      decoration: isBorder == true
          ? BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.colorE70013),
          borderRadius: BorderRadius.circular(circular))
          : normalDecoration(
          circular: circular,
          color: isEnable
              ? (backgroundColor ?? AppColors.colorE70013)
              : disableBackGroundColor),
      margin: margin ?? EdgeInsets.symmetric(horizontal: 30.0.px),
      child: debounce == true
          ? DebounceWidget(
          child: InkWell(
              onTap: () {
                if (onTap != null &&
                    isLoading == false &&
                    isEnable == true) {
                  onTap();
                }
              },
              borderRadius: BorderRadius.circular(circular),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading!
                        ? isLoadingWithTitle
                        ? Row(
                      children: [
                        if (leading != null) leading,
                        cText(title ?? '',
                            fontSize: 17.0,
                            color: isBorder == true
                                ? AppColors.colorE70013
                                : (fontColor ?? Colors.white),
                            fontWeight: FontWeight.w500),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              isBorder == true
                                  ? AppColors.colorE70013
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          isBorder == true
                              ? AppColors.colorE70013
                              : Colors.white,
                        ),
                      ),
                    ).intoContainer(width: 20, height: 20)
                        : Row(
                      children: [
                        if (leading != null) leading,
                        cText(title ?? '',
                            fontSize: 17.0,
                            color: isBorder == true
                                ? AppColors.colorE70013
                                : (fontColor ?? Colors.white),
                            fontWeight: FontWeight.w500)
                      ],
                    )
                  ])))
          : InkWell(
          onTap: () {
            if (onTap != null && isLoading == false && isEnable == true) {
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(circular),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            isLoading!
                ? isLoadingWithTitle
                ? Row(
              children: [
                if (leading != null) leading,
                cText(title ?? '',
                    fontSize: 17.0,
                    color: isBorder == true
                        ? AppColors.colorE70013
                        : (fontColor ?? Colors.white),
                    fontWeight: FontWeight.w500),
                SizedBox(width: 20),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      isBorder == true
                          ? AppColors.colorE70013
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            )
                : Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  isBorder == true
                      ? AppColors.colorE70013
                      : Colors.white,
                ),
              ),
            ).intoContainer(width: 20, height: 20)
                : Row(
              children: [
                if (leading != null) leading,
                cText(title ?? '',
                    fontSize: 17.0,
                    color: isBorder == true
                        ? AppColors.colorE70013
                        : (fontColor ?? Colors.white),
                    fontWeight: FontWeight.w500)
              ],
            )
          ])));
}


Widget buildBottomDefaultContainer(
    {Widget? child, double? height = 500, Color? color}) {
  return Container(
    height: height,
    color: Colors.transparent,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18.5),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      child: child,
    ),
  );
}
