
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../../../generated/l10n.dart';
import '../../../utils/custom_decoration.dart';
import '../../../widgets/common.dart';
import 'apply_record_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/28 10:11
/// @Description: 申请记录
/// /////////////////////////////////////////////

class ApplyRecordPage extends StatefulWidget {
  const ApplyRecordPage({Key? key}) : super(key: key);

  @override
  _ApplyRecordPageState createState() => _ApplyRecordPageState();
}

class _ApplyRecordPageState extends State<ApplyRecordPage> {
  final logic = Get.put(ApplyRecordLogic());
  final state = Get.find<ApplyRecordLogic>().state;

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.current.apply_record,
        child: GetBuilder(
            init: logic,
            builder: (controller) {
              return ListView.builder(
                  itemCount: state.applyList.length,
                  itemBuilder: (context, index) {
                    var data = state.applyList[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cText(S.current.card_name_apply(data.cardTypeTitle())),
                        cText(S.current.apply_status(data.applyStatus())),
                        cText(S.current.apply_time(data.createTime ?? '')),
                      ],
                    ).intoContainer(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        margin:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: normalDecoration(color: Colors.white));
                  });
            }));
  }

  @override
  void dispose() {
    Get.delete<ApplyRecordLogic>();
    super.dispose();
  }
}
