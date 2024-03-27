import 'package:flutter/material.dart';
import 'package:union_pay/widgets/common.dart';
import '../route/base_route.dart';
import '../helper/colors.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: cText("Route not found", color: Colors.black),
      ),
      body: Center(
        child: TextButton(
          child: Container(
            decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.only(left: 7, right: 7),
                child: cText('Return', color: Colors.white)
            )
          ),
          onPressed: () => NavigatorUtils.goBack(),
        ),
      ),
    );
  }
}
