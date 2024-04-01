import 'dart:convert';

class ResponseData {
  ResponseData({
    this.data,
    this.message,
    this.status,
  });

  factory ResponseData.fromJson(Map<String, dynamic> jsonRes) => ResponseData(
        data: jsonRes['data'],
        status: jsonRes['status'],
        message: jsonRes['message'],
      );

  dynamic data;
  String? status;
  String? message;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'status': status,
        'message': message,
      };
  @override
  String toString() {
    return jsonEncode(this);
  }
}
