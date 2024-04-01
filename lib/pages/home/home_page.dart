import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/pages/mine/mine_page.dart';
import 'package:union_pay/pages/my_card/view.dart';
import 'package:union_pay/res/images_res.dart';
import '../../app/base/app.dart';
import '../../generated/l10n.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  final pageNo = [MyCardPage(), MinePage()];

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  void getUserProfile() async {
    try {
      await App.userRepository?.getUserInfo();
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageNo[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.color9D9D9D,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(color: AppColors.primaryColor),
          unselectedLabelStyle: const TextStyle(color: AppColors.color9D9D9D),
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(ImagesRes.CARD_IC),
              activeIcon:  Image.asset(ImagesRes.CARD_SELECTED_IC),
              label: S().card,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(ImagesRes.PROFILE_IC),
              activeIcon: Image.asset(ImagesRes.PROFILE_SELECTED_IC),
              label: S().account,
            ),
          ],
        )
    );
  }
}
