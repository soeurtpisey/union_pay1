import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oktoast/oktoast.dart';
import '../../utils/log_util.dart';
import '../api.dart';
import 'dio_new.dart';
import 'dart:html';

/// Response 解析
abstract class HttpTransformer {
  HttpResponse parse(Response response);
}

class HttpClient {
  late AppDio _dio;

  HttpClient({BaseOptions? options, HttpConfig? dioConfig})
      : _dio = AppDio(options: options, dioConfig: dioConfig);

  Future get(String uri,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        HttpTransformer? httpTransformer,
        bool showLoading = false}) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      HttpResponse appResponse =
      handleResponse(response, httpTransformer: httpTransformer);
      if (appResponse.ok) {
        return appResponse;
      } else {
        throw HttpException(
            appResponse.error!.message, appResponse.error!.code);
      }
    } on Exception catch (e) {
      Log.e(e);
      throw handleException(e).error!;
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Future post(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        HttpTransformer? httpTransformer,
        bool showLoading = false}) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      HttpResponse appResponse =
      handleResponse(response, httpTransformer: httpTransformer);
      if (appResponse.ok) {
        return appResponse;
      } else {
        errorHandle(appResponse);
        throw HttpException(
            appResponse.error!.message, appResponse.error!.code);
      }
    } on HttpException catch (e) {
      throw handleException(e).error!;
    } on DioError catch (e) {
      Log.e(e);
      throw UnknownException(e.response?.data?["message"] ?? '', e.response?.data?["messageCode"] ?? '');
      // showToast("网络异常，请稍后再试");
      // throw handleException(e).error!;
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Future postFormData(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.post(
        uri,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      HttpResponse appResponse =
      handleResponse(response, httpTransformer: httpTransformer);
      if (appResponse.ok) {
        return appResponse.data;
      } else {
        throw HttpException(
            appResponse.error!.message, appResponse.error!.code);
      }
    } on Exception catch (e) {
      Log.e(e);
      throw handleException(e).error!;
    }
  }

  Future patch(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      HttpResponse appResponse =
      handleResponse(response, httpTransformer: httpTransformer);
      if (appResponse.ok) {
        return appResponse.data;
      } else {
        throw HttpException(
            appResponse.error!.message, appResponse.error!.code);
      }
    } on Exception catch (e) {
      Log.e(e);
      throw handleException(e).error!;
    }
  }

  Future delete(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        HttpTransformer? httpTransformer,
        bool showLoading = false}) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      HttpResponse appResponse =
      handleResponse(response, httpTransformer: httpTransformer);
      if (appResponse.ok) {
        return appResponse;
      } else {
        throw HttpException(
            appResponse.error!.message, appResponse.error!.code);
      }
    } on DioError catch (e) {
      throw handleException(e).error!;
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Future put(String uri,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        HttpTransformer? httpTransformer,
        bool showLoading = false}) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      HttpResponse appResponse =
      handleResponse(response, httpTransformer: httpTransformer);
      if (appResponse.ok) {
        return appResponse;
      } else {
        throw HttpException(
            appResponse.error!.message, appResponse.error!.code);
      }
    } on Exception catch (e) {
      Log.e(e);
      throw handleException(e).error!;
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Future upload(String path,
      {Map<String, dynamic>? params,
        HttpTransformer? httpTransformer,
        bool showLoading = false}) async {
    try {
      if (showLoading) {
        EasyLoading.show();
      }
      var response = await Dio().post(Api.baseFileUrl + path,
          data: params != null ? FormData.fromMap(params) : null,
          onSendProgress: (int count, int total) {
            print('-----------${count / total}-------------'); //上传进度
          });
      HttpResponse appResponse =
      handleResponse(response, httpTransformer: httpTransformer);
      if (appResponse.ok) {
        return appResponse;
      } else {
        throw HttpException(
            appResponse.error!.message, appResponse.error!.code);
      }
      // if (response.statusCode == HttpStatus.ok ||
      //     response.statusCode == HttpStatus.created) {
      //   if (response.data is Map) {
      //     var status = response.data['code'];
      //     var msg = response.data['msg'];
      //     var data = response.data['data'];
      //   } else {
      //     var dataMap = _decodeData(response);
      //     var status = dataMap['code'];
      //     var msg = dataMap['msg'];
      //     var data = dataMap['data'];
      //   }
      //   return data;
      // }
    } on Exception catch (e) {
      Log.e(e);
      throw handleException(e).error!;
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Map<String, dynamic> _decodeData(Response? response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return {};
    }
    return json.decode(response.data.toString());
  }

  Future download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        bool deleteOnError = true,
        String lengthHeader = Headers.contentLengthHeader,
        data,
        Options? options,
        HttpTransformer? httpTransformer}) async {
    try {
      var response = await Dio().download(urlPath, savePath,
          onReceiveProgress: (int loaded, int total) {
            if (onReceiveProgress != null) onReceiveProgress(loaded, total);
          });
      if (response.statusCode == 200) {
        return response.data;
      }
      throw HttpException('下载失败', '-1');
      return response;
    } catch (e) {
      throw e;
    }
  }

//   Future<BaseResp<T>> download<T>(String path, String savePath,
//       {Map<String, dynamic>? params, Function? callBack}) async {
//     int? _status;
//     int? _code;
//     String? _msg;
//     T? _data;
//     Response? response;
//     try {
//       response = await Dio().download(path, savePath,
//           onReceiveProgress: (int loaded, int total) {
//         callBack?.call(loaded, total);
//       });
//
//       if (response.statusCode == HttpStatus.ok ||
//           response.statusCode == HttpStatus.created) {
// //        if (response.data is Map) {
// //          _status = response.data[_statusKey];
// //          _msg = response.data["msg"];
// //          _data = response.data[_dataKey];
// //        } else {
//         _status = (response.data as ResponseBody).statusCode;
//         // }
//         return BaseResp(_status, _code, _msg, _data);
//       }
//     } on DioError catch (e) {
//       print(e);
//       return Future.error(createErrorEntity(e));
//     }
//     return BaseResp(HttpStatus.forbidden, HttpStatus.forbidden,
//         response.statusMessage ?? '', null);
//   }

  errorHandle(HttpResponse appResponse) {
    if (appResponse.error!.code == 401) {
      showToast(appResponse?.error?.message??'');
      // Application.clearUserModel();
      // NavigatorUtils.goLoginOriginPage();
      return;
    }
    if (appResponse.error!.code == 203) {
      /// 未设置支付密码
      // showToast(appResponse.error!.message);
      // Application.setPayPasswordAction();
      // NavigatorUtils.goLoginOriginPage();
      return;
    }

    throw HttpException(appResponse.error!.message, appResponse.error!.code);
  }

  void setToken(String token) {
    Map<String, dynamic> headers = {};
    if(token.isNotEmpty) {
      headers["Authorization"] = 'Bearer $token';
      // headers["token"] = token;
      _dio.options.headers.addAll(headers);
    }
  }
}
