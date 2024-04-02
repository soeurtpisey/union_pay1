import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BioUtil {
  // LocalAuthentication? _auth;
  // LocalAuthRepository? _localAuthRepository;
  // late UnlockappBloc _unlockAppBloc;
  late FocusNode _pinPutFocusNode;
  late TextEditingController _pinPutController;
  static final BioUtil _instance = BioUtil._internal();
  factory BioUtil() => _instance;

  BioUtil._internal() {
    _pinPutFocusNode = FocusNode();
    _pinPutController = TextEditingController();
  }

  static BioUtil getInstance() {
    return _instance;
  }

  void showPasscodeModal(BuildContext context, String amount, String account,
      ValueChanged<String> onSuccess,
      {VoidCallback? onClose, Color? backgroundColor}) async {
    /// warning
    var isPassConfidentialWordVerify;
    // if (Application.confidentialWord?.isOpen ?? false) {
    //   if (account == 'USD') {
    //     if (double.parse(amount) >
    //         (Application.confidentialWord?.quotaBo?.usd ?? 0).toDouble()) {
    //       isPassConfidentialWordVerify = await context.router.push(
    //           VerifyConfidentialWordPageRoute(
    //               verifyType: VerifyConfidentialType.PAY));
    //     }
    //   }
    // } else {
    //   isPassConfidentialWordVerify = true;
    // }
    // if (isPassConfidentialWordVerify != null && !isPassConfidentialWordVerify) {
    //   return;
    // }
    // await showDialog(
    //     context: context,
    //     useSafeArea: false,
    //     builder: (buildContext) => PasscodePage(backgroundColor: backgroundColor, onSuccess: onSuccess, onClose: onClose, isShowBioButton: true));
  }

}