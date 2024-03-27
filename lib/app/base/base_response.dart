import 'dart:convert';

class ResponseData {
  ResponseData({
    this.data,
    this.messageCode,
    this.message,
  });

  factory ResponseData.fromJson(Map<String, dynamic> jsonRes) => ResponseData(
        data: jsonRes['data'],
        messageCode: jsonRes['messageCode'],
        message: jsonRes['message'],
      );

  dynamic data;
  String? messageCode;
  String? message;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'status': messageCode,
        'message': message,
      };
  @override
  String toString() {
    return jsonEncode(this);
  }
}
