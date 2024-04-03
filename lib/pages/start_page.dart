
import 'package:flutter/material.dart';
import 'package:union_pay/app/base/app.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/pages/auth/login_page.dart';
import 'package:union_pay/pages/auth/register_page.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/utils/view_util.dart';
import 'package:union_pay/widgets/common.dart';
import '../helper/colors.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LanguageItem> languages = [
    LanguageItem('en', 'English', ImagesRes.ENGLISH_FLAG),
    LanguageItem('km', 'ភាសាខ្មែរ', ImagesRes.CAMBODIA_FLAG),
    LanguageItem('zh', '中文', ImagesRes.CHINESE_FLAG),
  ];
  String selectedLanguage = 'English';
  bool isShowLanguageList = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    selectedLanguage = languages
        .firstWhere((element) => element.code == (App.language ?? 'en'))
        .name;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          actions: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,

              onTap: () {
                setState(() {
                  isShowLanguageList = !isShowLanguageList;
                });
              },
              child: Row(
                children: [
                  cText(selectedLanguage,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  const SizedBox(width: 8.0),
                  isShowLanguageList
                      ? ImagesRes.LOGIN_LANGUAGE_UP_ICON.UIImage()
                      : ImagesRes.LOGIN_LANGUAGE_DROP_DOWN.UIImage(),
                  const SizedBox(width: 33.0)
                ],
              ),
            )
          ],
        ),
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 200,
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 0),
                      decoration: const BoxDecoration(color: AppColors.background
                      ),
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                           Tab(
                              child: Text(S.current.register,
                                style: const TextStyle(fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                ),
                              )
                          ),
                          Tab(
                            child: Text(S.current.login,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          )
                        ],
                        dividerColor: AppColors.background,
                        indicatorColor: AppColors.primaryColor,
                        unselectedLabelColor: Colors.black,
                        labelColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: RegisterPage()
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: LoginPage()
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
                visible: isShowLanguageList, child: buildLanguageList()),
          ],
        )
    );
  }

  Widget buildLanguageList() {
    return Positioned(
      top: 0,
      right: 34,
      child: Container(
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
        width: 206.0,
        height: 159,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
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
                      isShowLanguageList = false;
                      selectedLanguage = item.name;
                    });
                  }
                },
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    height: 53,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Visibility(
                              visible: isSelected,
                              child: ImagesRes.SELECT_LANGUAGE_IC.UIImage()),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: cText(item.name,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.left)),
                        item.flag.UIImage(),
                      ],
                    )),
              );
            }),
      ),
    );
  }
}


class LanguageItem {
  final String code;
  final String name;
  final String flag;

  LanguageItem(this.code, this.name, this.flag);
}