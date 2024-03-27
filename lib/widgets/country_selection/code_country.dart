
import '../../app/base/app.dart';

mixin ToAlias {}

@deprecated
class CElement = CountryCode with ToAlias;

/// Country element. This is the element that contains all the information
class CountryCode {
  /// the name of the country
  String? name;
  String? nameZh;
  String? nameKm;

  /// the flag of the country
  String? flagUri;

  /// the country code (IT,AF..)
  String? code;

  /// the dial code (+39,+93..)
  String? dialCode;

  String getNationCode(){
    var dialCode = this.dialCode?.replaceAll('+', '');
    if (dialCode?.length == 2) {
      dialCode = '00$dialCode';
    }
    if (dialCode?.length == 3) {
      dialCode = '0$dialCode';
    }
    return dialCode??'';
  }

  CountryCode(
      {this.name,
      this.nameKm,
      this.nameZh,
      this.flagUri,
      this.code,
      this.dialCode});

  String displayName() {
    if (nameZh == null || nameKm == null) {
      return name ?? '';
    } else {
      var language = App.language;
      if (language == 'zh') {
        return nameZh ?? '';
      } else if (language == 'km') {
        return nameKm ?? '';
      } else {
        return name ?? '';
      }
    }
  }

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      name: json['name'],
      nameZh: json['nameZh'],
      nameKm: json['nameKm'],
      code: json['code'],
      dialCode: json['dialCode'],
      flagUri: json['flagUri'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'nameZh': nameZh,
        'nameKm': nameKm,
        'code': code,
        'dialCode': dialCode,
        'flagUri': flagUri,
      };
}
