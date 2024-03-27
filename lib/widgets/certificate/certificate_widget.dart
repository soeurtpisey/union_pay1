import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../app/base/app.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../models/image_model.dart';
import '../../packages/mrz_parse/src/mrz_result.dart';
import '../../utils/dimen.dart';
import '../../utils/image_util.dart';
import '../../utils/screen_util.dart';
import '../../utils/view_util.dart';
import '../common.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/2 12:18
/// @Description: 证件照选择
/// /////////////////////////////////////////////

class SelectCertificate {
  final String? label;
  int? index;
  File? file;
  double? width;
  double? height;
  String? base64Image;
  final VoidCallback? unFocus;
  final String? defaultIcon;
  final ValueChanged<ImgModel>? onResult;
  final ValueChanged<ImgModel>? onClear;
  final Function(MRZResult mrzResult, ImgModel imageModel)? onMrzResult;

  SelectCertificate(
      {this.label,
      this.file,
      this.defaultIcon,
      this.index = 0,
      this.width = 94,
      this.height = 94,
      this.base64Image,
      this.unFocus,
      this.onClear,
      this.onMrzResult,
      this.onResult});
}

GlobalKey<_CertificateWidgetState> certificateWidget = GlobalKey();

class CertificateWidget extends StatefulWidget {
  final List<SelectCertificate> children;
  final double? childAspectRatio;
  final int? crossAxisCount;

  const CertificateWidget(
      {Key? key,
      required this.children,
      this.childAspectRatio = 0.7,
      this.crossAxisCount})
      : super(key: key);

  @override
  State<CertificateWidget> createState() => _CertificateWidgetState();
}

class _CertificateWidgetState extends State<CertificateWidget> {
  var list = <SelectCertificate>[];

  void removeFile(int index) {
    var item = list[index];
    item.file = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      list.addAll(widget.children);
    }else{
      var b=list.first.base64Image;
      var a=widget.children.first.base64Image;
      if(b==null&&a!=null){
        list.clear();
        list.addAll(widget.children);
      }
    }
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: widget.childAspectRatio!,
            crossAxisCount: widget.crossAxisCount ?? 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          var item = list[index];
          return _buildItem(item);
        },
        itemCount: list.length);
  }

  Uint8List base64Decode(String source) => base64.decode(source);

  Widget _buildItem(SelectCertificate item) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: item.height!,
              width: item.width!,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  border: item.defaultIcon == null
                      ? null
                      : Border.all(color: AppColors.color79747E, width: 0.5),
                  color: item.defaultIcon == null
                      ? AppColors.colorF5F5F5
                      : Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.gap_dp8)),
              child: item.base64Image != null
                  ? Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.gap_dp8)),
                      child: Image.memory(
                        base64Decode(item.base64Image ?? ''),
                        gaplessPlayback: true, //无缝播放，防止闪烁
                        fit: BoxFit.cover,
                      ),
                    )
                  : item.file != null
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimens.gap_dp8)),
                          child: Image.file(
                            item.file!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: ClipOval(
                            child: Container(
                              width: 24,
                              height: 24,
                              color: Colors.white,
                              child: item.defaultIcon == null
                                  ? const Icon(
                                      Icons.add,
                                      size: 15,
                                      color: AppColors.colorD3D3D3,
                                    )
                                  : item.defaultIcon!.UIImage(),
                            ),
                          ),
                        ),
            ).paddingSymmetric(horizontal: 5, vertical: 5),
            if (item.file != null && item.defaultIcon != null||item.base64Image!=null)
              Positioned(
                  top: 0,
                  right: 0,
                  child: ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      color: AppColors.colorAEA9B1,
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ))
          ],
        ).onClick(() async {
          if (item.file != null) {
            item.file = null;
            item.onClear?.call(ImgModel());
            setState(() {});
            return;
          }
          if(item.base64Image!=null){
            item.base64Image = null;
            item.onClear?.call(ImgModel());
            setState(() {});
            return;
          }
          item.unFocus?.call();
          await showSheet(
              context,
              Container(
                width: ScreenUtil.screenWidth,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.index == 0)
                      InkWell(
                          onTap: () async {
                            /// warning
                            // await context.popRoute();
                            // await context.router.push(MrzScanPageRoute(
                            //     onSuccess: (MRZResult result) async {
                            //   var imgModel =
                            //       await ImageUtil.getImageModel(result.file!);
                            //   item.onMrzResult?.call(result, imgModel);
                            //   item.file = result.file!;
                            //   setState(() {});
                            // }));
                          },
                          child: Container(
                            width: ScreenUtil.screenWidth,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: cText(S.of(context).navbar_scan),
                          )),
                    if (item.index == 0) Divider(),
                    InkWell(
                        onTap: () {
                          goTakePhoto(item);
                        },
                        child: Container(
                          width: ScreenUtil.screenWidth,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: cText(S.of(context).kyc_field_hint_selfie_photo),
                        )),
                    Divider(),
                    InkWell(
                        onTap: () {
                          goAlbum(item);
                        },
                        child: Container(
                          width: ScreenUtil.screenWidth,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: cText(S.of(context).album),
                        )),
                    Divider(),
                    InkWell(
                        onTap: () {
                          context.popRoute();
                        },
                        child: Container(
                          width: ScreenUtil.screenWidth,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: cText(S.of(context).cancel),
                        )),
                  ],
                ),
              ));
        }),
        Gaps.vGap10,
        cText(item.label ?? '', color: AppColors.color1B1C1E, fontSize: 12)
      ],
    );
  }

  Future<void> goAlbum(SelectCertificate item) async {
    Navigator.pop(context);
    var textDelegate = const AssetPickerTextDelegate();
    if (App.language == 'en') {
      textDelegate = const EnglishAssetPickerTextDelegate();
    }
    final result = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
            requestType: RequestType.image,
            maxAssets: 1,
            textDelegate: textDelegate));
    if (result?.isNotEmpty == true) {
      var details = result![0];
      item.file = await details.originFile;
      item.onResult?.call(ImgModel(
          height: details.height,
          width: details.width,
          type: -2,
          locPath: item.file?.path));
      setState(() {});
    }
  }

  Future<void> goTakePhoto(SelectCertificate item) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    // Capture a photo
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      var file = File(photo.path);
      var imageModel = await ImageUtil.getImageModel(file);
      item.file = await file;
      item.onResult?.call(imageModel);
      setState(() {});
    }
  }
}
