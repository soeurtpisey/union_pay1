import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../utils/view_util.dart';
import '../../../widgets/common.dart';
import '../../../widgets/page_loading_indicator.dart';
import 'prepaid_cvv_logic.dart';

class PrepaidCvvPage extends StatefulWidget {
  final UnionPayCardResModel unionPayCardResModel;
  const PrepaidCvvPage({Key? key, required this.unionPayCardResModel})
      : super(key: key);

  @override
  _PrepaidCvvPageState createState() => _PrepaidCvvPageState();
}

class _PrepaidCvvPageState extends State<PrepaidCvvPage> {
  final logic = Get.put(PrepaidCvvLogic());
  final state = Get.find<PrepaidCvvLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.getCVV(widget.unionPayCardResModel.id);
  }

  @override
  Widget build(BuildContext context) {
    // var isSet = widget.unionPayCardResModel.cvn2 == null;
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: buildBottomDefaultContainer(
          height: 280,
          color: Colors.white,
          child: Column(
            children: [
              buildBottomTitle(context, S.current.show_cvv),
              Gaps.vGap20,
              Obx(() => state.isLoading.value
                  ? PageLoadingIndicator()
                  : Column(mainAxisSize: MainAxisSize.min, children: [
                      cText(state.cvn2.value,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.color151736),
                      cText(S.current.can_talk_cvv_to_other),
                    ])),
              const Spacer(),
              Gaps.vGap30,
            ],
          ),
        ));
  }

  @override
  void dispose() {
    Get.delete<PrepaidCvvLogic>();
    super.dispose();
  }
}
