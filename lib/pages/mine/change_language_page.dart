import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/pages/start_page.dart';
import 'package:union_pay/res/images_res.dart';

import '../../app/base/app.dart';
import '../../widgets/common.dart';

class ChangeLanguageBottomSheetPage extends StatefulWidget {
  const ChangeLanguageBottomSheetPage({super.key});

  @override
  State<ChangeLanguageBottomSheetPage> createState() => _ChangeLanguageBottomSheetPageState();
}

class _ChangeLanguageBottomSheetPageState extends State<ChangeLanguageBottomSheetPage> {

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
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  return;
                },
                child: Container(color: Colors.black.withOpacity(0.2).withAlpha(10))
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 13, top: 20, bottom: 13),
                    child: cText(S().choose_language, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color48464C, textAlign: TextAlign.left)
                ),
                Container(height: 1, color: AppColors.colorA8A8A8),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final item = languages[index];
                      var isSelected = (App.language ?? 'en') == item.code;
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (!isSelected) {
                            setState(() {
                              App.onAppLanguageChanged
                                  ?.call(language: item.code);
                              selectedLanguage = item.name;
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            height: 53,
                            child: Row(
                              children: [
                                item.flag.UIImage(),
                                const SizedBox(width: 20),
                                Expanded(
                                    child: cText(item.name,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.left)),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Visibility(
                                      visible: isSelected,
                                      child: ImagesRes.SELECT_LANGUAGE_IC.UIImage()),
                                ),
                              ],
                            )),
                      );
                    }),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}