import 'dart:io';
import 'dart:math';

import 'package:flutter_native_image/flutter_native_image.dart';


class LubanUtil {
  static Future<String> luban(File imageFile, int width, int height) async {
    double size;
    var isLandscape = false;
    var length = imageFile.lengthSync();
    var path = imageFile.path;
    var fixelW = width;
    var fixelH = height;
    var thumbW = (fixelW % 2 == 1 ? fixelW + 1 : fixelW).toDouble();
    var thumbH = (fixelH % 2 == 1 ? fixelH + 1 : fixelH).toDouble();
    var scale = 0.0;
    if (fixelW > fixelH) {
      scale = fixelH / fixelW;
      var tempFixelH = fixelW;
      var tempFixelW = fixelH;
      fixelH = tempFixelH;
      fixelW = tempFixelW;
      isLandscape = true;
    } else {
      scale = fixelW / fixelH;
    }
    var imageSize = length / 1024;
    if (scale <= 1 && scale > 0.5625) {
      if (fixelH < 1664) {
        if (imageSize < 150) {
          var compressedFile = await FlutterNativeImage.compressImage(path);
          return compressedFile.path;
        }
        size = (fixelW * fixelH) / pow(1664, 2) * 150;
        size = size < 60 ? 60 : size;
      } else if (fixelH >= 1664 && fixelH < 4990) {
        thumbW = fixelW / 2;
        thumbH = fixelH / 2;
        size = (thumbH * thumbW) / pow(2495, 2) * 300;
        size = size < 60 ? 60 : size;
      } else if (fixelH >= 4990 && fixelH < 10240) {
        thumbW = fixelW / 4;
        thumbH = fixelH / 4;
        size = (thumbW * thumbH) / pow(2560, 2) * 300;
        size = size < 100 ? 100 : size;
      } else {
        var multiple = fixelH / 1280 == 0 ? 1 : fixelH ~/ 1280;
        thumbW = fixelW / multiple;
        thumbH = fixelH / multiple;
        size = (thumbW * thumbH) / pow(2560, 2) * 300;
        size = size < 100 ? 100 : size;
      }
    } else if (scale <= 0.5625 && scale >= 0.5) {
      if (fixelH < 1280 && imageSize < 200) {
        var compressedFile = await FlutterNativeImage.compressImage(path);
        return compressedFile.path;
      }
      var multiple = fixelH / 1280 == 0 ? 1 : fixelH ~/ 1280;
      thumbW = fixelW / multiple;
      thumbH = fixelH / multiple;
      size = (thumbW * thumbH) / (1440.0 * 2560.0) * 200;
      size = size < 100 ? 100 : size;
    } else {
      var multiple = (fixelH / (1280.0 / scale)).ceil();
      thumbW = fixelW / multiple;
      thumbH = fixelH / multiple;
      size = ((thumbW * thumbH) / (1280.0 * (1280 / scale))) * 500;
      size = size < 100 ? 100 : size;
    }
    if (imageSize < size) {
      var compressedFile = await FlutterNativeImage.compressImage(path);
      return compressedFile.path;
    }
    if (isLandscape) {
      var compressedFile = await FlutterNativeImage.compressImage(path,
          targetWidth: thumbH.toInt(),
          targetHeight: (thumbH * (height / width)).toInt());
      return compressedFile.path;
    } else {
      var compressedFile = await FlutterNativeImage.compressImage(path,
          targetWidth: thumbW.toInt(),
          targetHeight: (thumbW * (height / width)).toInt());
      return compressedFile.path;
    }
  }
}
