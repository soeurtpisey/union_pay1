
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/helper/colors.dart';

import '../../generated/l10n.dart';
import '../../models/region/region_item_model.dart';
import '../../utils/screen_util.dart';
import '../common.dart';
import '../custom_text_field.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/13 10:01
/// @Description:
/// /////////////////////////////////////////////

class AddressSelect extends StatefulWidget {
  final List<RegionItemModel> regions;
  final ValueChanged<RegionItemModel> onResult;

  const AddressSelect(
      {super.key, required this.regions, required this.onResult});

  @override
  State<AddressSelect> createState() => _AddressSelectState();
}

class _AddressSelectState extends State<AddressSelect> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late List<RegionItemModel> suggestList;
  late List<RegionItemModel> list;

  @override
  void initState() {
    super.initState();
    suggestList = List.from(widget.regions);
    list = List.from(widget.regions);
  }

  Widget _buildSearch() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              context.popRoute();
            },
            icon: Icon(Icons.close)),
        CustomTextFiled(
          controller: _searchController,
          fillColor: AppColors.colorF7F7F7,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            filterList(value);
          },
          hintText: S().search,
        ).intoExpend()
      ],
    );
  }

  void filterList(String value) {
    if (value.isNotEmpty) {
      list.clear();
      suggestList.where((element) {
        var name = element.item?.toLowerCase();

        return name?.contains(value.toLowerCase()) ?? false;
      }).forEach((element) {
        list.add(element);
      });
    } else {
      list.addAll(suggestList);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // buildBottomTitle(context, '', margin: EdgeInsets.zero),
        _buildSearch(),
        _buildList()
      ],
    );
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
                cText(model.item ?? '',
                    textAlign: TextAlign.start,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)
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
