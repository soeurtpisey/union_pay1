
import 'package:flutter/material.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/pages/auth/login_page.dart';
import 'package:union_pay/pages/auth/register_page.dart';
import '../helper/colors.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
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
        )
    );
  }
}
