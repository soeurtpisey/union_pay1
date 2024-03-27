
import 'package:wecloudchatkit_flutter_example/utils/date_utils.dart';

/// 根据毫秒返回时间Str
String timeStrByMs(int ms, {bool showTime = false}) {
  String ret = '';
  // 是否当天
  // HH:mm
  if (DateUtil.isToday(ms)) {
    ret = DateUtil.formatDateMs(ms, format: 'HH:mm');
  }
  // // 是否本周
  // // 周一、周二、周三...
  // else if (DateUtil.isWeek(ms)) {
  //   ret = DateUtil.getWeekdayByMs(ms);
  // }

  // 是否本年
  // MM/dd
  else if (DateUtil.yearIsEqualByMs(ms, DateUtil.getNowDateMs())) {
    if (showTime) {
      ret = DateUtil.formatDateMs(ms, format: 'MM月dd日 HH:mm');
    } else {
      ret = DateUtil.formatDateMs(ms, format: 'MM月dd日');
    }
  }
  // yyyy/MM/dd
  else {
    if (showTime) {
      ret = DateUtil.formatDateMs(ms, format: 'yyyy年MM月dd日 HH:mm');
    } else {
      ret = DateUtil.formatDateMs(ms, format: 'yyyy年MM月dd日');
    }
  }

  return ret;
}