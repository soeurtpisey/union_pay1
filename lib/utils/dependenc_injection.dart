
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../app/base/app.dart';
import '../app/local/language_controller.dart';
import '../app/providers/dio_config_service.dart';
import '../constants/hive_boxes.dart';
import '../helper/push/firebase_message_handler.dart';
import '../http/net/http_client.dart';

class DependencyInjection {
  static Future<void> init() async {

    await Hive.initFlutter();
    HiveBoxes.registerAdapter();
    await HiveBoxes.openBoxes();

    Get.put<LanguageController>(LanguageController());

    //GetX等其他框架初始化
    var client = DioClientController().init();
    Get.put<HttpClient>(client);

    App.init();
  }

  static Future<void> lateInit() async {
    FirebaseMessageHandler.instance.setup();
  }
}
