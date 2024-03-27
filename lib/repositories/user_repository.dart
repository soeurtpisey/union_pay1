import 'dart:io';
import '../app/base/app.dart';
import '../generated/json/base/json_convert_content.dart';
import '../helper/hive/hive_helper.dart';
import '../helper/user_session.dart';
import '../http/api.dart';
import '../models/user/user_info.dart';
import '../utils/log_util.dart';
import 'base_repository.dart';
import 'package:device_info/device_info.dart';

class UserRepository extends BaseRepository {
  Future<dynamic> login(
      {required String username, required String password}) async {
    Log.e(App.fcmToken);
    // showToast(App.fcmToken);
    // final ts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
    var data = {
      'appVersion': App.packageInfo?.version,
      'username': username,
      'password': password,
      'token': App.fcmToken ?? '',
      'deviceId': App.platformDeviceId,
    };

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      data['osVersion'] = androidInfo.version.release;
      data['os'] = 'Android';
      data['model'] = androidInfo.product;
      data['brand'] = androidInfo.brand;
      data['pushType'] = '0';
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      data['osVersion'] = iosInfo.systemVersion;
      data['os'] = 'iOS';
      data['model'] = iosInfo.utsname.machine;
      data['brand'] = 'APPLE';
      data['pushType'] = '0';
    }

    final apiResponse = await appPost(Api.login, data: data);
    final userSession = UserSession.fromJson(apiResponse.data);
    await initConfig(userSession);
    HiveHelper.setLastLoginUserName(username);
    return apiResponse.data;
  }

  Future<void> initConfig(UserSession userSession) async {
    var now = DateTime.now().millisecondsSinceEpoch;
    userSession.expiredTime = now + (userSession.expiredIn ?? 0);
    // userSession.expiredTime = now + 20000;
    setToken(userSession.token ?? '');
    final userInfo = await getUserInfo();
    if (userInfo != null) {
      userSession.userInfo = userInfo;
    }
    App.userSession = userSession;
    HiveHelper.setUserSession(userSession);


  }

  Future<UserSession> refreshSession() async {
    var data = {
      'refreshToken': App.userSession?.refreshToken,
    };
    final apiResponse = await appPost(Api.refreshToken, data: data);
    return UserSession.fromJson(apiResponse.data);
  }

  Future<UserInfo?> getUserInfo() async {
    final apiResponse = await appGet(Api.userInfo);
    final data = UserInfo.fromJson(apiResponse.data);
    // App.userInfo = data;
    return data;
  }

  Future<dynamic> emailVerify(
      {required String email}) async {
    var params = {
      'email': 'user@gmail.com',
    };
    final apiResponse = await appPost(Api.emailVerify, data: params);
    return apiResponse.data;
  }

}
