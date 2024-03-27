import 'dio_new.dart';

class ApiResponse {
  final String? status;
  final String? message;
  final dynamic data;

  ApiResponse({this.status, this.data, this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      data: json['data'],
      message: json['message'],
    );
  }

  bool get isSuccess => status == '200';

  bool get isError => !isSuccess;
}

class HttpResponse {
  late bool ok;
  dynamic data;
  HttpException? error;

  HttpResponse.success(this.data) {
    ok = true;
  }

  HttpResponse.failure({String? errorMsg, String? errorCode}) {
    error = BadRequestException(message: errorMsg, code: errorCode);
    ok = false;
  }

  HttpResponse.failureFormResponse({dynamic data}) {
    error = BadResponseException(data);
    ok = false;
  }

  HttpResponse.failureFromError([HttpException? error]) {
    this.error = error ?? UnknownException();
    ok = false;
  }
}
