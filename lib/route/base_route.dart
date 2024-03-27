import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/models/auth/phone_verify_model.dart';
import 'package:union_pay/pages/home/home_page.dart';
import 'package:union_pay/pages/start_page.dart';
import '../models/auth/email_verify_model.dart';
import '../pages/not_found_page.dart';
import 'app_route.dart';

/// ////////////////////////////////////////////
/// @Author: mac
/// @Date:
/// @Email:
/// @Description:
/// /////////////////////////////////////////////

class WeRouteManager {
  /// 找不到页面
  static const notFound = '/not_found_page';

  /// 初始化路由
  static void initGetXRoute() {
    routes.addAll(AppModuleRoute().getRoutes());
  }

  static final notFoundRoute = GetPage(
    name: notFound,
    page: () => const NotFoundPage(),
  );

  static final homePageRoute = GetPage(
    name: notFound,
    page: () => StartPage(),
  );

  /// GetX路由
  static List<GetPage> routes = [];

}

abstract class IModuleRoute {
  List<GetPage> getRoutes();
}

class WeGetPageBuilder {
  static GetPage createCommonPage({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    List<Bindings> bindings = const [],
    Transition? transition,
    Duration? transitionDuration,
    CustomTransition? customTransition,
  }) {
    return createAuthPage(
      name: name,
      page: page,
      binding: binding,
      bindings: bindings,
      auth: false,
      transition: transition,
      customTransition: customTransition,
      transitionDuration: transitionDuration,
    );
  }

  static GetPage createAuthPage({
    required String name,
    required GetPageBuilder page,
    bool auth = true,
    Bindings? binding,
    List<Bindings> bindings = const [],
    Transition? transition,
    Duration? transitionDuration,
    CustomTransition? customTransition,
  }) {
    List<GetMiddleware>? middlewares;

    /// 默认页面跳转动画
    transition ??= Transition.cupertino;

    return GetPage(
      name: name,
      page: page,
      middlewares: middlewares,
      binding: binding,
      bindings: bindings,
      transition: transition,
      customTransition: customTransition,
      transitionDuration: transitionDuration,
    );
  }
}

/// 页面路由导航工具
class NavigatorUtils {
  /// 返回无参数
  static void goBack<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    Get.back(
        result: result, closeOverlays: closeOverlays, canPop: canPop, id: id);
  }

  static void popUntil({RoutePredicate predicate = predicateX}) {
    Get.until(predicateX);
  }

  static bool predicateX(Route<dynamic> route,{String? pageRoute}) {
    if (route.settings.name == AppModuleRoute.startPage) {
      return true;
    } else {
      return false;
    }
  }

  static String initRoute() {
    return AppModuleRoute.startPage;
  }

  static void goBackWithParams<T>(result) {
    goBack<T>(result: result);
  }

  static Future? jump(String newRouteName,
      {bool off = false,
        bool offAll = false,
        bool until = false,
        dynamic arguments,
        int? id,
        Map<String, String>? parameters,
        bool preventDuplicates = true,
        RoutePredicate predicate = predicateX}) {
    if (until) {
      return Get.offNamedUntil(newRouteName, predicate,
          arguments: arguments, parameters: parameters);
    }

    if (offAll) {
      return Get.offAllNamed(
        newRouteName,
        arguments: arguments,
        id: id,
        parameters: parameters,
      );
    }

    if (off) {
      return Get.offNamed(
        newRouteName,
        preventDuplicates: preventDuplicates,
        arguments: arguments,
        id: id,
        parameters: parameters,
      );
    }

    return Get.toNamed(
      newRouteName,
      preventDuplicates: preventDuplicates,
      arguments: arguments,
      id: id,
      parameters: parameters,
    );
  }
}
