/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/2/23 09:28
/// @Description:
/// /////////////////////////////////////////////

enum DocType { ID_CARD, PASSPORT, DRIVERS }

extension DocTypeValue on DocType {
  String get value {
    String ret;
    switch (this) {
      case DocType.ID_CARD:
        ret = 'ID_CARD';
        break;
      case DocType.PASSPORT:
        ret = 'PASSPORT';
        break;
      case DocType.DRIVERS:
        ret = 'DRIVERS';
        break;
    }
    return ret;
  }

  static DocType typeFromStr(String? type) {
    var ret = DocType.ID_CARD;
    switch (type) {
      case 'ID_CARD':
        ret = DocType.ID_CARD;
        break;
      case 'PASSPORT':
        ret = DocType.PASSPORT;
        break;
      case 'DRIVERS':
        ret = DocType.DRIVERS;
        break;
    }
    return ret;
  }

  String get value2 {
    String ret;
    switch (this) {
      case DocType.ID_CARD:
        ret = '1';
        break;
      case DocType.PASSPORT:
        ret = '3';
        break;
      default:
        ret = '3';
        break;
    }
    return ret;
  }
  static DocType typeFromStr2(String? type) {
    var ret = DocType.ID_CARD;
    switch (type) {
      case '1':
        ret = DocType.ID_CARD;
        break;
      case '3':
        ret = DocType.PASSPORT;
        break;
    }
    return ret;
  }
}
