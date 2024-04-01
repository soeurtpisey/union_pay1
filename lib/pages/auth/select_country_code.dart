
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../utils/screen_util.dart';
import '../../widgets/common.dart';
import '../../widgets/country_selection/code_country.dart';
import '../../widgets/custom_text_field.dart';


class SelectCountryPage extends StatefulWidget {
  final List<CountryCode> regions;
  final ValueChanged<CountryCode> onResult;

  const SelectCountryPage(
      {Key? key, required this.regions, required this.onResult})
      : super(key: key);

  @override
  State<SelectCountryPage> createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
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
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 12),
            child: Stack(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: cText(S().cancel, color: AppColors.primaryColor, fontSize: 15)
                ),
                Center(
                  child: cText(S().select_country_code,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      color: Colors.black),
                )
              ],
            ),
          ),
          Row(
            children: [
              CustomTextFiled(
                controller: _searchController,
                fillColor: AppColors.colorF7F7F7,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  filterList(value);
                },
                hintText: S().search_country_code_hint,
                hintColor: AppColors.color3C3C43.withOpacity(0.6),
                hintFontSize: 15,
              ).intoExpend()
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  var model = list[index];
                  return Container(
                    width: ScreenUtil.screenWidth,
                    // height: 52,
                    decoration:const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 0.1, color: Colors.grey)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cText(model.flagUri ?? '',
                                textAlign: TextAlign.start, fontSize: 40),
                            Gaps.hGap10,
                            cText('${model.dialCode} • ${model.displayName()}',
                                textAlign: TextAlign.start,
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)
                                .intoExpend(),
                          ],
                        ),
                      ],
                    ),
                  ).onClick(() {
                    widget.onResult.call(model);
                    Navigator.pop(context);
                  });
                },
                itemCount: list.length,
              ))
        ],
      ),
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
}
