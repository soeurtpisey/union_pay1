
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/widget_extension.dart';

import '../constants/style.dart';
import '../generated/l10n.dart';
import '../helper/colors.dart';
import 'common.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/21 19:38
/// @Description:
/// /////////////////////////////////////////////

class SimpleTextDialog extends Dialog{

  final String title;
  final VoidCallback onTap;
  final bool barrierDismissible;
  final bool isCancel;
  final String? leftText;
  final String? rightText;


  SimpleTextDialog(this.title, this.onTap,
      {this.barrierDismissible = true, this.isCancel = true,this.leftText,this.rightText});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(24)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              cText(title,textAlign: TextAlign.start,fontWeight: FontWeight.w500,fontSize: 16,color: Colors.black),
              Gaps.vGap24,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(isCancel)
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: cText(leftText?? S().cancel,textAlign: TextAlign.start,fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.colorE40C19,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: cText(rightText??S.of(context).confirm,textAlign: TextAlign.start,fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),
                  ).onClick((){
                    Navigator.pop(context);
                    onTap.call();
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}