/*
 * @author djw
 * @date 2022/10/11 12:58
 */
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class EncryptUtil {
  /// md5 加密
  static String encodeMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  /// 异或对称加密
  static String xorCode(String res, String key) {
    var keyList = key.split(',');
    var codeUnits = res.codeUnits;
    var codes = <int>[];
    for (var i = 0, length = codeUnits.length; i < length; i++) {
      var code = codeUnits[i] ^ int.parse(keyList[i % keyList.length]);
      codes.add(code);
    }
    return String.fromCharCodes(codes);
  }

  /// 异或对称 Base64 加密
  static String xorBase64Encode(String res, String key) {
    var encode = xorCode(res, key);
    encode = encodeBase64(encode);
    return encode;
  }

  /// 异或对称 Base64 解密
  static String xorBase64Decode(String res, String key) {
    var encode = decodeBase64(res);
    encode = xorCode(encode, key);
    return encode;
  }

  /// Base64加密
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /// Base64解密
  static String decodeBase64(String data) {
    List<int> bytes = base64Decode(data);
    var result = utf8.decode(bytes);
    return result;
  }
}
