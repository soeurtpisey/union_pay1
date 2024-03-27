import 'dart:convert';

import '../../constants/hive_boxes.dart';
import '../../constants/hive_key.dart';
import '../user_session.dart';

class HiveHelper {
  static void setToken(String token) {
    HiveBoxes.globalBox.put(HiveKey.keyToken, token);
  }

  //获取token
  static String? getToken() {
    return HiveBoxes.globalBox.get(HiveKey.keyToken, defaultValue: null);
  }

  static bool? hasToken() {
    var token = getToken();
    return token != null && token != '';
  }

  static void setUserSession(UserSession? userSession) {
    if (userSession != null) {
      HiveBoxes.globalBox.put(HiveKey.keyUserSession, userSession.toJson());
    }
  }

  static void setLastLoginUserName(String? username){
    if(username!=null&&username!=''){
      HiveBoxes.globalBox.put(HiveKey.keyLastLoginUserName, username);
    }
  }

  static String? getLastLoginUserName() {
    var userSession = HiveBoxes.globalBox.get(HiveKey.keyLastLoginUserName,defaultValue: null);
    if (userSession != null) {
      return userSession;
    }
    return null;
  }

  static UserSession? getUserSession() {
    var userSession = HiveBoxes.globalBox.get(HiveKey.keyUserSession,defaultValue: null);
    if (userSession != null) {
      var json = jsonEncode(userSession);
      return UserSession.fromJson(jsonDecode(json));
    }
    return null;
  }

  //
  static void clear() {
    HiveBoxes.globalBox.delete(HiveKey.keyToken);
    HiveBoxes.globalBox.delete(HiveKey.keyUserSession);
  }
}
