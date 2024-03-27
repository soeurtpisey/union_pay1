import 'package:hive/hive.dart';

const String boxPrefix = 'genshin_coin';

class HiveBoxes {
  const HiveBoxes._();

  ///全局配置信息
  static late Box globalBox;
  static late Box<bool> loginBox;
  static late Box<int> settingBox;

  static registerAdapter() {}

  static Future<void> openBoxes() async {
    await Future.wait(<Future<void>>[
      () async {
        //demo
        globalBox = await Hive.openBox('${boxPrefix}_global');
      }(),
      () async {
        //demo
        loginBox = await Hive.openBox('${boxPrefix}_login');
      }(),
      () async {
        settingBox = await Hive.openBox('${boxPrefix}_setting');
      }(),
    ]);
  }
}
