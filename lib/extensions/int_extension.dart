
import '../utils/adapt.dart';

extension intExtension on int {
  int px(int num) {
    return Adapt.px(num * 2);
  }

  String addZero() {
    if (this < 10) {
      return '0$this';
    } else {
      return '$this';
    }
  }
}