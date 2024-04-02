// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pinput/pinput.dart';
//
// class PasscodePage extends StatefulWidget {
//   final ValueChanged<String> onSuccess;
//   final VoidCallback? onClose;
//   final bool isShowBioButton;
//   final Color? backgroundColor;
//
//   const PasscodePage(
//       {Key? key,
//       required this.onSuccess,
//       required this.onClose,
//       required this.isShowBioButton,
//       this.backgroundColor})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _PasscodePageState();
// }
//
// class _PasscodePageState extends State<PasscodePage> {
//   var currentPin = '';
//   var totalPinFailure = 4;
//   var remainPinError = 4;
//   var action = [1, 2, 3, 4, 5, 6, 7, 8, 9, -1, 0, -2];
//   final TextEditingController _pinPutController = TextEditingController();
//   late UnlockappBloc unlockAppBloc;
//   LocalAuthRepository? _localAuthRepository;
//   List<BiometricType>? availableBiometrics;
//   LocalAuthentication? _auth;
//   bool isDeviceSupportFaceId = false;
//   bool canCheckBiometrics = false;
//
//   @override
//   void initState() {
//     unlockAppBloc = UnlockappBloc(userRepository: Application.userRepository);
//     checkBiometric();
//
//     /// check if bio available
//     super.initState();
//     Application.onLimitNumberOfPin = showDeactivatedDialog;
//     BioUtil.getInstance().check(context, (value) {
//       unlockAppBloc.add(UnlockappPinEntered(pin: value));
//     });
//   }
//
//   @override
//   void dispose() {
//     unlockAppBloc.close();
//     super.dispose();
//   }
//
//   void showDeactivatedDialog() {
//     DeviceDeactivetedDialog(context);
//   }
//
//   void checkBiometric() async {
//     _auth = LocalAuthentication();
//     _localAuthRepository = LocalAuthRepository();
//     if (_auth == null) {
//       return;
//     }
//     try {
//       canCheckBiometrics = await _auth!.canCheckBiometrics;
//     } on PlatformException catch (_) {
//       return;
//     }
//
//     availableBiometrics = await LocalAuthUtil.getAvailableBiometrics();
//     isDeviceSupportFaceId = await BioUtil.getInstance().isSupportFaceId();
//     setState(() {}); // reload UI
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 14,
//       height: 14,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: AppColors.colorD9D9D9.withOpacity(0.4)),
//     );
//
//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: Colours.color_ddd),
//       borderRadius: BorderRadius.circular(8),
//     );
//
//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         border: Border.all(width: 0, color: Colors.transparent),
//         color: Colours.red_e60013,
//       ),
//     );
//     var radio = ScreenUtil.radio;
//     return WillPopScope(
//       onWillPop: () {
//         return Future.value(true);
//       },
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           backgroundColor:
//               widget.backgroundColor ?? Color.fromRGBO(0, 0, 0, 0.6),
//           body: Stack(
//             children: [
//               Column(
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: SingleChildScrollView(
//                         child: BlocListener(
//                           bloc: unlockAppBloc,
//                           listener:
//                               (BuildContext context, UnlockappState state) {
//                             if (state is UnlockappFailure) {
//                               currentPin = '';
//                               _pinPutController.text = '';
//                               final onk = state.exception as ApiException;
//                               final amountOfFailure =
//                                   int.tryParse(onk.message ?? '');
//
//                               if (amountOfFailure != null) {
//                                 setState(() {
//                                   remainPinError =
//                                       totalPinFailure - amountOfFailure;
//                                   if (remainPinError < 0) {
//                                     remainPinError = 0;
//                                   }
//                                 });
//                               }
//                             }
//                             if (state is UnlockappSuccess) {
//                               Navigator.of(context).pop();
//                               widget.onSuccess.call(state.pin);
//                               _pinPutController.text = '';
//                             }
//                           },
//                           child: BlocBuilder(
//                             bloc: unlockAppBloc,
//                             builder:
//                                 (BuildContext context, UnlockappState state) {
//                               if (state is UnlockappLoading) {
//                                 return Container(
//                                   alignment: Alignment.center,
//                                   height: ScreenUtil.screenHeight -
//                                       ScreenUtil.navigationBarHeight,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       CircularProgressIndicator(
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                                   AppColors.primaryColor)),
//                                     ],
//                                   ),
//                                 );
//                               }
//                               return Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 15),
//                                 child: Column(
//                                   children: [
//                                     Gaps.vGap8,
//                                     AssetsRes.PASSCODE_LOCK_IC.UIImage(
//                                         width: 40.0.px, height: 40.0.px),
//                                     Gaps.vGap30,
//                                     cText(
//                                         S.of(context).enter_pin_code_to_confirm,
//                                         textAlign: TextAlign.center,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 17),
//                                     Gaps.vGap40,
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: (MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   (50 +
//                                                       (28 *
//                                                           Application
//                                                               .getNumberOfPin()))) /
//                                               2),
//                                       child: Pinput(
//                                         length: Application.getNumberOfPin(),
//                                         defaultPinTheme: defaultPinTheme,
//                                         focusedPinTheme: focusedPinTheme,
//                                         submittedPinTheme: submittedPinTheme,
//                                         pinputAutovalidateMode:
//                                             PinputAutovalidateMode.onSubmit,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         showCursor: true,
//                                         obscureText: true,
//                                         controller: _pinPutController,
//                                         autofocus: false,
//                                         readOnly: true,
//                                         obscuringCharacter: ' ',
//                                         onCompleted: pinProvided,
//                                       ),
//                                     ),
//                                     Gaps.vGap30,
//                                     Visibility(
//                                       visible: (state is UnlockappFailure ||
//                                           state is UnlockappDeviceDeactivated),
//                                       child: Container(
//                                         padding: EdgeInsets.only(
//                                             left: 5,
//                                             right: 5,
//                                             top: 3,
//                                             bottom: 3),
//                                         decoration: BoxDecoration(
//                                             color:
//                                                 Colors.white.withOpacity(0.1),
//                                             borderRadius:
//                                                 BorderRadius.circular(20)),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             AssetsRes.PIN_VERIFY_FAILED_IC
//                                                 .UIImage(width: 24, height: 24),
//                                             cText(
//                                                 remainPinError <= 0
//                                                     ? S().verification_pin_error
//                                                     : S().verification_pin_error +
//                                                         ' ' +
//                                                         S().number_pin_remain(
//                                                             remainPinError),
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: AppColors.colorF82121)
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Gaps.vGap30,
//                                     Container(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 40),
//                                       child: GridView.builder(
//                                           itemCount: action.length,
//                                           shrinkWrap: true,
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           padding: radio < 1.5
//                                               ? EdgeInsets.symmetric(
//                                                   horizontal:
//                                                       ScreenUtil.screenWidth /
//                                                           4)
//                                               : EdgeInsets.zero,
//                                           gridDelegate:
//                                               SliverGridDelegateWithFixedCrossAxisCount(
//                                                   crossAxisCount: 3,
//                                                   childAspectRatio: 1,
//                                                   crossAxisSpacing: 30,
//                                                   mainAxisSpacing: 15.0.px),
//                                           itemBuilder: (context, index) {
//                                             return buildInk(
//                                               action,
//                                               index,
//                                             );
//                                           }),
//                                     ),
//                                     Gaps.vGap20,
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 top: 55,
//                 left: 0,
//                 child: InkWell(
//                     child: Padding(
//                         padding: EdgeInsets.only(left: 25),
//                         child: cText(S().cancelButton,
//                             textAlign: TextAlign.start,
//                             fontSize: 16,
//                             color: Colors.white)),
//                     onTap: () {
//                       if (widget.onClose != null) {
//                         widget.onClose!();
//                       }
//                       Navigator.of(context).pop();
//                     }),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// check condition to display biometric button
//   Widget buildBioButton() {
//     if (canCheckBiometrics && _localAuthRepository?.hasAuthEnabled() == true) {
//       /// ios device
//       if (Platform.isIOS &&
//               availableBiometrics?.contains(BiometricType.face) == true ||
//           isDeviceSupportFaceId == true) {
//         /// Face ID
//         return AssetsRes.RESET_FACE_SCAN_IC.UIImage();
//       } else if (Platform.isIOS) {
//         /// Finger print
//         return AssetsRes.RESET_FINGER_PRINT_IC.UIImage();
//       }
//
//       /// android device
//       if (Platform.isAndroid &&
//           availableBiometrics?.contains(BiometricType.face) == true) {
//         /// Face ID
//         return AssetsRes.RESET_FACE_SCAN_IC.UIImage();
//       } else if (Platform.isAndroid) {
//         /// Face ID
//         return AssetsRes.RESET_FINGER_PRINT_IC.UIImage();
//       }
//     }
//     return cText('C',
//         fontWeight: FontWeight.w400, color: Colors.white, fontSize: 36);
//   }
//
//   /// build action list
//   Widget buildInk(List<int> actions, int index) {
//     Widget actionBtn;
//     var action = actions[index];
//     var bgColor = AppColors.colorE5E5E5.withOpacity(0.3);
//     if (action == -1) {
//       if (widget.isShowBioButton) {
//         actionBtn = buildBioButton();
//       } else {
//         actionBtn = Container();
//       }
//       bgColor = Colors.transparent;
//     } else if (action == -2) {
//       actionBtn = AssetsRes.INPUT_PIN_DELETE_IC.UIImage();
//       bgColor = Colors.transparent;
//     } else {
//       actionBtn = cText(action.toString(),
//           fontWeight: FontWeight.w500, color: Colors.white, fontSize: 32);
//     }
//
//     return Ink(
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//         child: InkResponse(
//             onTap: () {
//               if (action == -1) {
//                 /// on tap biometric button or reset button
//                 /// show bio auth if exist
//                 if (widget.isShowBioButton) {
//                   currentPin = '';
//                   if ((availableBiometrics?.contains(BiometricType.face) ==
//                           true) ||
//                       (availableBiometrics
//                               ?.contains(BiometricType.fingerprint) ==
//                           true)) {
//                     BioUtil.getInstance().check(context, (value) {
//                       unlockAppBloc.add(UnlockappPinEntered(pin: value));
//                     });
//                   }
//                 }
//               } else if (action == -2) {
//                 /// on tap delete pin
//                 if (currentPin.isNotEmpty) {
//                   currentPin = currentPin.substring(0, currentPin.length - 1);
//                 }
//               } else {
//                 /// on tap number
//                 if (currentPin.length < 6) {
//                   currentPin = currentPin + action.toString();
//                 }
//               }
//
//               _pinPutController.text = currentPin;
//             },
//             //点击或者toch控件高亮时显示的颜色在控件上层,水波纹下层
//             highlightColor: Colors.transparent,
//             //点击或者touch控件高亮的shape形状
//             highlightShape: BoxShape.rectangle,
//             //shape圆角半径
//             borderRadius: BorderRadius.circular(50.0),
//             radius: 150.0,
//             //ripple水波纹半径
//             //true表示要裁剪水波纹响应的边界,false就是不裁剪
//             //如果控件是圆角的,不裁剪的话,水波纹出来的最终填充出来的效果是矩形
//             containedInkWell: true,
//             //水波纹颜色
//             splashColor: (action == -1 && !widget.isShowBioButton)
//                 ? Colors.transparent
//                 : Colors.black12,
//             child: Container(
//               decoration: BoxDecoration(
//                   // color: Colours.gray_f5,
//                   shape: BoxShape.circle),
//               alignment: Alignment.center,
//               child: actionBtn,
//             )));
//   }
//
//   void pinProvided(String code) {
//     if (code.isNotEmpty == true) {
//       unlockAppBloc?.add(UnlockappPinEntered(
//         pin: code,
//       ));
//     }
//   }
// }
