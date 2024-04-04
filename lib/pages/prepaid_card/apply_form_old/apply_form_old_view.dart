
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/pages/prepaid_card/apply_pre/apply_pre_view.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/certificate_type.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../utils/dimen.dart';
import '../../../widgets/app_input_textfield.dart';
import '../../../widgets/common.dart';
import '../../../widgets/prepaid_card/form_common.dart';
import 'apply_form_old_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/21 13:54
/// @Description: 旧用户预付卡表单填写
/// /////////////////////////////////////////////
class ApplyFormOldPage extends StatefulWidget {
  final UnionCardType? unionCardType;

  const ApplyFormOldPage({Key? key, this.unionCardType}) : super(key: key);

  @override
  _ApplyFormOldPageState createState() => _ApplyFormOldPageState();
}

class _ApplyFormOldPageState extends State<ApplyFormOldPage> {
  final logic = Get.put(ApplyFormOldLogic());
  final state = Get.find<ApplyFormOldLogic>().state;

  @override
  void initState() {
    super.initState();
    state.requestParam?.brandId = widget.unionCardType?.value;
    logic.getConfig(widget.unionCardType);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: logic,
        builder: (viewModel){
      return cScaffold(context, S.of(context).apply_prepaid_card,
          backgroundColor: AppColors.colorE9EBF5,
          appBarBgColor: AppColors.colorE9EBF5,
          resizeToAvoidBottomInset: true,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(context),
                ],
              ),
              Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    child: btnWithLoading(
                        title: S.of(context).next,
                        isLoading: state.isLoading.value,
                        isEnable: state.isContinue.value,
                        onTap: () async {
                          var isCan =
                          await logic.onNextEvent(widget.unionCardType);
                          if (isCan) {
                            Get.to(ApplyPrePage(configModel: state.configModel, requestOldParam: state.requestParam));
                          }
                        }),
                  ))
            ],
          ));
    });
  }

  Widget _buildUserInfo(BuildContext context) {
    return buildForm(title: S.of(context).card_information, children: [
      Gaps.vGap15,
      //证件类型
      _buildCertificateType(context),
      Gaps.vGap20,
      //证件号码
      _buildCertificateNumber(context),
      Gaps.vGap10,
    ]);
  }

  //证件类型
  Widget _buildCertificateType(BuildContext context) {
    return buildDropdownItem(
        /*S.of(context).type_of_certificate,*/
        hint: S.of(context).type_of_certificate,
        child: cDropdown(
            isDecoration: false,
            height: 65,
            initValue: state.idIndex,
            items: state.idItems
                .map((item) => DropdownMenuItem<CertificateType>(
                      value: item,
                      child: cText(
                        item.label,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ))
                .toList(),
            onSelect: (value) {
              logic.checkParams(certificateType: value.type);
            }));

  }

  Widget buildBaseInput(Widget child, {String? hint, VoidCallback? onTap}) {
    return Stack(
      children: [
        child.intoContainer(
            height: 65,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColors.color79747E),
                borderRadius: BorderRadius.circular(Dimens.gap_dp10))),
        Positioned(
            left: 15,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: Colors.white,
              child:
                  cText(hint ?? '', color: AppColors.color606266, fontSize: 12),
            )),
      ],
    ).onClick(onTap);
  }

  Widget buildDropdownItem({Widget? child, String? hint}) {
    return buildBaseInput(child!, hint: hint);
  }

  //证件号码
  Widget _buildCertificateNumber(BuildContext context) {
    return AppTextInput(
      isError: state.requestError != null,
      errorText: state.requestError,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onTextChanged: (text) {
        logic.checkErrorStyle(text);
      },
      controller: logic.idCardController,
      focusNode: logic.idCardFocusNode,
      hint: S.of(context).id_number,
    );
  }

  @override
  void dispose() {
    Get.delete<ApplyFormOldLogic>();
    super.dispose();
  }
}
