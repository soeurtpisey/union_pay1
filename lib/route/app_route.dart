import 'package:get/get.dart';
import 'app_page.dart';
import 'base_route.dart';

class AppModuleRoute implements IModuleRoute {
  static const startPage = '/start_page';
  static const registerByEmailPage = '/register_by_email_page';
  static const verifyCodePage = '/verify_code_page';
  static const resetPasswordPage = '/reset_password_page';
  static const loginByEmailPage = '/login_by_email_page';
  static const homePage = '/home_page';
  static const notificationListPage = '/notification_list_page';
  static const resetPasswordOtpPage = '/reset_password_otp_page';

  @override
  List<GetPage> getRoutes() {
    return AppPages.pages;
  }
}
