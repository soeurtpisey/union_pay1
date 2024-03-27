import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mutex/mutex.dart';
import 'package:package_info/package_info.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart';
import '../../helper/hive/hive_helper.dart';
import '../../helper/push/firebase_message_handler.dart';
import '../../helper/share_preference_keys.dart';
import '../../helper/user_session.dart';
import '../../models/user/user_profile.dart';
import '../../repositories/user_repository.dart';
import '../../route/app_route.dart';
import '../../route/base_route.dart';
import '../../widgets/common.dart';

class App {

  // Locale
  static String? language = 'EN';
  static Function({String language})? onAppLanguageChanged;
  static UserRepository userRepository = UserRepository();
  static UserSession? userSession;
  static UserProfile? userProfile;
  static PackageInfo? packageInfo;
  static String? fcmToken;
  static String? hmsToken;
  static bool refreshingSessionKey = false;
  static var mutex = Mutex();
  static Function()? userReadNotification;
  static Function()? onReceiveNotification;
  static bool isKycPage = false;
  static EventBus? eventBus;

  // Shared Prefs object
  static SharedPreferences? sharedPreferences;

  //app唯一设备id
  static String? platformDeviceId;
  // Firebase Instance
  static FirebaseMessaging? firebaseMessaging;

  static Function({String pushData})? onPushDataReceiveChanged;
  // Package Info
  static String? appBuildVersion;
  static String? appVersion;
  static String? appBundleIdentifier;

  static int? themeColorIndex;

  static Future<void> init() async {
    userRepository = UserRepository();
    packageInfo = await PackageInfo.fromPlatform();
    platformDeviceId = await PlatformDeviceId.getDeviceId;
    initializeUserSession();
  }


  static void initializeUserSession() {
    userSession ??= HiveHelper.getUserSession();
    refreshToken().then((value) {});
  }

  static bool isTokenBefore() {
    if (App.userSession?.expiredTime != null && isLogin()) {
      var dateTimeNow = DateTime.now();
      var serverTime =
          DateTime.fromMillisecondsSinceEpoch(App.userSession!.expiredTime!);
      return serverTime.isBefore(dateTimeNow);
    }
    return false;
  }

  static Future<void> refreshToken() async {
    if (isTokenBefore()) {
      print('chetwyn_isTokenBefore_${isTokenBefore()}');
      try {
        await mutex.acquire();
        print('chetwyn_isTokenBefore2_${isTokenBefore()}');
        if (isTokenBefore()) {
          var userSession = await App.userRepository?.refreshSession();
          var now = DateTime.now().millisecondsSinceEpoch;
          userSession?.expiredTime = now + (userSession.expiredIn ?? 0);
          userRepository?.setToken(userSession?.token ?? '');
          var userInfo = App.userSession?.userInfo;
          userSession?.userInfo = userInfo;
          App.userSession = userSession;
          HiveHelper.setUserSession(userSession);
          mutex.release();
          await userRepository?.getUserInfo().then((value){
            if (value != null) {
              userSession?.userInfo = value;
            }
            App.userSession = userSession;
            HiveHelper.setUserSession(userSession);
          });
        }
      } catch (e) {
        //print(e);
      } finally {
        mutex.release();
        print('chetwyn_isTokenBefore3_${isTokenBefore()}');
      }
    }
  }

  static autoLogout() {
    performLogout();
  }

  static bool isLogin() {
    var data = HiveHelper.getUserSession();
    return data != null;
  }

  static void logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: cText(S().warning.toUpperCase(), fontSize: 17, color: Colors.black),
            content: cText(S().logout_description, color: Colors.black),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    NavigatorUtils.goBack();
                  },
                  child: cText(S().cancel.toUpperCase(),
                      color: Colors.black, fontWeight: FontWeight.w500)),
              TextButton(
                onPressed: () async {
                  performLogout();
                },
                child: cText(S().yes.toUpperCase(),
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ],
          );
        });
  }

  static void performLogout() async {
    if (App.userSession == null) return;

    try {
      App.userSession = null;
      HiveHelper.clear();
      FirebaseMessageHandler.instance.removeToken();
      await NavigatorUtils.jump(AppModuleRoute.startPage, offAll: true);
    } catch (e) {
      //
    }
  }

  static Future<void> clearUserSessionAndProfile() async {
    userSession = UserSession();
    userProfile = null;
  }

  // static Future<UserProfile?> getUserProfile({bool forceReload = false}) async {
  //   if (!forceReload && userProfile != null) return userProfile;
  //   dynamic profileData;
  //   try {
  //     profileData = await userRepository.getUser();
  //   } catch (e) {
  //     try {
  //       profileData = await userRepository.getProfile();
  //     } catch (e) {
  //       //
  //       return userProfile;
  //     }
  //   }
  //   userProfile = UserProfile.fromJson(profileData);
  //
  //   ServiceLocator.get<AuthenticationBloc>().add(ProfileUpdated(
  //     userProfile: userProfile,
  //   ));
  //   ServiceLocator.get<UserBloc>().add(RefreshUser());
  //   var jsonStr = json.encode(profileData);
  //   await sharedPreferences?.setString(
  //       SharedPreferencesKeys.user_data, jsonStr);
  //   Application.eventBus?.fire(RefreshProfile());
  //   return userProfile;
  // }
  //
  // static Future<bool> isLogin() async {
  //   if (userProfile == null) {
  //     if (sharedPreferences == null) {
  //       await initializeSharedPrefs();
  //     }
  //     var data = sharedPreferences?.getString(SharedPreferencesKeys.user_data);
  //     return data != null;
  //   } else {
  //     return true;
  //   }
  // }

  static Future<UserProfile?> getLocalUserProfile(
      {bool forceReload = false}) async {
    if (userProfile != null && !forceReload) return userProfile;
    var data = sharedPreferences?.getString(SharedPreferencesKeys.user_data);
    if (data != null) {
      var map = json.decode(data);
      userProfile = UserProfile.fromJson(map);
      /// warning
      // ServiceLocator.get<AuthenticationBloc>().add(ProfileUpdated(
      //   userProfile: userProfile,
      // ));
      return userProfile;
    } else {
      /// warning
      // return getUserProfile(forceReload: forceReload);
    }
  }
}
