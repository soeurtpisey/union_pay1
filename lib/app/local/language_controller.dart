import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/hive_boxes.dart';
import '../../constants/hive_key.dart';
import '../../generated/l10n.dart';
import '../base/app.dart';


class LanguageController extends GetxController {
  static LanguageController get to => Get.find<LanguageController>();

  // var curLocale = WidgetsBinding.instance.window.locale.obs;
  var curLocale = Get.deviceLocale.obs;

  @override
  void onInit() {
    super.onInit();
    initLocale();
  }

  void initLocale() {
    int? localeIndex = HiveBoxes.settingBox.get(HiveKey.keyLanguage);
    if (localeIndex != null) {
      changeLocale(localeIndex);
    } else {
      setCache();
    }
  }

  void changeLocale(int index) {
    Locale locale = curLocale.value!;
    switch (index) {
      case 0:
        locale = const Locale('zh');
        break;
      case 1:
        locale = const Locale('en', '');
        break;
      case 2:
        locale = const Locale('km', '');
        break;
    }
    curLocale.value = locale;
    S.load(locale);
    setCache();
    update();

    Get.updateLocale(locale);
  }

  void setCache() async {
    var lang = curLocale.value!.languageCode;
    App.language = lang;
    int index;
    if (lang.startsWith('zh')) {
      index = 0;
    } else if (lang.startsWith('en')) {
      index = 1;
    } else {
      index = 2;
    }
    HiveBoxes.settingBox.put(HiveKey.keyLanguage, index);
  }
}
