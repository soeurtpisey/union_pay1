import '../app/base/app.dart';
import '../helper/hive/hive_helper.dart';
import '../helper/user_session.dart';
import '../http/api.dart';
import '../models/user/user_info.dart';
import '../utils/log_util.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  Future<dynamic> loginWithEmail(
      {required String email, required String password}) async {
    Log.e(App.fcmToken);
    var data = {
      'email': email,
      'password': password,
    };

    final apiResponse = await appPost(Api.emailLogin, data: data);
    final userSession = UserSession.fromJson(apiResponse.data);
    await initConfig(userSession);
    return apiResponse.data;
  }

  Future<dynamic> loginWithPhone(
      {required String phone, required String password}) async {
    Log.e(App.fcmToken);
    var data = {
      'phone': phone,
      'password': password,
    };

    final apiResponse = await appPost(Api.phoneLogin, data: data);
    final userSession = UserSession.fromJson(apiResponse.data);
    await initConfig(userSession);
    return apiResponse.data;
  }

  Future<dynamic> registerWithPhone(
      {required String phone, required String password}) async {
    Log.e(App.fcmToken);
    var data = {
      'phone': phone,
      'password': password,
    };

    final apiResponse = await appPost(Api.phoneRegister, data: data);
    final userSession = UserSession.fromJson(apiResponse.data);
    await initConfig(userSession);
    return apiResponse.data;
  }

  Future<void> initConfig(UserSession userSession) async {
    var now = DateTime.now().millisecondsSinceEpoch;
    userSession.expireTime = now + (userSession.expireSecond ?? 0);
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
      'refreshToken': '',//App.userSession?.refreshToken,
    };
    final apiResponse = await appPost(Api.refreshToken, data: data);
    return UserSession.fromJson(apiResponse.data);
  }

  Future<UserInfo?> getUserInfo() async {
    final apiResponse = await appGet(Api.userInfo);
    final data = UserInfo.fromJson(apiResponse.data);
    App.userInfo = data;
    return data;
  }

  Future<dynamic> emailRegisterSendOTP(
      {required String email}) async {
    var params = {
      'email': email,
    };
    final apiResponse = await appPost(Api.emailRegisterSendOTP, data: params);
    return apiResponse.data;
  }

  Future<dynamic> emailRegisterVerifyOTP(
      {required String email, required String optCode}) async {
    var params = {
      'email': email,
      'optCode': optCode
    };
    final apiResponse = await appPost(Api.emailRegisterVerifyOTP, data: params);
    return apiResponse.data;
  }


  Future<dynamic> registerWithEmail(
      {required String email, required String password, required String verifyUuid}) async {
    var params = {
      'email': email,
      'password': password,
      'verifyUuid': verifyUuid
    };
    final apiResponse = await appPost(Api.emailRegister, data: params);
    final userSession = UserSession.fromJson(apiResponse.data);
    await initConfig(userSession);
    return apiResponse.data;
  }

  Future<dynamic> forgetPassSendOTPByEmail(
      {required String email}) async {
    var params = {
      'email': email,
    };
    final apiResponse = await appPost(Api.forgetPassSendOTPByEmail, data: params);
    return apiResponse.data;
  }

  Future<dynamic> verifyOTPForgetPassByEmail(
      {required String email, required String optCode}) async {
    var params = {
      'email': email,
      'optCode': optCode
    };
    final apiResponse = await appPost(Api.verifyOTPForgetPassByEmail, data: params);
    return apiResponse.data;
  }

  Future<dynamic> forgetPassByEmail(
      {required String email, required String verifyUuid, required String password}) async {
    var params = {
      'email': email,
      'verifyUuid': verifyUuid,
      'password': password
    };
    final apiResponse = await appPost(Api.forgetPassByEmail, data: params);
    return apiResponse.data;
  }

  Future<dynamic> forgetPassSendOTPByPhone(
      {required String phone}) async {
    var params = {
      'phone': phone,
    };
    final apiResponse = await appPost(Api.forgetPassSendOTPByPhone, data: params);
    return apiResponse.data;
  }

  Future<dynamic> forgetPassByPhone(
      {required String password, required String verifyUuid, required String phone}) async {
    var params = {
      'verifyUuid': verifyUuid,
      'password': password,
      'phone': phone,
    };
    final apiResponse = await appPost(Api.forgetPassByPhone, data: params);
    return apiResponse.data;
  }

  Future<dynamic> verifyOTPForgetPassByPhone(
      {required String phone, required String optCode}) async {
    var params = {
      'phone': phone,
      'optCode': optCode
    };
    final apiResponse = await appPost(Api.verifyOTPForgetPassByPhone, data: params);
    return apiResponse.data;
  }

}
