
import 'package:json_annotation/json_annotation.dart';
import 'package:union_pay/models/prepaid/enums/union_card_type.dart';
import '../../../generated/json/union_pay_apply_list_res_model.g.dart';
import '../../../generated/l10n.dart';

@JsonSerializable()
class UnionPayApplyListResModel {
  //品牌ID [长度4位]:- 0014: 实体卡- 0013: 虚拟卡")
  String? brandId;
  //卡号
  String? cardId;

  //卡号后4位数
  String? cardId4;
  //创建时间
  String? createTime;
  //用户id
  int? cusId;
  //申请信息
  String? errorMsg;
  //卡映射ID [每个卡都是独特]
  String? extCardId;
  //外部客户ID [最大15位, 每个用户都是独特]")
  String? extCustId;
  //是否已上传头像：- Y: 已上传- N: 未上传")
  String? headPicUrlFlag;

  //主键ID
  int? id;
  //审核备注 [最大长度256]
  String? note;
  //Uploaded Document Photo Flag:- Y: 已上传- N: 未上传")
  String? pidNoUrlFlag;
  //响应参数
  String? repParams;
  //请求参数
  String? reqParams;
  //银联卡平台：申请单流水号 [最长32]
  String? serialId;
  //(value = "实体卡状态：- 01: 未审核- 06: 审核通过- 07: 审核拒绝- 08: 制卡中- 09: 制卡完成\n" +
  //         "虚拟卡状态：- 01: 未审核- 06: 审核通过- 07: 审核拒绝- 08: 激活成功")
  String? status;
  //更新时间
  String? updateTime;

  UnionPayApplyListResModel({
    this.brandId,
    this.cardId,
    this.cardId4,
    this.createTime,
    this.cusId,
    this.errorMsg,
    this.extCardId,
    this.extCustId,
    this.headPicUrlFlag,
    this.id,
    this.note,
    this.pidNoUrlFlag,
    this.repParams,
    this.reqParams,
    this.serialId,
    this.status,
    this.updateTime,
  });

  factory UnionPayApplyListResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayApplyListResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayApplyListResModelToJson(this);

  //卡的类型
  UnionCardType cardType() {
    return UnionCardTypeValue.typeFromStr(brandId);
  }

  String applyStatus() {
    var statusStr = '';

    switch (status) {
      case '01':
        statusStr = S.current.not_reviewed;
        break;
      case '06':
        statusStr = S.current.examination_passed;
        break;
      case '07':
        statusStr = S.current.audit_rejected;
        break;
      case '08':
        if (cardType() == UnionCardType.virtualCard) {
          statusStr = S.current.activation_successful;
        } else {
          statusStr = S.current.card_making;
        }
        break;
      case '09':
        statusStr = S.current.card_making_completed;
        break;
        // }
        return statusStr;
    }

    return statusStr;
  }

  String cardTypeTitle() {
    return cardType() == UnionCardType.virtualCard
        ? S.current.unionpay_virtual_card
        : S.current.ic_card;
  }
}
