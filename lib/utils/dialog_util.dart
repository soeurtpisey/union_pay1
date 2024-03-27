import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/double_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../generated/l10n.dart';
import '../helper/colors.dart';
import '../widgets/button/flat_button.dart';
import '../widgets/common.dart';
import '../widgets/simple_dialog.dart';
import 'custom_decoration.dart';

typedef DialogConfirm = Function(BuildContext context, dynamic value);

class MultiItem {
  MultiItem(this.text, this.onTap);

  final String text;
  VoidCallback? onTap;
}

class DialogUtil {
  static Future showBottomDateDialog(BuildContext context, Widget child,
      {bool isScrollControlled = true,
      bool enableDrag = false,
      bool isDismissible = false}) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: isScrollControlled,
        enableDrag: enableDrag,
        backgroundColor: Colors.transparent,
        //设置不能拖拽关闭
        isDismissible: isDismissible,
        //设置不能点击消失
        builder: (context) {
          return child;
        });
  }

  static Future showBottomFullDialog(BuildContext context, Widget child,
      {bool isScrollControlled = true,
      Color backgroundColor = Colors.white,
      RoundedRectangleBorder? shape,
      bool enableDrag = false,
      bool isDismissible = false}) async {
    return showModalBottomSheet(
        context: context,
        backgroundColor: backgroundColor,
        shape: shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        isScrollControlled: isScrollControlled,
        enableDrag: enableDrag,
        //设置不能拖拽关闭
        isDismissible: isDismissible,
        //设置不能点击消失
        builder: (context) {
          return child;
        });
  }

  static Future showMultiBaseDialog(
      BuildContext context, List<MultiItem> list) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (context, StateSetter setState) {
                return SingleChildScrollView(
                  child: ListBody(
                    children: list
                        .map((e) => InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                e.onTap?.call();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: cText(e.text,
                                    fontSize: 18,
                                    textAlign: TextAlign.start,
                                    color: Colors.black87),
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          );
        });
  }

  static Future showTextDialog(
      widgetContext, String title, VoidCallback onTap,
      {bool barrierDismissible = true, bool isCancel = true,String? leftText,String? rightText}) {
    return showDialog(
      context: widgetContext,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return SimpleTextDialog(title,onTap,barrierDismissible:barrierDismissible,isCancel:isCancel,leftText:leftText,rightText:rightText);
      },
    );
  }

  static Future showSimpleDialog(
      widgetContext, String title, VoidCallback onTap,
      {bool barrierDismissible = true, bool isCancel = true, Widget? content}) {
    return showDialog(
      context: widgetContext,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            if (isCancel)
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S().cancel),
              ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                onTap();
              },
              child: Text(
                S.of(context).confirm,
                style: const TextStyle(color: AppColors.color3478F5),
              ),
            ),
          ],
        );
      },
    );
  }

  //单纯弹窗
  static Future showSimpleDialog2(widgetContext, Widget child,
      {ShapeBorder? shape, Color? color}) {
    return showDialog(
      context: widgetContext,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: color,
          shape: shape,
          child: child,
        );
      },
    );
  }

  static Future showBottomTitleDialog(BuildContext context,
      {VoidCallback? onConfirm,
      required Widget child,
      String? title,
      bool isScrollControlled = true}) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: isScrollControlled,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  cText(title ?? '',
                          textAlign: TextAlign.left,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppColors.color151736)
                      .intoExpend(),
                  cText(S.current.cancel,
                          color: AppColors.color8D8E9A)
                      .onClick(() {
                    Navigator.pop(context);
                  })
                ],
              ),
              child,
              cText(S.current.confirm, color: Colors.white, fontSize: 16)
                  .intoContainer(
                alignment: Alignment.center,
                width: double.infinity,
                height: 40.0.px,
                decoration: btnDecoration(),
              )
                  .onClick(() {
                Navigator.pop(context);
                if (onConfirm != null) onConfirm();
              })
            ],
          ).intoContainer(
              decoration: bottomDialogDecoration(),
              padding:
                  EdgeInsets.symmetric(horizontal: 15.0.px, vertical: 20.0.px));
        });
  }

  static Future showBottomDialog(BuildContext context,
      {VoidCallback? onConfirm,
      required Widget child,
      String? title,
      Color? color,
      bool isScrollControlled = true}) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: isScrollControlled,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  cText(title ?? '',
                          textAlign: TextAlign.left,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppColors.color151736)
                      .intoExpend(),
                ],
              ).intoContainer(padding: const EdgeInsets.only(left: 15, top: 15)),
              child,
              cText(S.current.cancel,
                      color: AppColors.color151736, fontSize: 16)
                  .intoContainer(
                alignment: Alignment.center,
                width: double.infinity,
                height: 60.0,
                decoration: btnDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0)),
              )
                  .onClick(() {
                Navigator.pop(context);
                // if (onConfirm != null) onConfirm();
              })
            ],
          ).intoContainer(
            decoration: bottomDialogDecoration(color: AppColors.colorF5F5F5),
          );
        });
  }

  static Future<void> showConfirmDialog(BuildContext context,
      {String? title,
      String? message,
      Function? action,
      String okButtonTitle = 'ok',
      String cancelButtonTitle = ''}) async {
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title ?? ''),
            content: Text(message ?? ''),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                    cancelButtonTitle.isEmpty ? 'cancel' : cancelButtonTitle,
                    style: const TextStyle(color: Colors.black, fontSize: 16)),
              ),
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    action!();
                  },
                  textStyle: const TextStyle(color: Colors.blue, fontSize: 16),
                  child: Text(okButtonTitle)),
            ],
          );
        },
      );
    } else if (Platform.isAndroid) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title == null ? null : Text(title),
            content: message == null ? null : Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  cancelButtonTitle.isEmpty ? 'cancel' : cancelButtonTitle,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  action!();
                },
                child: Text(
                  okButtonTitle,
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
