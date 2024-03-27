import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show window;
import 'dart:ui';
import 'package:flutter/material.dart';

class ScreenUtil {
  static double get navigationBarHeight {
    var mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top + kToolbarHeight;
  }

  static double get topSafeHeight {
    var mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top;
  }

  static double get screenWidth {
    var mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.width;
  }

  static double get screenWidthPx {
    return window.physicalSize.width;
  }

  static double get screenHeightPx {
    return window.physicalSize.height;
  }

  static double get screenHeight {
    var mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.height;
  }

  static double get radio {
    return screenHeight / screenWidth;
  }
}