
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/helper/colors.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/common.dart';
import 'select_date_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/15 11:01
/// @Description: 时间选择
/// /////////////////////////////////////////////
///
typedef SelectTime = Function(String timeType, DateTime time);

class SelectDatePage extends StatefulWidget {
  final String? filterType;
  final SelectTime? selectTime;
  final DateTime? selectDate;
  const SelectDatePage(
      {Key? key, this.selectTime, this.selectDate, this.filterType})
      : super(key: key);

  @override
  _SelectDatePageState createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(SelectDateLogic());
  final state = Get.find<SelectDateLogic>().state;
  late TabController controller;
  List<String> modeList = ['yyyy-MM'];
  int selectIndex = 0;
  late DateTime selectDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectDate = widget.selectDate ?? DateTime.now();
    selectIndex = modeList.indexOf(widget.filterType ?? 'yyyy-MM-d');
    controller = TabController(
        initialIndex: selectIndex, length: modeList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: controller,
            // indicatorSize: TabBarIndicatorSize.label,
            // indicatorColor: Colours.color_ffff3e47,
            onTap: (index) {
              selectIndex = index;
              setState(() {});
            },
            tabs: [
              // cText(S.current.display_of_the_year,
              //         fontSize: 16,
              //         color: Colors.black,
              //         fontWeight: FontWeight.w600)
              //     .intoContainer(height: 50, alignment: Alignment.center),
              cText(
                      S.current
                          .select_the_query_start_time, //S.current.display_of_the_month,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)
                  .intoContainer(height: 50, alignment: Alignment.center),
              // cText(S.current.display_of_the_day,
              //         fontSize: 16,
              //         color: Colors.black,
              //         fontWeight: FontWeight.w600)
              //     .intoContainer(height: 50, alignment: Alignment.center),
            ],
          ),
          /// warning
          // DatePickerWidget(
          //   pickerTheme: DateTimePickerTheme(showTitle: false),
          //   onMonthChangeStartWithFirstDate: true,
          //   dateFormat: modeList[selectIndex],
          //   initialDateTime:
          //       widget.selectDate, //DateUtil.getDateTimeByMs(selectDate),
          //   maxDateTime: DateTime.now(),
          //   onChange: (dateTime, list) {
          //     selectDate = dateTime;
          //     // print(DateUtil.formatDate(dateTime));
          //   },
          // ),
          btnWithLoading(
              title: S.current.confirm,
              onTap: () {
                widget.selectTime?.call(modeList[selectIndex], selectDate);
                Navigator.of(context).pop();
              }),
          cText(S.current.cancel,
                  color: AppColors.color1E1F20,
                  fontWeight: FontWeight.w500,
                  fontSize: 16)
              .intoContainer(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 20))
              .onClick(() {
            Navigator.of(context).pop();
          })
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SelectDateLogic>();
    super.dispose();
  }
}
