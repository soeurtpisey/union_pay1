import 'dart:math';

import 'package:intl/intl.dart';

/*
* @method GetNowDateAndFormat
* @author: ZhongWb
* @date: 2019/11/18 10:01
* @description  获取时间 返回格式化 年月日 时分秒
*/
GetNowDateAndFormat({String? formatter1, DateTime? dateTime}) {
  var formatter = DateFormat(formatter1 ?? 'yyyy-MM-dd HH:mm:ss');
  return formatter.format(dateTime ?? DateTime.now());
}

/*
* @method GetNowDateAndFormatFileName
* @author: ZhongWb
* @date: 2019/11/18 10:02
* @description 文件命名 时间戳+随机数 （ 年月日+时分秒+毫秒+5位随机数）
*/
GetNowDateAndFormatFileName({int? randomLen}) {
  var formatter = DateFormat(
      'yyyyMMddHHmmssSSS_' + Random().nextInt(randomLen ?? 99999).toString());
  return formatter.format(DateTime.now());
}
