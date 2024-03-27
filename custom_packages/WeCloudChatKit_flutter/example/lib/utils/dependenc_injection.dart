//依赖注入

import 'dart:io';

import 'package:wecloudchatkit_flutter_example/http/net/dio_new.dart';
import 'package:wecloudchatkit_flutter_example/providers/dia_config_service.dart';
import 'package:wecloudchatkit_flutter_example/providers/hi_get.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';

class DependencyInjection {
  static Future<void> init() async {
    //GetX等其他框架初始化

    var client = await DioClientController().init();
    Hiput<HttpClient>(client);
  }

  static Future<void> resetAndInitDatabaseLocationPath(
      Directory dbDirectory) async {
    if (await dbDirectory.exists()) {
      await dbDirectory.delete(recursive: true);
    }
    await dbDirectory.create(recursive: true);
  }
}
