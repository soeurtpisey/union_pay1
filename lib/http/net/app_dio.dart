import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter_browser.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dio_new.dart';

/// Noted: Web not support to set PROXY
class AppDio with DioMixin implements Dio {

  AppDio({BaseOptions? options, HttpConfig? dioConfig}) {
    options ??= BaseOptions(
      baseUrl: dioConfig?.baseUrl ?? "",
      contentType: 'application/json',
      connectTimeout: dioConfig?.connectTimeout,
      sendTimeout: dioConfig?.sendTimeout,
      receiveTimeout: dioConfig?.receiveTimeout,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
      }
    );
    this.options = options;

    // DioCacheManager
    final cacheOptions = CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(),
      // Optional. Returns a cached response on error but for statuses 401 & 403.
      hitCacheOnErrorExcept: [401, 403],
      // Optional. Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
    );
    interceptors.add(DioCacheInterceptor(options: cacheOptions));
    // Cookie管理
    if (dioConfig?.cookiesPath?.isNotEmpty ?? false) {
      interceptors.add(CookieManager(
          PersistCookieJar(storage: FileStorage(dioConfig!.cookiesPath))));
    }

    // debug下开启日志 有代理就关闭日志
    if (kDebugMode && (dioConfig?.proxy?.isEmpty ?? true)) {
      interceptors.add((PrettyDioLogger(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90)));
    }
    if (dioConfig?.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(dioConfig?.interceptors ?? []);
    }
    httpClientAdapter = BrowserHttpClientAdapter();

  }

}
