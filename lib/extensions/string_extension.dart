
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app/base/app.dart';
import '../helper/number_helper.dart';

extension StringExtension on String {
  String removeBlank() {
    return replaceAll('', '\u200B');
  }

  String icTranslate() {
    var need = contains('_zh') || contains('_en') || contains('_km');
    if (need) {
      var index = lastIndexOf('_');
      if (index != -1) {
        return '${substring(0, index + 1)}${App.language}${substring(index + 3, length)}';
      } else {
        return this;
      }
    } else {
      return this;
    }
  }

  String displayLimit(int limit){
    return length>limit?'${substring(0,limit)}...':this;
  }

  String formatCurrency() {
    return NumberHelper.formatCurrency(this);
  }

  String formatCcy() {
    if(this=='KHR'){
      return '៛';
    }else if(this=='USD') {
      return '\$';
    }else{
      return this;
    }
  }

  String formatBankCard() {
    return NumberHelper.formatBankCard(this);
  }

  String getPayCardStr() {
    var num = length - 3 - 3;
    var st = r'\d{' '$num' '}';
    return replaceFirst(RegExp(st), '****', 3);
  }

  bool isZero() {
    if (this == '0' || this == '0.0' || this == '0.00' || this == '0.') {
      return true;
    }
    return false;
  }

  Widget UIImage(
      {bool isShowBadge = false,
        Color? color,
        double? width,
        double? height,
        BoxFit? boxFit,
        ValueNotifier<int>? valueNotifier}) {
    Widget body;
    if (valueNotifier != null) {
      body = ValueListenableBuilder(
        builder: (BuildContext context, int value, Widget? child) {
          return Positioned(
              right: -5,
              top: -5,
              child: Offstage(
                offstage: value <= 0,
                child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(150),
                    )),
              ));
        },
        valueListenable: valueNotifier,
      );
    } else {
      body = Positioned(right: 0, top: 0, child: Container());
    }
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Image.asset(
          this, excludeFromSemantics: true,
          //去除图片语义
          gaplessPlayback: true,
          //重新加载图片的过程中，原图片的展示是否保留
          height: height,
          color: color,
          width: width,
          fit: boxFit,
        ),
        body
      ],
    );
  }

  bool checkPin() {
    var pin = this;
    var isSimple = false;
    var isShunZi = false;
    if (pin.length == 6) {
      if (pin[0] == pin[1] &&
          pin[0] == pin[2] &&
          pin[0] == pin[3] &&
          pin[0] == pin[4] &&
          pin[0] == pin[5]) {
        isSimple = true;
      }
      var isSame=int.parse(pin[0])==int.parse(pin[2])||int.parse(pin[1])==int.parse(pin[3]);
      if (((int.parse(pin[0]) - int.parse(pin[1])).abs()) == 1 &&
          (int.parse(pin[1]) - int.parse(pin[2])).abs() == 1 &&
          (int.parse(pin[2]) - int.parse(pin[3])).abs() == 1 &&
          (int.parse(pin[3]) - int.parse(pin[4])).abs() == 1 &&
          (int.parse(pin[4]) - int.parse(pin[5])).abs() == 1 && !isSame) {
        isShunZi = true;
      }
    } else if (pin.length == 4) {
      if (pin[0] == pin[1] &&
          pin[0] == pin[2] &&
          pin[0] == pin[3] ) {
        isSimple = true;
      }
      var isSame=int.parse(pin[0])==int.parse(pin[2])||int.parse(pin[1])==int.parse(pin[3]);
      if (((int.parse(pin[0]) - int.parse(pin[1])).abs()) == 1 &&
          (int.parse(pin[1]) - int.parse(pin[2])).abs() == 1 &&
          (int.parse(pin[2]) - int.parse(pin[3])).abs() == 1 && !isSame) {
        isShunZi = true;
      }
    }
    return !isSimple && !isShunZi;
  }

}
