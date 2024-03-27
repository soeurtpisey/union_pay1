import 'dart:io' hide HttpClient;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:union_pay/http/api.dart';
import 'package:union_pay/http/net/http_config.dart';
import '../../helper/hive/hive_helper.dart';
import '../../http/net/http_client.dart';
import '../base/app.dart';

class DioClientController extends GetxService {
  HttpClient init() {
    var dioConfig = getDioConfig();
    HttpClient client = HttpClient(dioConfig: dioConfig);
    var token = HiveHelper.getToken();
    if (token != null) {
      client.setToken(token);
    }
    return client;
  }

  HttpConfig getDioConfig() {
    HttpConfig dioConfig = HttpConfig(
      baseUrl: Api.baseUrl,
      interceptors: [
        QueuedInterceptorsWrapper(onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          return handler.next(options);
        }, onError: (error, handler) async {

          if (error.response?.statusCode != 200) {
            var data = error.response?.data;
            if (data != null && data is Map) {
              if (data['messageCode'] != null && (data['messageCode'] == '4001'||data['messageCode'] == '4006') ||
                  data['messageCode'] == '401' &&
                      data['message'] != null &&
                      data['message'] == 'Device session expired') {
                App.autoLogout();
              }
            }
          }
          return handler.next(error);
        }),
      ],
    );
    return dioConfig;
  }
}
