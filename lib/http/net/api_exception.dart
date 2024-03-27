
import 'dio_new.dart';

class ApiException implements Exception {
  final String? status;
  String? message;
  final bool apiError;
  final bool statusError;
  final bool deviceNotActive;
  final DioError? dioError;

  ApiException({
    this.status,
    this.message,
    this.apiError = false,
    this.statusError = false,
    this.deviceNotActive = false,
    this.dioError,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) {
    return ApiException(
      status: json['status'],
      message: json['message'],
      apiError: true,
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'message': message};

  factory ApiException.deviceNotActiveError() {
    return ApiException(
      status: 'DEVICE_NOT_ACTIVE',
      message: 'DEVICE_NOT_ACTIVE',
      deviceNotActive: true,
    );
  }
}
