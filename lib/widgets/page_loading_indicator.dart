
import 'package:flutter/material.dart';
import '../helper/colors.dart';

class PageLoadingIndicator extends StatelessWidget {

  final Color color;
  PageLoadingIndicator({this.color = AppColors.colorEE290B});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}