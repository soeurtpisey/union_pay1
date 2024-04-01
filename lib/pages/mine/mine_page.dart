import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/res/images_res.dart';

import '../../app/base/app.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../widgets/common.dart';

class MinePage extends StatefulWidget {
  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.only(left: 19, right: 19),
        child: Column(children: [
          const SizedBox(height: 25),
          cText('+${App.userInfo?.phone ?? ''}', fontSize: 24, color: Colors.black),
          const SizedBox(height: 5),
          cText('ID: ${App.userInfo?.id}', color: AppColors.color79747E),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            height: 56,
            child: Row(children: [
              Image.asset(ImagesRes.LANGUAGE_IC),
              const SizedBox(width: 10),
              cText(S().language, fontSize: 17, color: Colors.black),
              Expanded(
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      cText('English', fontSize: 17, color: AppColors.color999999, textAlign: TextAlign.right),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios, color: AppColors.color999999, size: 15,)
                    ],
                  )
              )
            ],)
          ),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              App.logout(context);
            },
            child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                height: 56,
                child: Row(children: [
                  Image.asset(ImagesRes.LOGOUT_IC),
                  const SizedBox(width: 10),
                  cText(S().log_out, fontSize: 17, color: Colors.black),
                  const Expanded(
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.arrow_forward_ios, color: AppColors.color999999, size: 15,)
                        ],
                      )
                  )
                ],)
            ),
          ),
          const SizedBox(height: 16)
        ],),
      ),
    );
  }
}