import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../../app/base/app.dart';
import '../../utils/log_util.dart';

class FirebaseMessageHandler {
  factory FirebaseMessageHandler() => _getInstance();

  static FirebaseMessageHandler get instance => _getInstance();
  static FirebaseMessageHandler? _instance;

  static FirebaseMessageHandler _getInstance() {
    _instance ??= FirebaseMessageHandler._internal();
    return _instance!;
  }

  FirebaseMessageHandler._internal() {
    Log.d('firebase init');
  }

  FirebaseMessaging? firebaseMessaging;

  Future<void> setup() async {
    await Firebase.initializeApp();
    firebaseMessaging = FirebaseMessaging.instance;
    setupListeners();
  }

  void setupListeners() async {
    await askIosPermissions();

    if (App.fcmToken != null) return; // Already Initialized
    // FlutterAppBadger.removeBadge();

    try {
      final token = await firebaseMessaging?.getToken();
      Log.d('firebase:$token');

      App.fcmToken = token;
      await firebaseMessaging
          ?.getInitialMessage()
          .then((RemoteMessage? message) {
        // MessageHandler.handlerRemoteMessage(message?.data);
      });
    } catch (e) {
      Log.e(e);
      getFcm();
    }
    FirebaseMessaging.onMessage.listen((event) {
      handlerRemoteMessage(event.data, inApp: true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      handlerRemoteMessage(message.data);
    });
  }

  void getFcm() async {
    final token = await firebaseMessaging?.getToken();
    Log.d('firebase:$token');

    App.fcmToken = token;
    await firebaseMessaging?.getInitialMessage().then((RemoteMessage? message) {
    });
  }

  /*
   * 订阅多语境topic
   */
  Future<void> subscribe(String topic) async {
    if (firebaseMessaging != null && App.fcmToken != null) {
      try {
        await firebaseMessaging?.subscribeToTopic(topic);
      } catch (e) {
        Log.e(e);
      }
    }
  }

  /*
   * 移除多语境topic
   */
  Future<void> unsubscribe(String topic) async {
    if (firebaseMessaging != null && App.fcmToken != null) {
      try {
        await firebaseMessaging?.unsubscribeFromTopic(topic);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> removeToken() async {
    if (firebaseMessaging != null && App.fcmToken != null) {
      try {
        await firebaseMessaging?.deleteToken();
        App.fcmToken = null;
        final token = await firebaseMessaging?.getToken();
        App.fcmToken = token;
      } catch (e) {
        Log.e(e);
      }
    }
  }

  Future<void> askIosPermissions() async {
    var settings = await firebaseMessaging?.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      Log.w('User granted permission');
    } else if (settings?.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Log.w('User granted provisional permission');
    } else {
      Log.w('User declined or has not accepted permission');
    }
  }

  void handlerRemoteMessage(Map<String, dynamic>? data, {bool inApp = false}) {
    print('data ====  ${data.toString()}');
    if (data != null) {
      if (data.containsKey('pushType') && data['pushType'] == 'system') {
        final notificationId = data['notificationId'];
        final auditId = data['auditId'];
        final status = data['status'];
        if (!inApp) {
          // Get.put(NotificationLogic());
          // if (Get.isRegistered<NotificationLogic>()) {
          //   var controller = Get.find<NotificationLogic>();
          //   controller.requestReadNotification(int.parse(notificationId),
          //       isReadAll: false);
          //   if (auditId == null) return;
          //   if (status == 'APPROVED') {
          //     controller.gotoMerchantDetail(auditId);
          //   } else if (status == 'REJECTED') {
          //     controller.gotoEditRejectedAudit(auditId);
          //   }
          // }
        } else {
          App.onReceiveNotification?.call();
        }
      }
    }
  }
}
