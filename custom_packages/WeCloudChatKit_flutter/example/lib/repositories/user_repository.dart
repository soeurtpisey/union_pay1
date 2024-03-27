import 'package:get/get.dart';
import 'package:wecloudchatkit_flutter_example/http/net/dio_new.dart';

class UserRepository {
  final HttpClient _dio = Get.find<HttpClient>();

  final String _getSign = 'signDemo/get';

  getSign(String clientId, String appKey, String appSecret, String timestamp,
          int platform) async =>
      await _dio.post(_getSign, data: {
        'clientId': clientId,
        'appKey': appKey,
        'appSecret': appSecret,
        'timestamp': timestamp,
        'platform': platform
      });
}
