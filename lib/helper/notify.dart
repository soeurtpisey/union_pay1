import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
class Notify {
  static void info({
    required String message,
    required BuildContext context,
    int duration = 3000,
  }) {
    showToast(message);
  }
}