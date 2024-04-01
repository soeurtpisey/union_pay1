import 'package:union_pay/pages/auth/forget_password_otp_page.dart';
import 'package:union_pay/pages/auth/login_by_email_page.dart';
import 'package:union_pay/pages/auth/verify_code_page.dart';
import 'package:union_pay/pages/home/home_page.dart';
import 'package:union_pay/pages/notification/notification_list_page.dart';
import '../pages/auth/forget_password_page.dart';
import '../pages/auth/register_by_email_page.dart';
import '../pages/auth/select_country_code.dart';
import '../pages/start_page.dart';
import 'app_route.dart';
import 'base_route.dart';

abstract class AppPages {
  static final pages = [
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.startPage,
      page: () => StartPage(),
    ),
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.registerByEmailPage,
      page: () => RegisterByEmailPage(),
    ),
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.verifyCodePage,
      page: () => VerifyCodePage(),
    ),
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.resetPasswordPage,
      page: () => ForgetPasswordPage(),
    ),
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.verifyCodePage,
      page: () => LoginByEmailPage(),
    ),
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.homePage,
      page: () => HomePage(),
    ),
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.notificationListPage,
      page: () => NotificationListPage(),
    ),
    WeGetPageBuilder.createCommonPage(
      name: AppModuleRoute.resetPasswordOtpPage,
      page: () => ForgetPasswordOTPPage(),
    ),

  ];
}
