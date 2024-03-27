import 'dart:convert';

class WeFileMsgInfo {
  int fileId = 0;
  int msgKeyId = 0; //消息表的主键
  String? url; // 文件url
  String? locPath; // 本地路径
  String? name; // 文件名称
  String? type; // MIME类型
  int size = 0; // 单位：b
  Map<String, dynamic>? fileInfo; //文件的扩展信息json 图片视频的width、height，音视频的duration等

  WeFileMsgInfo(
      {this.fileId = 0,
      this.msgKeyId = 0,
      this.url,
      this.locPath,
      this.name,
      this.type,
      this.size = 0,
      this.fileInfo});

  factory WeFileMsgInfo.fromJson(Map<String, dynamic> jsonData) {
    return WeFileMsgInfo(
      fileId: jsonData['fileId'] == null ? null : jsonData['fileId'],
      msgKeyId: jsonData['msgKeyId'] == null ? null : jsonData['msgKeyId'],
      url: jsonData['url'] == null ? null : jsonData['url'],
      locPath: jsonData['locPath'] == null ? null : jsonData['locPath'],
      name: jsonData['name'] == null ? null : jsonData['name'],
      type: jsonData['type'] == null ? null : jsonData['type'],
      size: jsonData['size'] == null ? null : jsonData['size'],
      fileInfo: jsonData['fileInfo'] == null
          ? null
          : json.decode(jsonData['fileInfo']),
    );
  }

  Map<String, dynamic> toJson() => {
        'fileId': fileId,
        'msgKeyId': msgKeyId,
        'url': url,
        'locPath': locPath,
        'name': name,
        'type': type,
        'size': size,
        'fileInfo': fileInfo == null ? null : json.encode(fileInfo),
      };
}

class MetaDataModel {
  String? name;
  String? format;
  int? height;
  int? width;
  int? size;

  MetaDataModel({
    this.name,
    this.format,
    this.height,
    this.width,
    this.size,
  });

  MetaDataModel.fromJson(Map<String, dynamic> json) {
    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['format'] != null) {
      format = json['format'];
    }

    if (json['height'] != null) {
      if (json['height'] is double) {
        height = double.parse(json['height'].toString()).toInt();
      } else {
        height = json['height'];
      }
    }

    if (json['width'] != null) {
      if (json['width'] is double) {
        width = double.parse(json['width'].toString()).toInt();
      } else {
        width = json['width'];
      }
    }
    if (json['size'] != null) {
      size = json['size'];
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['name'] = name;
    data['format'] = format;
    data['height'] = height;
    data['width'] = width;
    data['size'] = size;
    return data;
  }
}
