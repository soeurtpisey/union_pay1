import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:synchronized/synchronized.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';

class MinioUtil {
  static Minio? _minio;
  static MinioUtil? _singleton;
  static Lock _lock = Lock();

  static MinioUtil getInstance() {
    if (_singleton == null) {
      _lock.synchronized(() {
        if (_singleton == null) {
          _singleton = MinioUtil._();
        }
      });
    }
    return _singleton!;
  }

  MinioUtil._() {
    _minio = Minio(
      endPoint: Constant.endpoint,
      accessKey: Constant.accountKey,
      secretKey: Constant.accountSecret,
      useSSL: true,
    );
  }

  Future<String> uploadMsgFile(
      String clientId, String fileName, String path) async {
    return _uploadFile(Constant.BUCKET_NAME_IM, clientId, fileName, path);
  }

  Future<String> uploadUserFile(
      String clientId, String fileName, String path) async {
    return _uploadFile(Constant.BUCKET_NAME_FOREVER, clientId, fileName, path);
  }

  Future<String> _uploadFile(
      String bucket, String clientId, String fileName, String path) async {
    Log.d("start uploadFile bucket:$bucket clientId:$clientId fileName:$fileName path:$path");
    if (!await _minio!.bucketExists(bucket)) {
      await _minio!.makeBucket(bucket);
    }

    String object = "$clientId/$fileName";
    final etag = await _minio!.fPutObject(bucket, object, path);
    Log.d("uploadFile success etag:$etag");

    //默认7天
    final url = await _minio!.presignedGetObject(bucket, object);
    Log.d("presigned url:$url");
    return url;
  }
}
