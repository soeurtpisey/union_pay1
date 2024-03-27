import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/repositories/user_repository.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  TextEditingController _inputController = TextEditingController();

  late StreamSubscription<bool> keyboardSubscription;
  bool keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    autoOpenSDK();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
          keyboardVisible = visible;
        });
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    ///获取键盘高度,优化聊天界面体验
    final mediaQueryData = MediaQueryData.fromWindow(ui.window);
    final keyHeight = mediaQueryData.viewInsets.bottom;
    if (keyHeight != 0 && keyboardVisible) {
      SpUtil.putDouble(Constant.KEY_SOFTKEY_HEIGHT, keyHeight);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    keyboardSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '请输入ClientId',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.all(10)),
            _buildInput(),
            Expanded(child: Container()),
            _buildLoginBtn(() {
              if (_inputController.text.isEmpty) {
                showToast('请输入ClientId');
                return;
              }
              String clientId = _inputController.text.toString();

              loginIMSDK(clientId).then((token) {
                SpUtil.putString(Constant.KEY_TOKEN, token ?? "");
                SpUtil.putString(Constant.KEY_CLIENT_ID, clientId);
                gotoConversationPage(context);
              });
            }),
            Padding(padding: EdgeInsets.all(20))
          ],
        ),
      ),
    );
  }

  void gotoConversationPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, "/conversation", (route) => false);
  }

  Future<String?> loginIMSDK(String clientId) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      int platform = 1;
      if (Platform.isIOS) {
        platform = 3;
      } else if (Platform.isAndroid) {
        platform = 2;
      }
      try {
        var sign = await UserRepository().getSign(clientId, Constant.APP_KEY,
            Constant.APP_SECRET, timestamp, platform);
        return await WeClient.getInstance.loginAndOpen(
            clientId, Constant.APP_KEY, timestamp, sign, platform);
      } catch (e) {
        showToast("登录失败");
        throw e;
      }
    } on PlatformException {}
  }

  _buildLoginBtn(VoidCallback? onPressed) {
    return Container(
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              overlayColor: MaterialStateProperty.all(Colors.blue[300]),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
              )))),
          onPressed: onPressed,
          child: Text("登录"),
        ),
      ),
    );
  }

  _buildInput() {
    return TextField(
      style: TextStyle(color: Colors.black, fontSize: 20),
      controller: _inputController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
        ),
        hintText: "clientId",
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  void autoOpenSDK() async {
    bool? isLogin = await WeClient.getInstance.isLogin();
    String cacheToken = SpUtil.getString(Constant.KEY_TOKEN);
    Log.e("isLogin:${isLogin},cacheToken:${cacheToken}");
    if (isLogin == true && cacheToken.isNotEmpty) {
      String? token = await WeClient.getInstance.open();
      if (token?.isNotEmpty == true) {
        gotoConversationPage(context);
      }
    }
  }
}
