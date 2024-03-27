
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../models/prepaid/enums/union_card_type.dart';
import '../../../models/prepaid/res/union_pay_card_config_model.dart';
import '../../../models/prepaid/union_pay_apply_old_param_model.dart';
import '../../../models/prepaid/union_pay_apply_param_model.dart';
import '../../../utils/view_util.dart';
import '../../../widgets/bottom/bottom_select.dart';
import '../../../widgets/common.dart';
import 'apply_pre_logic.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/14 15:00
/// @Description: 预付卡申请预确认
/// /////////////////////////////////////////////

class ApplyPrePage extends StatefulWidget {
  final UnionPayCardConfigModel? configModel;

  final UnionPayApplyParamModel? requestParam; //新用户请求参数

  final UnionPayApplyOldParamModel? requestOldParam; //旧用户请求参数

  ApplyPrePage(
      {Key? key, this.requestParam, this.configModel, this.requestOldParam})
      : super(key: key);

  @override
  State<ApplyPrePage> createState() => _ApplyPrePageState();
}

class _ApplyPrePageState extends State<ApplyPrePage> {
  final logic = Get.put(ApplyPreLogic());
  final state = Get.find<ApplyPreLogic>().state;
  var isVirtual=false;
  @override
  void initState() {
    super.initState();
    state.configModel = widget.configModel;
    if(widget.requestParam!=null){
      isVirtual=widget.requestParam?.isVirtual()??false;
    }else if(widget.requestOldParam!=null){
      isVirtual=widget.requestOldParam?.isVirtual()??false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: logic,
      builder: (viewModel) {
        return cScaffold(context, S.of(context).apply_prepaid_card,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildBody(),
                  Gaps.vGap20,
                  btnWithLoading(
                      height: 45,
                      circular: 12,
                      isLoading: state.loading.value,
                      title: S.of(context).confirm,
                      onTap: () async {
                        var cardInfo = state.configModel;
                        if (isAdminApplyCard) {
                          var walletId =
                              await SendWalletIdPage.show2<String>(context);
                          if (walletId?.isNotEmpty == true) {
                            logic.applyRequest(
                                param: widget.requestParam,
                                oldParam: widget.requestOldParam,
                                walletId: int.parse(walletId!));
                          }
                        } else {
                          if (cardInfo?.isPay() == true) {
                            await showSheet(
                                context,
                                bodyPadding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 40, top: 10),
                                CardPaymentDetail(
                                  amount:
                                      cardInfo?.payAmount().toString() ?? '',
                                  currency: 'USD',
                                  onTap: () {
                                    /// warning
                                    // BioUtil.getInstance().showPasscodeModal(
                                    //     context,
                                    //     cardInfo?.payAmount().toString() ?? '',
                                    //     'USD', (value) {
                                    //   logic.applyRequest(
                                    //       param: widget.requestParam,
                                    //       oldParam: widget.requestOldParam);
                                    // });
                                  },
                                ));
                          } else {
                            logic.applyRequest(
                                param: widget.requestParam,
                                oldParam: widget.requestOldParam);
                          }
                        }
                      }),
                  Gaps.vGap50,
                ],
              ),
            ));
      },
    );
  }

  Widget buildBody() {
    var isShowUserInfo = widget.requestParam != null;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImagesRes.IC_UNION_PAY_CLASSIC_LOGO_ICON.UIImage(),
          cText(S.of(context).unionpay_classic,
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
          Gaps.vGap38,
          if (isShowUserInfo)
            buildDetailTitle(
                ClipOval(
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ).intoContainer(color: Colors.black, height: 27, width: 27),
                ),
                S.of(context).user_detail),
          if (isShowUserInfo) ...buildUserInfo(),
          buildDetailTitle(
              const Icon(
                Icons.credit_card,
                color: Colors.black,
                size: 27,
              ),
              S.of(context).card_detail),
          ...buildCardInfo()
        ],
      ),
    );
  }

  List<Widget> buildCardInfo() {
    var cardInfo = state.configModel;
    var cardType = state.configModel?.cardType();
    return [
      _buildRow(S.current.apply_id, cardInfo?.id.toString()),
      _buildRow(
          S.of(context).premium_card_type,
          cardType == UnionCardType.physicalCard
              ? S.of(context).physical_card_application_including_virtual_card
              : S.of(context).virtual_card_application),
      _buildRow(S.current.validity_period,
          '${S.current.number_of_year(cardInfo?.validTime ?? 0)}'),
      _buildRow(S.current.annual_fee,
          '${cardInfo?.annualFee?.toString().formatCurrency()} USD'),
      _buildRow(S.current.issuance_fee,
          '${cardInfo?.issueFee?.toString().formatCurrency()} USD'),
      if(!isVirtual)
      _buildRow(S.current.apply_daily_withdrawal_limit,
          '${cardInfo?.withdrawDayMax?.toString().formatCurrency()} USD'),
      _buildRow(S.current.daily_consumption_limit,
          '${cardInfo?.consumeDayMax?.toString().formatCurrency()} USD'),
      _buildRow(S.current.single_consumption_limit,
          '${cardInfo?.consumeSingleMax.toString().formatCurrency()} USD'),
      if(!isVirtual)
        _buildRow(S.current.daily_withdrawal_times,
          ' ${S.current.number_of_transactions(cardInfo?.withdrawDayMaxNum ?? 0)}'),
      _buildRow(S.current.daily_consumption_times,
          '${S.current.number_of_transactions(cardInfo?.consumeDayMaxNum ?? 0)} '),
      Gaps.vGap20,
    ];
  }

  List<Widget> buildUserInfo() {
    var model = widget.requestParam;
    return [
      _buildRow(S.current.nationality, model?.nationality ?? ''),
      _buildRow(S.current.type_of_certificate, model?.getPidDesc() ?? ''),
      _buildRow(S.current.id_number, model?.pidNo ?? ''),
      _buildRow(S.current.full_name, model?.name ?? ''),
      _buildRow(S.current.kycFieldLabel_DOB, model?.parseDob() ?? ''),
      _buildRow(S.current.label_phone_number, model?.mobile ?? ''),
      _buildRow(S.current.provinces_and_cities, model?.province ?? ''),
      _buildRow(S.current.district, model?.districts ?? ''),
      _buildRow(S.current.partition, model?.communes ?? ''),
      _buildRow(S.current.kycFieldLabel_Address, model?.addr ?? ''),
      Gaps.vGap20,
    ];
  }

  //user detail title
  Container buildDetailTitle(Widget icon, String title) {
    return Container(
      color: AppColors.colorEEEEEE,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          icon,
          Gaps.hGap16,
          cText(title,
              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black)
        ],
      ),
    );
  }


  Widget _buildRow(String title, String? content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cText(title,
            textAlign: TextAlign.start,
            color: AppColors.color79747E,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        cText(content ?? '',
                textAlign: TextAlign.end,
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500)
            .intoExpend()
      ],
    ).paddingOnly(top: 15, left: 15, right: 15);
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<ApplyPreLogic>();
  }
}

class CardPaymentDetail extends StatelessWidget {
  final String? amount;
  final String? currency;
  final VoidCallback? onTap;

  const CardPaymentDetail({super.key, this.amount, this.currency, this.onTap});

  Widget buildTitle(BuildContext context) {
    var iconSize = 40.0;
    return Container(
      child: Column(
        children: [
          buildBottomTop(),
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: iconSize),
                    child: cText(S.of(context).servicePaymentDetails,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )),
              ImagesRes.HOME_LOGO.UIImage(width: iconSize)
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(context),
          Gaps.vGap15,
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                cText(amount ?? '',
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorE40C19,
                    fontSize: 42),
                cText(currency ?? '',
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorE40C19,
                    fontSize: 16)
              ],
            ),
          ),
          Gaps.vGap50,
          buildItem('${S.of(context).filter_ccy}:', currency ?? ''),
          Gaps.vGap15,
          buildItem(
              '${S.of(context).transfer_remark}:', S.of(context).commission),
          Gaps.vGap30,
          btnWithLoading(
              title: S.of(context).payButton,
              circular: 50,
              onTap: () {
                Navigator.pop(context);
                onTap?.call();
              })
        ],
      ),
    );
  }

  Widget buildItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cText(title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.45)),
        cText(value,
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16)
      ],
    );
  }
}
