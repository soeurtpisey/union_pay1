
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/res/union_pay_template_model.dart';
import '../../../utils/custom_decoration.dart';
import '../../../widgets/app_input_textfield.dart';
import '../../../widgets/common.dart';
import 'prepaid_create_template_logic.dart';
import 'prepaid_create_template_state.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/14 14:10
/// @Description: 模版创建
/// /////////////////////////////////////////////
class PrepaidCreateTemplatePage extends StatefulWidget {
  final int? transferType; //转账类型 0-转入bongloy卡号  1-转入bongloy账户  2-转入我的账户
  final UnionPayTemplateModel? templateModel;
  const PrepaidCreateTemplatePage(
      {Key? key, this.transferType, this.templateModel})
      : super(key: key);
  @override
  _PrepaidCreateTemplateState createState() => _PrepaidCreateTemplateState();
}

class _PrepaidCreateTemplateState extends State<PrepaidCreateTemplatePage> {

  late PrepaidCreateTemplateLogic logic;
  late PrepaidCreateTemplateState state;

  @override
  void initState() {
    super.initState();
    //如果有模版则是模版的类型
    logic = Get.put(PrepaidCreateTemplateLogic(
        templateModel: widget.templateModel,
        transferType: widget.templateModel?.keyIdType ?? widget.transferType));
    state = Get.find<PrepaidCreateTemplateLogic>().state;
  }

  @override
  void dispose() {
    Get.delete<PrepaidCreateTemplateLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(
        context,
        backgroundColor: AppColors.colorE9EBF5,
        appBarBgColor: AppColors.colorE9EBF5,
        widget.templateModel != null
            ? S.current.modify_template
            : S.of(context).create_favorite,
        child: Column(children: [
          Column(
            children: [
              AppTextInput(
                controller: logic.nameController,
                focusNode: logic.nameFocusNode,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                hint: S.of(context).favorite_name,
              ),
              Gaps.vGap20,
              AppTextInput(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                onTextChanged: (text) {
                  // logic.checkErrorStyle(idCard: text);
                },
                enabled: state.templateModel == null,
                controller: logic.cardNumController,
                focusNode: logic.cardNumFocusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                keyboardType: TextInputType.number,
                prefixIcon: ImagesRes.IC_PREPAID_UNIONPAY_BIG
                    .UIImage()
                    .paddingOnly(left: 20)
                    .marginOnly(right: 10),
                hint: S.of(context).receiver_card_name,
              ),
            ],
          ).intoContainer(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              width: double.infinity,
              decoration: normalDecoration(color: Colors.white,circular: 16)),
          Obx(() => Container(
              margin: const EdgeInsets.only(top: 50),
              child: btnWithLoading(
                  title: S.current.save,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  isLoading: state.isLoading.value,
                  onTap: () {
                    logic.saveTemplate();
                  }))),
        ]).intoContainer(margin: const EdgeInsets.symmetric(horizontal: 15)));
  }
}
