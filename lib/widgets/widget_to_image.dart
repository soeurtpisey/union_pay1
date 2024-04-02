library widget_to_image;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

import '../utils/get_now_date_format.dart';

/// create by zwb
/// ide : AndroidStudio
/// date: 2020-12-04 14:40
/// desc: 组件转图片-可带水印, 返回3种类型  1.File文件 2.Uint8List流 3.Base64编码
/// 使用此组件的 getFile() 时 需要赋予 文件读写权限 否则无法读写
class WidgetToImage extends StatefulWidget {
  // 自定义水印
  final Widget? waterText;

  //  一般是图片
  final Widget? child;

  // 水印的位置 - child不为空时失效 默认右下角
  final Alignment? alignment;

  // 图片路径 - child不为空时失效 默认为空
  final String? imagePath;

  // 水印文本 - waterText不为空时失效
  final String? imageStr;

  // 水印文本颜色 - waterText不为空时失效 默认红色
  final Color? stringColor;

  // 水印文本大小 - waterText不为空时失效 默认14
  final double? stringSize;

  // 组件的key
  final GlobalKey? globalKeys;

  //  图片背景色 - 默认白色
  final Color? bgColor;

  final BoxFit? boxFit;
  WidgetToImage(
      {this.boxFit,
      this.alignment = Alignment.bottomRight,
      this.waterText,
      this.child,
      this.imagePath,
      this.globalKeys,
      this.imageStr,
      this.stringColor,
      this.stringSize,
      this.bgColor});

  @override
  _WidgetToImageState createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.globalKeys,
      child: Container(
        color: widget.bgColor ?? Colors.white,
        child: Stack(
          alignment: widget.alignment ?? Alignment.bottomRight,
          children: <Widget>[
            widget.child ?? imageWidget(widget.imagePath),
            widget.waterText ??
                Text(
                  widget.imageStr ?? "",
                  style: TextStyle(
                      fontSize: widget.stringSize ?? 14,
                      color: widget.stringColor ?? Colors.red),
                ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(String? imagePath) {
    /// todo: 判断地址是否为网络图片
    if (imagePath?.startsWith('http://') == true ||
        imagePath?.startsWith('https://') == true) {
      return Image.network(
        imagePath ?? '',
        fit: widget.boxFit ?? BoxFit.cover,
      );

      /// todo: 判断地址是否为本机图片
    } else if (imagePath?.startsWith('file:') == true) {
      return Image.file(
        File(imagePath ?? ''),
        fit: widget.boxFit ?? BoxFit.cover,
      );
    } else {
      return Image.asset(
        imagePath ?? '',
        fit: widget.boxFit ?? BoxFit.cover,
      );
    }
  }
}

// 单例 用于获取图片
class getWidgetToImage {
  static GlobalKey? _globalKeys;
  static getWidgetToImage? _etWidgetToImage;
  // 存放图片的路径
  final String _path = '/widgetToImgDirectory/';
  static getWidgetToImage? getInstance(globalKey) {
    _etWidgetToImage ??= getWidgetToImage();
    _globalKeys = globalKey;
    return _etWidgetToImage;
  }

  // 获取路径
  Future<String> _getPath() async {
    var directory = await getTemporaryDirectory();
    var _filePath = '${directory.path}$_path';
    // 路径不存在则创建
    if (!await Directory(_filePath).exists()) {
      await Directory(_filePath).create();
    }
    return _filePath;
  }

  // 获取unit8
  Future<Uint8List?> getUint8List() async {
    var renderObject = _globalKeys?.currentContext?.findRenderObject();
    ui.Image? image;
    if (renderObject is RenderRepaintBoundary) {
      image = await renderObject.toImage(
        pixelRatio: window.devicePixelRatio,
      );
    }
    var byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  // 返回 文件
  Future<File?> getFile() async {
    var _filePath = await _getPath();
    var uint8List = await getUint8List();
    if (uint8List != null) {
      var filePath = '$_filePath${GetNowDateAndFormatFileName()}.png';
      return File(filePath).writeAsBytes(uint8List);
    } else {
      return null;
    }
  }

  Future<File?> corpFile() async {
    var _filePath = await _getPath();
    var uint8List = await getUint8List();
    if (uint8List != null) {
      var filePath = '$_filePath${GetNowDateAndFormatFileName()}.png';
      final decodedImage = imglib.decodeImage(uint8List);

      final face = imglib.copyCrop(
        decodedImage!,
        0,
        200,
        decodedImage.width,
        600,
      );
      return File(filePath)
          .writeAsBytes(Uint8List.fromList(imglib.encodePng(face)));
    } else {
      return null;
    }
  }

  // 返回Base64流
  Future<String?> getByte64() async {
    var body = await getUint8List();
    if (body != null) {
      return base64Encode(body);
    } else {
      return null;
    }
  }
}
