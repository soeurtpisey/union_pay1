// 图片气泡

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';

class ChatImageBubble extends StatelessWidget {
  ChatImageBubble(
    this.message, [
    this.isSend = false,
  ]);

  final WeMessage message;
  final bool isSend;

  /// 最大长度
  final double maxSize = 160;

  @override
  Widget build(BuildContext context) {
    Widget image = Container();

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

    if (imgFile != null) {
      if (imgFile.locPath?.isNotEmpty == true) {
        File localPath = File(imgFile.locPath!);
        image = Image.file(
          localPath,
          fit: BoxFit.contain,
          width: width.toDouble(),
          height: height.toDouble(),
        );
      } else if (imgFile.url != null) {
        image = FadeInImage.assetNetwork(
          placeholder: 'images/chat_bubble_img_broken.png',
          image: imgFile.url!,
          width: width.toDouble(),
          height: height.toDouble(),
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset('images/chat_bubble_img_broken.png');
          },
        );
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxSize,
        maxWidth: maxSize,
      ),
      child: image,
    );
  }
}
