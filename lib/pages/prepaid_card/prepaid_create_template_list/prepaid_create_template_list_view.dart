import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/double_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../../../generated/l10n.dart';
import '../../../utils/custom_decoration.dart';
import '../../../widgets/common.dart';
import '../../../widgets/prepaid_card/form_common.dart';
import 'prepaid_create_template_list_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/14 15:48
/// @Description: 模版创建列表
/// /////////////////////////////////////////////
class PrepaidCreateTemplateListPage extends StatefulWidget {
  @override
  _PrepaidCreateTemplateListPageState createState() =>
      _PrepaidCreateTemplateListPageState();
}

class _PrepaidCreateTemplateListPageState
    extends State<PrepaidCreateTemplateListPage> {
  final logic = Get.put(PrepaidCreateTemplateListLogic());
  final state = Get.find<PrepaidCreateTemplateListLogic>().state;

  @override
  void dispose() {
    Get.delete<PrepaidCreateTemplateListLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.of(context).prepaid_card_create_template,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            arrowUnderLineItem(S.current.transfer_to_bongloy_card, onTap: () {
              /// warning
              // context.router.push(PrepaidCreateTemplatePageRoute(
              //     transferType: UnionCardTransferType.toBonglogCard.value));
            }, needUnderLine: false),
          ],
        ).intoContainer(
            margin: EdgeInsets.symmetric(horizontal: 15.0.px),
            decoration: normalDecoration(color: Colors.white)));
  }
}
