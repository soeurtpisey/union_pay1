import 'dart:convert';
import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_pre_transfer_model.g.dart';

@JsonSerializable()
class UnionPayPreTransferModel {
  double? amount;
  double? totalAmount;
  double? fee;

  bool? hasFee() {
    return (fee ?? 0) > 0;
  }

  UnionPayPreTransferModel();

  factory UnionPayPreTransferModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayPreTransferModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayPreTransferModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
