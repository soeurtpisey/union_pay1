
import '../utils/adapt.dart';

extension DoubleExtension on double {
  double get px {
    return Adapt.px(this * 2);
  }
}