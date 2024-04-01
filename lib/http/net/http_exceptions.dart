class HttpException implements Exception {
  final String? _message;

  String get message => _message ?? this.runtimeType.toString();

  final String? _status;

  String get status => _status ?? 'error';

  HttpException([this._message, this._status]);

  String toString() {
    return "{msg=$message,status=$status}";
  }
}

/// 客户端请求错误
class BadRequestException extends HttpException {
  BadRequestException({String? message, String? status}) : super(message, status);
}

/// 服务端响应错误
class BadServiceException extends HttpException {
  BadServiceException({String? message, String? status}) : super(message, status);
}

class UnknownException extends HttpException {
  UnknownException([String? message, String? status]) : super(message, status);
}

class CancelException extends HttpException {
  CancelException([String? message]) : super(message);
}

class NetworkException extends HttpException {
  NetworkException({String? message, String? status}) : super(message, status);
}

class UnauthorisedException extends HttpException {
  UnauthorisedException({String? message, String? status = '401'})
      : super(message,status);
}

class BadResponseException extends HttpException {
  dynamic data;

  BadResponseException([this.data]) : super();
}
