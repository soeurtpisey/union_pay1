// 图片气泡

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/add_video_first_image.dart';

class ChatVideoBubble extends StatelessWidget {
  ChatVideoBubble(
    this.message, [
    this.isSend = false,
  ]);

  final WeMessage message;
  final bool isSend;

  /// 最大长度
  final double maxSize = 200;

  @override
  Widget build(BuildContext context) {
    WeFileMsgInfo? imgFile = message.file;
    Map<String, dynamic>? fileInfo = imgFile?.fileInfo;

    num width = fileInfo == null ? 1 : fileInfo["width"];
    num height = fileInfo == null ? 1 : fileInfo["height"];
    if (height > width) {
      width = maxSize / height * width;
      height = maxSize;
    } else {
      height = maxSize / width * height;
      width = maxSize;
    }
    Log.e("width:$width,height:$height,maxSize:$maxSize");
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxSize,
        maxWidth: maxSize,
      ),
      width: width.toDouble(),
      height: height.toDouble(),
      child: AddVideoFirstImage(
        fileMsgInfo: imgFile,
        width: width.toDouble(),
        height: height.toDouble(),
      ),
    );
  }
}
