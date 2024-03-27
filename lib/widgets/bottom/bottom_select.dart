import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/helper/colors.dart';
import '../../app/base/app.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../models/certificate_type.dart';
import '../../utils/screen_util.dart';
import '../common.dart';
import '../country_selection/code_country.dart';
import '../custom_text_field.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/2/23 15:56
/// @Description:
/// /////////////////////////////////////////////

class NationalSelect extends StatefulWidget {
  final List<CountryCode> regions;
  final ValueChanged<CountryCode> onResult;

  const NationalSelect(
      {Key? key, required this.regions, required this.onResult})
      : super(key: key);

  @override
  State<NationalSelect> createState() => _NationalSelectState();
}

class _NationalSelectState extends State<NationalSelect> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late List<CountryCode> suggestList;
  late List<CountryCode> list;

  @override
  void initState() {
    super.initState();
    suggestList = List.from(widget.regions);
    list = List.from(widget.regions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildSearch(),
        _buildList()
      ],
    );
  }

  Widget buildSearch() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              context.popRoute();
            },
            icon: const Icon(Icons.close)),
        CustomTextFiled(
          controller: _searchController,
          fillColor: AppColors.colorF7F7F7,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            filterList(value);
          },
          hintText: S.of(context).search,
        ).intoExpend()
      ],
    );
  }

  void filterList(String value) {
    if (value.isNotEmpty) {
      list.clear();
      suggestList.where((element) {
        var name = element.displayName().toLowerCase();
        var code = element.code?.toLowerCase();
        var dialCode = element.dialCode?.toLowerCase();
        return name.contains(value) ||
            code?.contains(value) == true ||
            dialCode?.contains(value) == true;
      }).forEach((element) {
        list.add(element);
      });
    } else {
      list.addAll(suggestList);
    }
    setState(() {});
  }

  Widget _buildList() {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          var model = list[index];
          return Container(
            width: ScreenUtil.screenWidth,
            height: 50,
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.1, color: Colors.grey)),
            ),
            child: Row(
              children: [
                cText(model.flagUri ?? '', textAlign: TextAlign.start),
                Gaps.hGap10,
                cText('${model.displayName()} ${model.dialCode}',
                        textAlign: TextAlign.start,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)
                    .intoExpend(),
              ],
            ),
          ).onClick(() {
            widget.onResult.call(model);
            Navigator.pop(context);
          });
        },
        itemCount: list.length,
      ),
    );
  }
}

class DocSelect extends StatefulWidget {
  final List<CertificateType> idItems;
  final ValueChanged<CertificateType> onResult;

  const DocSelect({Key? key, required this.idItems, required this.onResult})
      : super(key: key);

  @override
  State<DocSelect> createState() => _DocSelectState();
}

class _DocSelectState extends State<DocSelect> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildBottomTitle(context, ''), _buildList()],
    );
  }

  Container buildBottomTitle(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 19),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: cText(
              '',
              fontSize: 18,
              color: AppColors.color1E1F20,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
            ),
          ),
          Gaps.hGap5,
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              color: AppColors.color666666,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var model = widget.idItems[index];
          return Container(
            width: ScreenUtil.screenWidth,
            height: 50,
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.1, color: Colors.grey)),
            ),
            child: Center(
              child: cText(model.label,
                  textAlign: TextAlign.start,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ).onClick(() {
            widget.onResult.call(model);
            Navigator.pop(context);
          });
        },
        itemCount: widget.idItems.length,
      ),
    );
  }
}

class SendWalletIdPage extends StatelessWidget {
  // 如果使用 Get
  // static Future<T?>? show<T>() {
  //   return Get.to(() => SendCommentPage(),
  //       opaque: false,
  //       preventDuplicates: false,
  //       duration: const Duration(microseconds: 0),
  //       fullscreenDialog: true);
  // }

  static Future<T?> show2<T>(BuildContext context) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        // 关键
        opaque: false,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SendWalletIdPage();
        },
      ),
    );
  }

  SendWalletIdPage({super.key});

  final focusNode = FocusNode();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 加个小延迟
    Timer(const Duration(milliseconds: 50), (() {
      focusNode.requestFocus();
    }));

    return Scaffold(
        // 关键
        backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //撑起上部分
            Expanded(child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // Get.back();
              },
            )),
            Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                  cursorColor: Colors.black,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '输入walletId',
                  ),
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 1,
                )),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 8),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      if(controller.text.isNotEmpty) {
                        Navigator.pop(context, controller.text);
                      }else{
                        Navigator.pop(context,App.userSession?.walletId);
                      }
                      // Get.back(result: controller.text);
                    },
                    child: const Text("确定"))),
          ],
        ));
  }
}
