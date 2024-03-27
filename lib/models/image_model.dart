import 'package:photo_manager/photo_manager.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';

import '../utils/image_util.dart';

class ImgModel {
  int? height;
  int? width;
  String? id; //图片的时候id    视频的时候 视频id
  String? url; //图片的时候全路径 视频的全路径
  String? cover; //视频的时候第一帧
  int? type; //-2 image  -4:video
  bool? isAdd;
  String? locPath;
  AssetEntity? assetEntity;
  ImgModel(
      {this.height,
        this.width,
        this.url,
        this.type,
        this.cover,
        this.isAdd,
        this.assetEntity,
        this.locPath});

  ImgModel.withUrl(this.url, {this.type = -2});

  bool isVideo() {
    return type == WeMessageType.MSG_VIDEO.value;
  }

  bool isImage() {
    return type == WeMessageType.MSG_IMAGE.value;
  }

  ImgModel.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
    id = json['id'];
    url = json['url'];
    type = json['type'];
    cover = json['cover'];
    locPath = json['locPath'];
  }

  List<double> getImageLayout() {
    return ImageUtil.getImageLayoutParams(
        width?.toDouble() ?? 0.0, height?.toDouble() ?? 00.0);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['height'] = height;
    data['width'] = width;
    data['id'] = id;
    data['url'] = url;
    data['type'] = type;
    data['cover'] = cover;
    data['locPath'] = locPath;
    return data;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + url.hashCode;
    result = 37 * result + type.hashCode;
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (other is! ImgModel) return false;
    ImgModel model = other;
    if (model.url?.isNotEmpty == true && url?.isNotEmpty == true) {
      return model.url == url && model.type == type;
    } else {
      return model.locPath?.isNotEmpty == true &&
          model.locPath == locPath &&
          model.type == type;
    }
  }

  bool isWebImage() {
    return url?.startsWith('http') == true;
  }
}