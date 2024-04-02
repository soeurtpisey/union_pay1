import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/widgets/widget_to_image.dart';
import '../../../app/base/app.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../helper/number_helper.dart';
import '../../../models/prepaid/res/union_pay_history_res_entity.dart';
import '../../../utils/screen_util.dart';
import '../../../widgets/common.dart';
import 'prepaid_history_detail_logic.dart';

/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/14 19:44
/// @Description: 预付卡历史详情页 / 转账详情页
/// /////////////////////////////////////////////
class PrepaidHistoryDetailPage extends StatefulWidget {
  final BongLoyCardOrderDto bongLoyCardOrderDto;

  const PrepaidHistoryDetailPage({Key? key, required this.bongLoyCardOrderDto})
      : super(key: key);

  @override
  _PrepaidHistoryDetailPageState createState() =>
      _PrepaidHistoryDetailPageState();
}

class _PrepaidHistoryDetailPageState extends State<PrepaidHistoryDetailPage> {
  final logic = Get.put(PrepaidHistoryDetailLogic());
  final state = Get.find<PrepaidHistoryDetailLogic>().state;

  @override
  void dispose() {
    Get.delete<PrepaidHistoryDetailLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cScaffold(context, S.current.history_detail,
        backgroundColor: AppColors.colorE9EBF5,
        appBarBgColor: AppColors.colorE9EBF5,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _detailView(),
            Gaps.vGap20,
            btnWithLoading(
                title: S.current.inviteFriendShare,
                onTap: () {
                  _showDialog();
                }),
            Gaps.vGap5,
            cText(S.current.go_back,
                    color: AppColors.color1E1F20,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)
                .intoContainer(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 20))
                .onClick(() {
              Navigator.of(context).pop();
            })
          ],
        )).intoContainer(width: double.infinity));
  }

  Widget _detailView({bool share = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: share ? 0 : 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Gaps.vGap10,
              ImagesRes.IC_SUCCESS_80.UIImage(),
              Gaps.vGap4,
              cText(widget.bongLoyCardOrderDto.getTransferSuccessType(),
                  color: AppColors.color07C160,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
              Gaps.vGap10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.ideographic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  //为了居中占个位置
                  cText('',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.transparent),
                  Gaps.hGap12,
                  cText(
                      NumberHelper.formatCurrency(
                          widget.bongLoyCardOrderDto.amount ?? 0.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: AppColors.color1B1C1E),
                  Gaps.hGap12,
                  cText((widget.bongLoyCardOrderDto.ccy ?? '').toUpperCase(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.color1B1C1E)
                ],
              ),
            ],
          ),
          Container(
            color: AppColors.colorDDDDDD,
            height: 0.2,
            width: ScreenUtil.screenWidth,
          ),
          Column(
            children: [
              Gaps.vGap10,
              if (widget.bongLoyCardOrderDto.intTxnRefId != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cText(S.current.history_transfer_no,
                            fontSize: 13, textAlign: TextAlign.left)
                        .intoExpend(flex: 2),
                    Gaps.hGap20,
                    cText(widget.bongLoyCardOrderDto.intTxnRefId ?? '',
                            textAlign: TextAlign.right,
                            fontSize: 13,
                            color: AppColors.color151736)
                        .intoExpend(flex: 2),
                  ],
                ).intoContainer(margin: EdgeInsets.only(bottom: 16)),
              // Gaps.vGap16,
              if (widget.bongLoyCardOrderDto.intTxnSeqId != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cText(S.current.history_transfer_num,
                            fontSize: 13, textAlign: TextAlign.left)
                        .intoExpend(flex: 2),
                    Gaps.hGap20,
                    cText(widget.bongLoyCardOrderDto.intTxnSeqId ?? '',
                            textAlign: TextAlign.right,
                            fontSize: 13,
                            color: AppColors.color151736)
                        .intoExpend(flex: 2),
                  ],
                ).intoContainer(margin: EdgeInsets.only(bottom: 16)),
              //Gaps.vGap16,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(S.current.from_account, textAlign: TextAlign.left)
                      .intoExpend(flex: 2),
                  Gaps.hGap20,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      cText(
                        widget.bongLoyCardOrderDto.cucoType == 0
                            ? (App.userSession?.userInfo?.phone ?? '')
                            : (widget.bongLoyCardOrderDto.srcCard ?? '')
                                .formatBankCard(),
                        fontSize: 13,
                        textAlign: TextAlign.right,
                        color: AppColors.color151736,
                      ),
                      cText(
                          widget.bongLoyCardOrderDto.cucoType == 0
                              ? (App.userSession?.userInfo?.phone ?? '')
                              : (widget.bongLoyCardOrderDto.srcCard ?? '')
                                  .formatBankCard(),
                          textAlign: TextAlign.right,
                          color: AppColors.color8D8E9A,
                          fontSize: 12)
                    ],
                  ).intoExpend(flex: 3),
                ],
              ),
              Gaps.vGap10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(S.current.history_amount,
                          fontSize: 13, textAlign: TextAlign.left)
                      .intoExpend(flex: 1),
                  Gaps.hGap20,
                  cText('${NumberHelper.formatCurrency(widget.bongLoyCardOrderDto.amount ?? 0.0)}${widget.bongLoyCardOrderDto.ccy}',
                          textAlign: TextAlign.right,
                          fontSize: 13,
                          color: AppColors.colorFF3E47)
                      .intoExpend(flex: 3),
                ],
              ),
              Gaps.vGap10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(S.current.to_account, textAlign: TextAlign.left)
                      .intoExpend(flex: 1),
                  Gaps.hGap20,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      cText(
                        (widget.bongLoyCardOrderDto.dstCard ?? '')
                            .formatBankCard(),
                        fontSize: 13,
                        textAlign: TextAlign.right,
                        color: AppColors.color151736,
                      ),
                      cText(
                          (widget.bongLoyCardOrderDto.dstCard ?? '')
                              .formatBankCard(),
                          textAlign: TextAlign.right,
                          color: AppColors.color8D8E9A,
                          fontSize: 12)
                    ],
                  ).intoExpend(flex: 3),
                ],
              ),
              Gaps.vGap10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(S.current.to_account_name,
                          fontSize: 13, textAlign: TextAlign.left)
                      .intoExpend(flex: 2),
                  Gaps.hGap20,
                  cText(widget.bongLoyCardOrderDto.dstCardName ?? '',
                          textAlign: TextAlign.right,
                          fontSize: 13,
                          color: AppColors.color151736)
                      .intoExpend(flex: 2),
                ],
              ),
              Gaps.vGap10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(S.current.history_transfer_time,
                          fontSize: 13, textAlign: TextAlign.left)
                      .intoExpend(flex: 2),
                  Gaps.hGap20,
                  cText(widget.bongLoyCardOrderDto.parseDate2() ?? '',
                          textAlign: TextAlign.right,
                          fontSize: 13,
                          color: AppColors.color151736)
                      .intoExpend(flex: 2),
                ],
              ),
              Gaps.vGap10,
              /// warning
              // ImagesRes.ICON_UPAY_LOGO_V2.UIImage(),
              Gaps.vGap10,
            ],
          ),
        ],
      ),
    );

  }

  final GlobalKey _renderObjectKey = GlobalKey();

  void _showDialog() {
    unawaited(showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: Dialog(
            backgroundColor: Colors.transparent,
            child: RepaintBoundary(
                key: _renderObjectKey, child: _detailView(share: true)),
          ));
        }));

    Future.delayed(const Duration(milliseconds: 500)).then((value) => getWidgetToImage
        .getInstance(_renderObjectKey)
        ?.getFile()
        .then((value) => Share.shareFiles([value!.path])));
  }
}
