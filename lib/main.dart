import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:oktoast/oktoast.dart';
import 'package:union_pay/app/base/app.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/utils/dependenc_injection.dart';
import 'route/base_route.dart';

void main() async {

  WeRouteManager.initGetXRoute();
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var currentLanguage = App.language ?? 'en';

  @override
  void initState() {
    super.initState();
    DependencyInjection.lateInit();
  }

  @override
  Widget build(BuildContext context) {
    WeRouteManager.initGetXRoute();
    return OKToast(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            /// 路由
            getPages: WeRouteManager.routes,
            unknownRoute: WeRouteManager.homePageRoute, //WeRouteManager.notFoundRoute,
            theme: ThemeData(
              useMaterial3: true,
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.blue.shade100,
                selectionHandleColor: Colors.blue.shade100,
                cursorColor: Colors.black, // change
              ),
              highlightColor: const Color.fromRGBO(0, 0, 0, 0),
              splashColor: const Color.fromRGBO(0, 0, 0, 0),
              appBarTheme: const AppBarTheme(
                scrolledUnderElevation: 0,
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: AppColors.primaryColor,
                  opacity: 1.0,
                ),
              ),
            ),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            locale: Locale(currentLanguage, ''),
            supportedLocales: const [
              Locale('zh'), //
              Locale('en', ''), //
              Locale('km', ''), //
            ],
            localeResolutionCallback: (local, support) {
              if (support.where((element) => local?.languageCode.startsWith(element.languageCode)==true).firstOrNull!=null) {
                return local;
              }
              return const Locale('en', '');
            },
            initialRoute: NavigatorUtils.initRoute(),
            defaultTransition: Transition.fade,
            builder: EasyLoading.init(builder: (c, w) {
              return Material(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: GestureDetector(
                    onTap: () {
                      hideKeyboard(c);
                    },
                    child: w,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
    // return GetMaterialApp(
    //     localizationsDelegates: const [
    //       S.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate,
    //       GlobalCupertinoLocalizations.delegate,
    //       DefaultCupertinoLocalizations.delegate,
    //     ],
    //     locale: Locale(currentLanguage, ''),
    //     supportedLocales: S.delegate.supportedLocales,
    //     title: 'My App',
    //     theme: ThemeData(
    //       primarySwatch: Colors.grey,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //   initialRoute: NavigatorUtils.initRoute(),
    //   defaultTransition: Transition.fade,
    // );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
