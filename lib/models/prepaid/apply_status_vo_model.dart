import 'dart:convert';
import '../../generated/json/apply_status_vo_model.g.dart';
import '../../generated/json/base/json_field.dart';

@JsonSerializable()
class ApplyStatusVoModel {
	bool? audit;
	bool? supportApply;

	ApplyStatusVoModel();

	factory ApplyStatusVoModel.fromJson(Map<String, dynamic> json) => $ApplyStatusVoModelFromJson(json);

	Map<String, dynamic> toJson() => $ApplyStatusVoModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}