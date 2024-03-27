
import 'dart:io';
import 'package:flutter/cupertino.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }

}