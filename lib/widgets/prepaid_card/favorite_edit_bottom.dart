
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/res/images_res.dart';

import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../models/prepaid/res/union_pay_template_model.dart';
import '../../pages/prepaid_card/prepaid_create_template/prepaid_create_template_logic.dart';
import '../../pages/prepaid_card/prepaid_create_template/prepaid_create_template_state.dart';
import '../../utils/screen_util.dart';
import '../app_input_textfield.dart';
import '../common.dart';
import 'form_common.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/17 21:53
/// @Description:
/// /////////////////////////////////////////////

class FavoriteEditBottom extends StatefulWidget {
  final UnionPayTemplateModel? templateModel;
  final int? transferType; //转账类型 0-转入bongloy卡号  1-转入bongloy账户  2-转入我的账户
  const FavoriteEditBottom({super.key, this.templateModel, this.transferType});

  @override
  State<FavoriteEditBottom> createState() => _FavoriteEditBottomState();
}

class _FavoriteEditBottomState extends State<FavoriteEditBottom> {
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
    return GetBuilder(
        init: logic,
        builder: (viewModel) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: ScreenUtil.screenWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildCardBottomTitle(S.of(context).edit_favorite,
                      onTap: () => context.popRoute()),
                  Gaps.vGap30,
                  AppTextInput(
                    controller: logic.nameController,
                    focusNode: logic.nameFocusNode,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    hint: S.of(context).favorite_name, inputFormatters: [],
                  ),
                  Gaps.vGap20,
                  AppTextInput(
                    // isError: state.idNumberError != null,
                    // errorText: state.idNumberError,
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
                    // keyboardType: TextInputType.phone,
                  ),
                  Gaps.vGap20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      btnWithLoading2(
                          isLoading: state.isLoading.value,
                          title: S.current.save,
                          onTap: () {
                            logic.saveTemplate();
                          }),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
