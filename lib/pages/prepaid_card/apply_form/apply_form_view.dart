
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';

import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/image_model.dart';
import '../../../models/prepaid/enums/doc_type.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../models/prepaid/union_pay_apply_param_model.dart';
import '../../../packages/mrz_parse/src/mrz_result.dart';
import '../../../utils/dimen.dart';
import '../../../utils/screen_util.dart';
import '../../../utils/view_util.dart';
import '../../../widgets/app_input_textfield.dart';
import '../../../widgets/bottom/bottom_select.dart';
import '../../../widgets/certificate/certificate_widget.dart';
import '../../../widgets/common.dart';
import '../../../widgets/country_selection/code_country.dart';
import '../../../widgets/prepaid_card/address_select.dart';
import '../../../widgets/prepaid_card/certificate_select.dart';
import '../../../widgets/prepaid_card/form_common.dart';
import 'apply_form_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/13 13:54
/// @Description: 预付卡表单填写
/// /////////////////////////////////////////////

class ApplyFormPage extends StatefulWidget {
  final UnionCardType? unionCardType;
  final UnionPayApplyParamModel? requestParam;

  ApplyFormPage({Key? key, this.unionCardType, this.requestParam})
      : super(key: key);

  @override
  State<ApplyFormPage> createState() => _ApplyFormPageState();
}

class _ApplyFormPageState extends State<ApplyFormPage> {
  final logic = Get.put(ApplyFormLogic());
  final state = Get.find<ApplyFormLogic>().state;

  @override
  void initState() {
    super.initState();
    logic.init(widget.unionCardType, widget.requestParam);
  }

  @override
  Widget build(BuildContext context) {
    return baseScaffold(context, S.of(context).apply_prepaid_card,
        backgroundColor: AppColors.colorE9EBF5,
        appBarBgColor: AppColors.colorE9EBF5,
        resizeToAvoidBottomInset: true,
        child: GetBuilder(
            init: logic,
            builder: (viewModel) {
              return Column(
                children: [
                  _buildCardInfo(context),
                  //user_info
                  _buildUserInfo(context),
                  Gaps.vGap20,
                  btnWithLoading(
                      title: S.of(context).confirm,
                      isEnable: state.isContinue.value,
                      onTap: () async {
                        if (await logic.onNextEvent()) {
                          /// warning
                          // await context.pushRoute(ApplyPrePageRoute(
                          //     configModel: state.configModel,
                          //     requestParam: state.requestParam));
                        }
                      }),
                  Gaps.vGap30,
                ],
              );
            }));
  }

  Widget _buildCardInfo(context) {
    return buildForm(children: [
      //Service provider
      _buildServiceProvider(),
    ], title: S.of(context).card_information);
  }

  Widget _buildUserInfo(BuildContext context) {
    return buildForm(children: [
      //证件类型
      _buildCertificateType(context),
      //上传证件
      _buildUploadCertification(context),
      //国籍
      if (state.regions.isNotEmpty) _buildNational(context),
      //证件号码
      _buildCertificateNumber(context),
      //姓名
      _buildName(context),
      //出生日期
      _buildBirthday(context),
      //电话一线
      _buildMobilePhone(context),
      //省
      if (state.provinces.isNotEmpty) _buildProvinceCity(context),
      //区级
      if (state.districts.isNotEmpty) _buildDistrict(context),
      //分区
      if (state.partitions.isNotEmpty) _buildPartition(context),
      //地址
      _buildAddress(context),
    ], title: S.of(context).personal_information);
  }

  //电话
  Widget _buildMobilePhone(BuildContext context) {
    return cFormItem3(
        child: AppTextInput(
      isError: state.phoneError != null,
      errorText: state.phoneError,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onTextChanged: (text) {
        logic.checkErrorStyle(phone: text);
      },
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
      controller: logic.phoneOneController,
      focusNode: logic.phoneOneFocusNode,
      hint: S.of(context).label_phone_number,
      // keyboardType: TextInputType.phone,
    ));
  }

  Widget _buildAddress(BuildContext context) {
    return cFormItem3(
        child: AppTextInput(
      isError: state.addressError != null,
      errorText: state.addressError,
      maxLines: 3,
      inputFormatters: [
        FilteringTextInputFormatter.deny(
            RegExp(Common.REGEX_EMOJI))
      ],
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onTextChanged: (text) {
        logic.checkErrorStyle(address: text);
      },
      keyboardType: TextInputType.streetAddress,
      controller: logic.addressController,
      focusNode: logic.addressFocusNode,
      hint: S.of(context).kycFieldLabel_Address,
      // keyboardType: TextInputType.phone,
    ));
  }

  //分区
  Widget _buildPartition(BuildContext context) {
    return cFormItem3(
        child: buildBaseInput(
            Row(
              children: [
                state.partitionsLoading
                    ? buildLoading()
                    : cText(state.partitions[state.partitionIndex].item ?? '',
                            textAlign: TextAlign.start,
                            fontSize: 16,
                            color: Colors.black)
                        .intoExpend(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 24,
                )
              ],
            ),
            content: state.partitions[state.partitionIndex].item ?? '',
            hint: S.of(context).partition, onTap: () {
      if (state.partitionsLoading) {
        return;
      }
      logic.unFocus();
      showSheet(
          context,
          AddressSelect(
            onResult: (value) {
              logic.checkParams(partition: value);
            },
            regions: state.partitions,
          ));
    }));
  }

  Widget buildLoading() {
    return Row(
      children: [
        const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            AppColors.colorE70013,
          ),
        ).intoContainer(width: 20, height: 20)
      ],
    ).intoExpend();
  }

  //省
  Widget _buildProvinceCity(BuildContext context) {
    return cFormItem3(
        child: buildBaseInput(
            Row(
              children: [
                state.provinceLoading
                    ? buildLoading()
                    : cText(state.provinces[state.provinceIndex].item ?? '',
                            textAlign: TextAlign.start,
                            fontSize: 16,
                            color: Colors.black)
                        .intoExpend(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 24,
                )
              ],
            ),
            content: state.provinces[state.provinceIndex].item ?? '',
            hint: S.of(context).provinces_and_cities, onTap: () {
      if (state.provinceLoading) {
        return;
      }
      logic.unFocus();
      showSheet(
          context,
          AddressSelect(
            onResult: (value) {
              logic.checkParams(province: value);
            },
            regions: state.provinces,
          ));
    }));
  }

  //区级 需要产品提供
  Widget _buildDistrict(BuildContext context) {
    return cFormItem3(
        child: buildBaseInput(
            Row(
              children: [
                state.districtsLoading
                    ? buildLoading()
                    : cText(state.districts[state.districtIndex].item ?? '',
                            textAlign: TextAlign.start,
                            fontSize: 16,
                            color: Colors.black)
                        .intoExpend(),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 24,
                )
              ],
            ),
            content: state.districts[state.districtIndex].item ?? '',
            hint: S.of(context).district, onTap: () {
      if (state.districtsLoading) {
        return;
      }
      logic.unFocus();
      showSheet(
          context,
          AddressSelect(
            onResult: (value) {
              logic.checkParams(district: value);
            },
            regions: state.districts,
          ));
    }));
  }

  Widget _buildServiceProvider() {
    return cFormItem(S.of(context).service_provider,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: state.serviceProviders
                  .map((element) => Container(
                        height: 65,
                        width: 93,
                        decoration: BoxDecoration(
                          color: AppColors.colorE9EBF5,
                          border: Border.all(
                              width: 1.6,
                              color: element.isSelect == true
                                  ? AppColors.colorE40C19
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(Dimens.gap_dp8),
                        ),
                        child: element.assetPath?.UIImage(
                            width: 50,
                            height: 50,
                            color: element.enable != true
                                ? Colors.grey.withOpacity(0.6)
                                : null),
                      ))
                  .toList(),
            ),
            Gaps.vGap24,
            ExpandableNotifier(
              child: Stack(
                children: [
                  Expandable(
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCollapseItem(),
                        Gaps.vGap10,
                        _buildRow(S.current.annual_fee,
                            '${state.configModel?.annualFee?.toString().formatCurrency()} USD'),
                        _buildRow(S.current.issuance_fee,
                            '${state.configModel?.issueFee?.toString().formatCurrency()} USD'),
                        _buildRow(S.of(context).validity_period,
                            '${S.current.number_of_year(state.configModel?.validTime ?? 0)}'),
                        if(widget.unionCardType==UnionCardType.physicalCard)
                        _buildRow(S.of(context).daily_withdrawal_limit,
                            '${state.configModel?.withdrawDayMax?.toString().formatCurrency()} USD'),
                        _buildRow(S.of(context).daily_consumption_limit,
                            '${state.configModel?.consumeDayMax?.toString().formatCurrency()} USD'),
                        _buildRow(S.of(context).single_consumption_limit,
                            '${state.configModel?.consumeSingleMax.toString().formatCurrency()} USD'),
                        _buildRow(S.of(context).daily_consumption_times,
                            '${S.current.number_of_transactions(state.configModel?.consumeDayMaxNum ?? 0)}'),
                      ],
                    ),
                    collapsed: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCollapseItem(),
                        Visibility(
                            visible: true,
                            child: Container(
                              height: 0.1,
                              width: ScreenUtil.screenWidth * 3 / 4,
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Builder(
                        builder: (context) {
                          var controller =
                              ExpandableController.of(context, required: true)!;
                          return IconButton(
                              onPressed: () {
                                controller.toggle();
                              },
                              icon: Icon(
                                controller.expanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.colorE40C19,
                                size: 27,
                              ));
                        },
                      ))
                ],
              ).intoContainer(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.gap_dp8),
                  border: Border.all(width: 1, color: AppColors.colorDEDEDE),
                ),
              ),
            ),
            // buildCollapsedBody().onClick(() {
            //   showSheet(context, CardConfigBottom(cardInfo: state.configModel));
            // })
          ],
        ));
  }

  Widget _buildRow(String s, String t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cText(s,
            color: AppColors.color79747E,
            fontSize: 14,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w500),
        cText(t, color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)
      ],
    ).paddingOnly(top: 15);
  }

  Widget buildCollapseItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(S.of(context).unionpay_classic,
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        cText(
            '${S.of(context).annual_fee}:${'${state.configModel?.annualFee?.toString().formatCurrency()} USD'}')
      ],
    );
  }

  //证件类型
  Widget _buildCertificateType(BuildContext context) {
    return cFormItem(S.of(context).type_of_certificate,
        child: CertificateSelect(
          selectType:
              DocTypeValue.typeFromStr2(state.idItems[state.idTypeIndex].type),
          items: state.idItems,
          onResult: (type) {
            logic.checkParams(certificateType: type);
          },
        ));
  }

  Widget buildDropdownItem(
      {String? content, String? hint, VoidCallback? onTap}) {
    return buildBaseInput(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cText(content?.isNotEmpty==true?'$content':'$hint',
                color: content?.isNotEmpty!=true ? AppColors.color79747E : Colors.black,
                fontSize: 16),
            const Icon(
              Icons.calendar_today_outlined,
              color: Colors.black,
              size: 24,
            )
          ],
        ),
        content: content,
        hint: hint,
        onTap: onTap);
  }

  Widget buildDropdownItemIcon(String path, String content,
      {VoidCallback? onTap}) {
    return buildBaseInput(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                cText(path, textAlign: TextAlign.start, fontSize: 25),
                Gaps.hGap10,
                cText(content,
                        textAlign: TextAlign.start,
                        color: Colors.black,
                        fontSize: 16)
                    .intoExpend(),
              ],
            ).intoExpend(),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 24,
            )
          ],
        ),
        content: content,
        hint: S.of(context).nationality,
        onTap: onTap);
  }

  Widget buildBaseInput(Widget child,
      {String? content, String? hint, VoidCallback? onTap}) {
    return Stack(
      children: [
        child.intoContainer(
            height: 65,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColors.color79747E),
                borderRadius: BorderRadius.circular(Dimens.gap_dp10))),
        if (content?.isNotEmpty==true)
          Positioned(
              left: 15,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: Colors.white,
                child: cText(hint ?? '',
                    color: AppColors.color606266, fontSize: 12),
              )),
      ],
    ).onClick(onTap);
  }

  //姓名
  Widget _buildName(BuildContext context) {
    return Column(
      children: [
        cFormItem3(
            child: AppTextInput(
          isError: state.firstNameError != null,
          errorText: state.firstNameError,
          onTextChanged: (text) {
            logic.checkErrorStyle(firstName: text);
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[ a-zA-Z]')),
            FilteringTextInputFormatter.deny(
                RegExp(Common.REGEX_EMOJI))
          ],
          focusNode: logic.firstNameFocusNode,
          controller: logic.firstNameController,
          hint: S.of(context).kycFieldLabel_FirstName,
          enabled: state.firstNameEnable.value,
        )),
        cFormItem3(
            child: AppTextInput(
          isError: state.lastNameError != null,
          errorText: state.lastNameError,
          onTextChanged: (text) {
            logic.checkErrorStyle(lastName: text);
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[ a-zA-Z]')),
            FilteringTextInputFormatter.deny(
                RegExp(Common.REGEX_EMOJI))
          ],
          focusNode: logic.lastNameFocusNode,
          controller: logic.lastNameController,
          hint: S.of(context).kycFieldLabel_LastName,
          enabled: state.lastNameEnable.value,
        )),
      ],
    );
  }

  //生日
  Widget _buildBirthday(BuildContext context) {
    return cFormItem3(
      child: buildDropdownItem(
          content: state.requestParam.parseDob(),
          hint: S.of(context).settingsUserBirth,
          onTap: () async {
            logic.unFocus();
            var now = DateTime.now();
            var firstDateStr = '${now.year - 100}-01-01';
            var firstDate = DateTime.parse(firstDateStr);
            var nowDate = DateTime.parse('${now.year - 30}-01-01');
            var lastDateStr = '${now.year - 10}-12-31';
            var lastDate = DateTime.parse(lastDateStr);
            var newDate = await showDatePicker(
                context: context,
                initialDate: nowDate,
                firstDate: firstDate,
                lastDate: lastDate);
            if (newDate != null) {
              logic.checkParams(birthday: newDate);
            }
          }),
    );
  }

  //国籍
  Widget _buildNational(BuildContext context) {
    return cFormItem3(
        child: buildDropdownItemIcon(
            state.regions[state.regionIndex.value].flagUri ?? '',
            '${state.regions[state.regionIndex.value].displayName() ?? ''} ${state.regions[state.regionIndex.value].dialCode ?? ''}',
            onTap: () {
      logic.unFocus();
      showSheet(
          context,
          NationalSelect(
            onResult: (CountryCode value) {
              logic.checkParams(nationality: value);
            },
            regions: state.regions,
          ));
    }));
  }

  //证件号码
  Widget _buildCertificateNumber(BuildContext context) {
    return cFormItem3(
        child: AppTextInput(
      isError: state.idNumberError != null,
      errorText: state.idNumberError,
      inputFormatters: [
        FilteringTextInputFormatter.deny(
            RegExp(Common.REGEX_EMOJI))
      ],
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onTextChanged: (text) {
        logic.checkErrorStyle(idCard: text);
      },
      controller: logic.idCardController,
      focusNode: logic.idCardFocusNode,
      hint: S.of(context).id_number,
      // keyboardType: TextInputType.phone,
    ));
  }

  //上传证件
  Widget _buildUploadCertification(BuildContext context) {
    return cFormItem(S.of(context).upload_documents,
        child: CertificateWidget(
          key: certificateWidget,
          children: [
            SelectCertificate(
                label: S.of(context).positive,
                index: 0,
                defaultIcon: ImagesRes.IC_CARD_FRONT_ICON,
                onClear: (model) {
                  logic.clearUploadFile(positiveFile: model);
                },
                unFocus: () {
                  logic.unFocus();
                },
                base64Image: state.base64ImagePhotoFront,
                onResult: (imgModel) {
                  logic.checkParams(positiveFile: imgModel);
                },
                onMrzResult: (MRZResult mrzResult, ImgModel imageModel) {
                  logic.checkParams(
                      mrzResult: mrzResult, positiveFile: imageModel);
                }),
            SelectCertificate(
                label: S.of(context).back,
                index: 1,
                defaultIcon: ImagesRes.IC_CARD_FRONT_ICON,
                onClear: (model) {
                  logic.clearUploadFile(backFile: model);
                },
                base64Image: state.base64ImagePhotoObverse,
                unFocus: () {
                  logic.unFocus();
                },
                onResult: (imgModel) {
                  logic.checkParams(backFile: imgModel);
                }),
            SelectCertificate(
                label: S.of(context).selfie,
                index: 2,
                base64Image: state.base64ImageHeadPhoto,
                onClear: (model) {
                  logic.clearUploadFile(selfieFile: model);
                },
                defaultIcon: ImagesRes.IC_CARD_CAMERA,
                unFocus: () {
                  logic.unFocus();
                },
                onResult: (imgModel) {
                  logic.checkParams(selfieFile: imgModel);
                }),
          ],
        ));
  }

  @override
  void dispose() {
    Get.delete<ApplyFormLogic>();
    super.dispose();
  }
}
