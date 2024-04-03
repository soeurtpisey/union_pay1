import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/pages/mine/change_language_page.dart';
import 'package:union_pay/pages/start_page.dart';
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
  List<LanguageItem> languages = [
    LanguageItem('en', 'English', ImagesRes.ENGLISH_FLAG),
    LanguageItem('km', 'ភាសាខ្មែរ', ImagesRes.CAMBODIA_FLAG),
    LanguageItem('zh', '中文', ImagesRes.CHINESE_FLAG),
  ];
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    selectedLanguage = languages
        .firstWhere((element) => element.code == (App.language ?? 'en'))
        .name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 19, bottom: 5),
            child: cText((App.userInfo?.phone != null) ?
            '+${App.userInfo?.phone ?? ''}' : App.userInfo?.email ?? '',
                fontSize: 24, color: Colors.black),
          ),
          cText('ID: ${App.userInfo?.id}', color: AppColors.color79747E),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              /// on tap language
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: true,
                  isDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const ChangeLanguageBottomSheetPage();
                  }
              );
            },
            child: Container(
                margin: const EdgeInsets.only(left: 19, right: 19),
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                height: 56,
                child: Row(
                  children: [
                    Image.asset(ImagesRes.LANGUAGE_IC),
                    const SizedBox(width: 10),
                    cText(S().language, fontSize: 17, color: Colors.black),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            cText(selectedLanguage,
                                fontSize: 17,
                                color: AppColors.color999999,
                                textAlign: TextAlign.right),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.color999999,
                              size: 15,
                            )
                          ],
                        )
                    )
                  ],
                )),
          ),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              App.logout(context);
            },
            child: Container(
                margin: const EdgeInsets.only(left: 19, right: 19),
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                height: 56,
                child: Row(
                  children: [
                    Image.asset(ImagesRes.LOGOUT_IC),
                    const SizedBox(width: 10),
                    cText(S().log_out, fontSize: 17, color: Colors.black),
                    const Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.color999999,
                              size: 15,
                            )
                          ],
                        ))
                  ],
                )),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}