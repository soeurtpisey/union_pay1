
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:union_pay/pages/prepaid_card/prepaid_activate_form/prepaid_activate_form_state.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../utils/dimen.dart';
import '../../../widgets/app_input_textfield.dart';
import '../../../widgets/common.dart';
import '../../../widgets/prepaid_card/form_common.dart';
import 'prepaid_activate_form_logic.dart';
import 'dart:convert';


/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/13 13:54
/// @Description: 激活表单
/// /////////////////////////////////////////////

class PrepaidActivateFormPage extends StatefulWidget {
  final UnionPayCardResModel model;
  const PrepaidActivateFormPage({Key? key, required this.model})
      : super(key: key);

  @override
  State<PrepaidActivateFormPage> createState() =>
      _PrepaidActivateFormPageState();
}

class _PrepaidActivateFormPageState extends State<PrepaidActivateFormPage> {
  late PrepaidActivateFormLogic logic;
  late PrepaidActivateFormState state;

  @override
  void initState() {
    super.initState();
    logic = Get.put(PrepaidActivateFormLogic(widget.model));
    state = Get.find<PrepaidActivateFormLogic>().state;
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.of(context).activate_card,
        backgroundColor: AppColors.colorE9EBF5,
        appBarBgColor: AppColors.colorE9EBF5,
        resizeToAvoidBottomInset: true,
        child: GetBuilder(
            init: logic,
            builder: (viewModel){
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfo(context),

                ],
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child:   btnWithLoading(title: S.of(context).activate_now.toUpperCase(),
                    isEnable: state.isContinue.value,
                    height:45,
                    circular: Dimens.gap_dp12,
                    onTap: (){
                      if (logic.onNextEvent()) {
                        /// warning
                        // context.pushRoute(PrepaidAtmPasswordPageRoute(
                        //     unionPayCardActiveParamModel:
                        //     state.unionPayCardActiveParamModel));
                      }
                    }),
              )
            ],
          );
        }));
  }

  //填写内容
  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // cText(S.of(context).fill_in_the_content,
        //         fontWeight: FontWeight.w500,
        //         fontSize: 17,
        //         color: AppColors.color1E1F20)
        //     .paddingOnly(left: 15),
        buildForm(children: [
          //卡号
          _buildCardNo(context),
          //卡日期 不需要填
          // _buildCardDate(context),
          //CVV(选填)
          // _buildCVV(context),
        ])
      ],
    );
  }

  Widget _buildCardNo(BuildContext context) {
    return cFormItem3(
        child: AppTextInput(
          controller: logic.cardNoController,
          focusNode: logic.cardNoFocusNode,
          errorText: state.cardNumberError,
          isError: state.cardNumberError != null,
          onTextChanged: (String? text){
            logic.checkParams(cardNo: text);
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          hint: '${S.of(context).card_number}(${widget.model.cardId4})',
        )
    );
    // return cFormItem2(
    //     Row(
    //       children: [
    //         cText(S.of(context).card_number, fontSize: 12),
    //         Gaps.hGap5,
    //         Icon(
    //           Icons.error_outline,
    //           size: 15,
    //           color: AppColors.color666666,
    //         )
    //       ],
    //     ),
    //     child: CustomTextFiled(
    //       fillColor: AppColors.colorf5f5f5,
    //       controller: logic.cardNoController,
    //       focusNode: logic.cardNoFocusNode,
    //       radius: Dimens.gap_dp6,
    //       keyboardType: TextInputType.number,
    //       hasPrefixIcon: false,
    //       hintColor: AppColors.color9A9A9A,
    //       hintText: S.of(context).pleaseEnter,
    //     )
    // );
  }

  Widget _buildCVV(BuildContext context) {
    return cFormItem3(
        child: AppTextInput(
          controller: logic.cardCVVController,
          focusNode: logic.cardCVVFocusNode,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          hint: S.of(context).cvv_optional,
        ));
    // return cFormItem2(
    //     Row(
    //       children: [
    //         cText(S.of(context).cvv_optional, fontSize: 12),
    //         Gaps.hGap5,
    //         Icon(
    //           Icons.error_outline,
    //           size: 15,
    //           color: AppColors.color666666,
    //         )
    //       ],
    //     ),
    //     child: CustomTextFiled(
    //       fillColor: AppColors.colorf5f5f5,
    //       controller: logic.cardCVVController,
    //       focusNode: logic.cardCVVFocusNode,
    //       radius: Dimens.gap_dp6,
    //       keyboardType: TextInputType.number,
    //       hasPrefixIcon: false,
    //       maxLength: 3,
    //       hintColor: AppColors.color9A9A9A,
    //       hintText: S.of(context).pleaseEnter,
    //     ));
  }

  @override
  void dispose() {
    Get.delete<PrepaidActivateFormLogic>();
    super.dispose();
  }
}
