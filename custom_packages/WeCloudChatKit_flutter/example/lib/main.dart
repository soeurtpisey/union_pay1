import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/chat_page.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/conversation_page.dart';
import 'package:wecloudchatkit_flutter_example/login_page.dart';
import 'package:wecloudchatkit_flutter_example/utils/dependenc_injection.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  SpUtil.getInstance();
  WeClient.getInstance
      .initialize(Constant.HTTP_URL, Constant.WS_URL);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      onGenerateRoute: _onGenerateRoute,
      initialRoute: '/',
      // routes: {
      //   '/login': (BuildContext context) => LoginPage(),
      //   '/conversation': (BuildContext context) => ConversationPage(),
      //   '/chat': (BuildContext context) => ChatPage(),
      // }
    ));
  }

}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  var routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => LoginPage(),
    '/conversation': (BuildContext context) => ConversationPage(),
    '/chat': (BuildContext context) =>
        ChatPage((settings.arguments as List)[0]),
  };
  WidgetBuilder? builder = routes[settings.name] as WidgetBuilder;
  return MaterialPageRoute(builder: (ctx) => builder(ctx));
}
