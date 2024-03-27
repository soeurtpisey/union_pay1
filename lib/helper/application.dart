//
// import 'package:event_bus/event_bus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:mutex/mutex.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:union_pay/helper/user_session.dart';
//
// import '../repositories/user_repository.dart';
//
// class Application {
//   // Locale
//   static String? language = 'en';
//   static Function({String language})? onAppLanguageChanged;
//   static UserRepository userRepository = UserRepository();
//   static UserSession? userSession;
//   static String? fcmToken;
//   static String? hmsToken;
//   static bool refreshingSessionKey = false;
//   static var mutex = Mutex();
//
//   static bool isKycPage = false;
//   static EventBus? eventBus;
//
//   // Shared Prefs object
//   static SharedPreferences? sharedPreferences;
//
//   //app唯一设备id
//   static String? platformDeviceId;
//   // Firebase Instance
//   static FirebaseMessaging? firebaseMessaging;
//
//   static Function({String pushData})? onPushDataReceiveChanged;
//   // Package Info
//   static String? appBuildVersion;
//   static String? appVersion;
//   static String? appBundleIdentifier;
// }
