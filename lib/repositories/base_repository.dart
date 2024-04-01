
import 'package:get/get.dart';
import '../app/base/app.dart';
import '../app/config/app_config.dart';
import '../helper/hive/hive_helper.dart';
import '../http/net/http_client.dart';

class BaseRepository {
  final HttpClient _dio = Get.find<HttpClient>();

  Future<Map<String, dynamic>> getParam({Map<String, dynamic>? params}) async {
    if (params?.containsKey('refreshToken') != true || params == null) {
      await App.refreshToken();
    }
    final data = <String, dynamic>{};
    if (params != null) {
      params.forEach((key, value) {
        if (value != null) {
          data[key] = value;
        }
      });
    }
    return data;
  }

  Future<dynamic> appPost(String path,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      bool showLoading = false}) async {
    final param = await getParam(params: data);
    final response = await _dio.post('${Env.apiUrl}$path',
        data: param,
        queryParameters: queryParameters,
        showLoading: showLoading);
    return response;
  }

  Future<dynamic> appPut(String path,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      bool showLoading = false}) async {
    final param = await getParam(params: data);
    final response = await _dio.put('${Env.apiUrl}$path',
        data: param,
        queryParameters: queryParameters,
        showLoading: showLoading);
    return response;
  }

  Future<dynamic> appGet(String path,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      bool showLoading = false}) async {
    final params = await getParam(params: queryParameters);
    final response = await _dio.get('${Env.apiUrl}$path',
        queryParameters: params, showLoading: showLoading);
    return response;
  }

  Future<dynamic> appDelete(String path,
      {Map<String, dynamic>? data, bool showLoading = false}) async {
    final param = await getParam();
    final apiResponse = await _dio.delete('${Env.apiUrl}$path',
        data: param, showLoading: showLoading);
    return apiResponse;
  }

  Future<dynamic> appUpload(String path,
      {Map<String, dynamic>? data, bool showLoading = false}) async {
    final apiResponse = await _dio.upload('${Env.apiUrl}$path',
        params: data, showLoading: showLoading);
    return apiResponse;
  }

  void setToken(String token) {
    HiveHelper.setToken(token);
    _dio.setToken(token);
  }
}
