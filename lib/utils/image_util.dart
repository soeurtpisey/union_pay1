import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as dImage;

import '../models/image_model.dart';

// import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:ym_image_picker/ym_image_picker.dart';

class ImageUtil {
  ImageStreamListener? _listener;
  ImageStream? _imageStream;

  /// get image width height，load error throw exception.（unit px）
  /// 获取图片宽高，加载错误会抛出异常.（单位 px）
  /// image
  /// url network
  /// local url , package
  Future<Rect> getImageWH({
    Image? image,
    String? url,
    String? localUrl,
    String? package,
    ImageConfiguration? configuration,
  }) {
    Completer<Rect> completer = Completer<Rect>();
    _listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        _imageStream?.removeListener(_listener!);
        if (!completer.isCompleted) {
          completer.complete(Rect.fromLTWH(
              0, 0, info.image.width.toDouble(), info.image.height.toDouble()));
        }
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        _imageStream?.removeListener(_listener!);
        if (!completer.isCompleted) {
          completer.completeError(exception, stackTrace);
        }
      },
    );

    if (image == null &&
        (url == null || url.isEmpty) &&
        (localUrl == null || localUrl.isEmpty)) {
      return Future.value(Rect.zero);
    }
    var img = image ??
        ((url != null && url.isNotEmpty)
            ? Image.network(url)
            : Image.asset(localUrl!, package: package));
    _imageStream = img.image.resolve(configuration ?? ImageConfiguration());
    _imageStream?.addListener(_listener!);
    return completer.future;
  }

  static Future<String?> onImageButtonDialog(
      ImagePicker picker, ImageSource source,
      {BuildContext? context}) async {
    try {
      // final pickedFile =
      //     await picker.getImage(source: source, imageQuality: 100);
      final pickedFile = await picker.pickImage(source: source, imageQuality: 100);
      // final pickedFile =await picker.getVideo(source: ImageSource.gallery);
      // print(pickedFile.path);
      return pickedFile?.path;
    } catch (e) {
      print(e.toString());
    }
    return '';
  }

  static Future<File?> imageToPng(File? file) async {
    var path = file?.path ?? '';
    var contains = path.contains('.png');
    if (contains) {
      return file;
    }
    var tempPath = (await getTemporaryDirectory()).path;
    var temp = await file?.readAsBytes();
    var list = List<int>.from(temp!);
    var image = dImage.decodeJpg(list);
    if (image == null) {
      return null;
    }
    var newFile = File('$tempPath/temp.png');
    await newFile.writeAsBytes(dImage.encodePng(image));
    return newFile;
  }

  static Future<File?> resizeImage(File? file, int width, int height) async {
    var tempPath = (await getTemporaryDirectory()).path;
    var temp = await file?.readAsBytes();
    var image = dImage.decodeImage(temp!);
    var resize = dImage.copyResize(image!, width: width, height: height);

    var newFile = File('$tempPath/temp.png');
    newFile = await newFile.writeAsBytes(dImage.encodePng(resize));
    return newFile;
  }

  static Future<File?> rotateImage(File? file) async {
    var tempPath = (await getTemporaryDirectory()).path;
    var temp = await file?.readAsBytes();
    var list = List<int>.from(temp!);
    var image = dImage.decodeJpg(list);
    if (image == null) {
      return null;
    }
    var newFile = File('$tempPath/temp-${DateTime.now().toString()}.png');
    newFile = await newFile
        .writeAsBytes(dImage.encodeJpg(dImage.copyRotate(image, 90)));
    return newFile;
  }

  static Future<File?> imageDecodeFile(ui.Image? image) async {
    var tempPath = (await getTemporaryDirectory()).path;
    final data = await image?.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final bytes = data?.buffer.asUint64List();
    var newFile = File('$tempPath/temp-${DateTime.now().toString()}.png');
    newFile = await newFile.writeAsBytes(bytes!, flush: true);
    return newFile;
  }

  static Future<ui.Image?> decodePrinterImge(
      ui.Image? image, int width, int height) async {
    //Convert to raw rgba
    var bytes = await image?.toByteData(format: ui.ImageByteFormat.rawRgba);
    var completer = Completer<ui.Image>(); //完成的回调
    ui.decodeImageFromPixels(bytes!.buffer.asUint8List(), image?.width ?? 0,
        image?.height ?? 0, ui.PixelFormat.rgba8888, (result) {
      print(result.height);
      print(result.width);
      completer.complete(result);
    }, targetHeight: height, targetWidth: width);
    return completer.future;
  }

  static Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    var completer = Completer<ui.Image>(); //完成的回调
    ImageStreamListener? listener;
    var stream = provider.resolve(config); //获取图片流
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final image = frame.image;
      completer.complete(image); //完成
      if (listener != null) {
        stream.removeListener(listener); //移除监听
      }
    });
    stream.addListener(listener); //添加监听
    return completer.future; //返回
  }

  static double getWaterfallHeight(double height) {
    if (height > 300) {
      height = 300;
    } else if (height < 150) {
      height = 150;
    }
    return height;
  }

  static List<double> getImageLayoutParams(double width, double height) {
    var minWidth = 80;
    var maxWidth = 180;
    var minHeight = 80;
    var maxHeight = 180;
    if (width == 0.0 && height == 0.0) {
      return [minWidth.toDouble(), minHeight.toDouble()];
    }
    var measuredWidth = width;
    var measuredHeight = height;
    var widthInBounds = measuredWidth >= minWidth && measuredWidth <= maxWidth;
    var heightInBounds =
        measuredHeight >= minHeight && measuredHeight <= maxHeight;
    if (!widthInBounds || !heightInBounds) {
      var minWidthRatio = measuredWidth / minWidth;
      var maxWidthRatio = measuredWidth / maxWidth;
      var minHeightRatio = measuredHeight / minHeight;
      var maxHeightRatio = measuredHeight / maxHeight;
      if (maxWidthRatio > 1 || maxHeightRatio > 1) {
        if (maxWidthRatio >= maxHeightRatio) {
          measuredWidth /= maxWidthRatio;
          measuredHeight /= maxWidthRatio;
        } else {
          measuredWidth /= maxHeightRatio;
          measuredHeight /= maxHeightRatio;
        }

        measuredWidth = Math.max(measuredWidth, minWidth.toDouble());
        measuredHeight = Math.max(measuredHeight, minHeight.toDouble());
      } else if (minWidthRatio < 1 || minHeightRatio < 1) {
        if (minWidthRatio <= minHeightRatio) {
          measuredWidth /= minWidthRatio;
          measuredHeight /= minWidthRatio;
        } else {
          measuredWidth /= minHeightRatio;
          measuredHeight /= minHeightRatio;
        }

        measuredWidth = Math.min(measuredWidth, maxWidth.toDouble());
        measuredHeight = Math.min(measuredHeight, maxHeight.toDouble());
      }
    }
    return [measuredWidth, measuredHeight];
  }

  /// 绘制时需要用到 ui.Image 的对象，通过此方法进行转换
  static Future<ui.Image> getImage(String asset) async {
    var data = await rootBundle.load(asset);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    var fi = await codec.getNextFrame();
    return fi.image;
  }

  static ImageProvider getImageProvider(String path) {
    var image = Image.file(File(path));
    return image.image;
  }

  static Future<ImgModel> getImageModel(File file) {
    final completer = Completer<ImgModel>();

    var image = ImageUtil.getImageProvider(file.path);
    image
        .resolve(const ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) async {
          var width = info.image.width;
          var height = info.image.height;
          await image.evict();

          completer.complete(ImgModel(
              height: height, width: width, type: -2, locPath: file.path));
        })));
    return completer.future;
  }
}
