import 'dart:convert';
import '../generated/json/base/json_field.dart';
import '../generated/json/country_code_info_model.g.dart';


@JsonSerializable()
class CountryCodeInfoModel {
  @JSONField(name: "Country Name")
  String? countryName;
  @JSONField(name: "ISO3")
  String? iSO3;

  CountryCodeInfoModel({this.countryName, this.iSO3});

  factory CountryCodeInfoModel.fromJson(Map<String, dynamic> json) =>
      $CountryCodeInfoModelFromJson(json);

  Map<String, dynamic> toJson() => $CountryCodeInfoModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
