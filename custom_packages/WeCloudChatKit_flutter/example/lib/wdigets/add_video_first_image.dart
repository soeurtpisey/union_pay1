import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';

class AddVideoFirstImage extends StatefulWidget {
  final WeFileMsgInfo? fileMsgInfo;
  final double width;
  final double height;

  const AddVideoFirstImage(
      {Key? key, required this.fileMsgInfo, this.width = 0, this.height = 0})
      : super(key: key);

  @override
  _AddVideoFirstImageState createState() => _AddVideoFirstImageState();
}

class _AddVideoFirstImageState extends State<AddVideoFirstImage> {
  //视频 缩略图
  VideoPlayerController? _controller;
  Future? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    String? locPath = widget.fileMsgInfo?.locPath;
    String? url = widget.fileMsgInfo?.url;
    if (locPath?.isNotEmpty == true) {
      File localPath = File(locPath!);
      _controller = VideoPlayerController.file(localPath);
    } else if (url != null) {
      _controller = VideoPlayerController.network(url);
    }
    //视频缩略图
    _controller?.setLooping(true);
    _initializeVideoPlayerFuture = _controller?.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(0),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: FutureBuilder(
              //显示缩略图
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                Log.e("connectionState: ${snapshot.connectionState}");
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.connectionState == ConnectionState.done) {
                  Log.e("aspectRatio: ${_controller?.value.aspectRatio}");
                  return AspectRatio(
                    aspectRatio: _controller?.value.aspectRatio ?? 2 / 3,
                    child: _controller == null
                        ? Container()
                        : VideoPlayer(_controller!),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        Center(
            child: InkWell(
          onTap: () {
            //TODO   点击播放视频
          },
          child: Image.asset(
            "images/ic_video_play.png",
            width: 20,
            height: 20,
          ),
        ))
      ],
    );
  }
}
