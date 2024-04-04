
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/pages/prepaid_card/apply_pre/apply_pre_view.dart';
import '../../../generated/l10n.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../models/prepaid/union_pay_apply_param_model.dart';
import '../../../models/region/region_item_model.dart';
import '../../../widgets/common.dart';
import '../../../widgets/prepaid_card/form_common.dart';
import 'apply_address_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/13 13:54
/// @Description: 预付卡表单填写地址
/// /////////////////////////////////////////////
class ApplyAddressPage extends StatefulWidget {
  final UnionCardType? unionCardType;

  final UnionPayApplyParamModel? requestParam;

  ApplyAddressPage({Key? key, this.unionCardType, this.requestParam})
      : super(key: key);

  @override
  State<ApplyAddressPage> createState() => _ApplyAddressPageState();
}

class _ApplyAddressPageState extends State<ApplyAddressPage> {
  final logic = Get.put(ApplyAddressLogic());
  final state = Get.find<ApplyAddressLogic>().state;

  @override
  void initState() {
    super.initState();
    state.requestParam = widget.requestParam;
    state.requestParam?.brandId = widget.unionCardType?.value;
    logic.getConfig(widget.unionCardType);
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S().apply_prepaid_card,
        resizeToAvoidBottomInset: true,
        child: Column(
          children: [
            //address
            _buildForm(context),
            Obx(() => buildNextButton(S.of(context).next,
                    isEnable: state.isContinue.value, onTap: () async {
                  var isCanNext = await logic.onNextEvent(widget.unionCardType);
                  if (isCanNext) {
                    Get.to(ApplyPrePage(configModel: state.configModel, requestParam: state.requestParam));
                  }
                  //确认阶段
                }))
          ],
        ));
  }

  Widget _buildForm(BuildContext context) {
    return buildForm(children: [
      //地址
      _buildAddress(context),
      //省 需要产品提供
      Obx(() => _buildProvinceCity(context)),
      //区级 需要产品提供
      Obx(() => _buildDistrict(context)),
      //分区 需要产品提供
      Obx(() => _buildPartition(context)),
      //电话一线
      _buildMobilePhone(context),
      //电子邮箱
      _buildEmail(context),
    ]);
  }

  Widget _buildAddress(BuildContext context) {
    return cFormItem(S.of(context).address,
        child: buildTextInput(context,
            controller: logic.addressController,
            focusNode: logic.addressFocusNode));
  }

  //省
  Widget _buildProvinceCity(BuildContext context) {
    return cFormItem(S.of(context).provinces_and_cities,
        child: cDropdown(
            hint: S.of(context).validation_select,
            initValue: state.provinceIndex,
            onSelect: (value) {
              logic.checkParam(province: value);
            },
            items: state.provinces
                .map((item) => DropdownMenuItem<RegionItemModel>(
                      value: item,
                      child: cText(item.item ?? ''),
                    ))
                .toList()));
  }

  //区级 需要产品提供
  Widget _buildDistrict(BuildContext context) {
    return cFormItem(S.of(context).district,
        child: cDropdown(
            hint: S.of(context).validation_select,
            initValue: state.districtIndex,
            onSelect: (value) {
              logic.checkParam(district: value);
            },
            items: state.districts
                .map((item) => DropdownMenuItem<RegionItemModel>(
                      value: item,
                      child: cText(item.item ?? ''),
                    ))
                .toList()));
  }

  //分区 需要产品提供
  Widget _buildPartition(BuildContext context) {
    return cFormItem(S.of(context).partition,
        child: cDropdown(
            hint: S.of(context).validation_select,
            initValue: state.partitionIndex,
            onSelect: (value) {
              logic.checkParam(partition: value);
            },
            items: state.partitions
                .map((item) => DropdownMenuItem<RegionItemModel>(
                      value: item,
                      child: cText(item.item ?? ''),
                    ))
                .toList()));
  }

  //电话
  Widget _buildMobilePhone(BuildContext context) {
    return cFormItem(S.of(context).label_phone_number,
        child: cFormPhoneInput(
            controller: logic.phoneOneController,
            focusNode: logic.phoneOneFocusNode));
  }

  //电子邮箱
  Widget _buildEmail(BuildContext context) {
    return cFormItem(S.of(context).email,
        child: buildTextInput(context,
            controller: logic.emailController,
            focusNode: logic.emailFocusNode));
  }

  @override
  void dispose() {
    Get.delete<ApplyAddressLogic>();
    super.dispose();
  }
}
