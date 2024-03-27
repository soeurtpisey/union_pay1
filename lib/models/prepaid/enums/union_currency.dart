/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/24 15:42
/// @Description: currency
/// /////////////////////////////////////////////

enum UnionCurrency { USD, KHR }

extension UnionCurrencyValue on UnionCurrency {
  int get value {
    var ret = '0003';
    switch (this) {
      case UnionCurrency.USD:
        ret = '0003';
        break;
      case UnionCurrency.KHR:
        ret = '0004';
        break;
    }
    return int.parse(ret);
  }

  static UnionCurrency typeFromStr(String? type) {
    var ret = UnionCurrency.USD;
    switch (type) {
      case '0003':
        ret = UnionCurrency.USD;
        break;
      case '0004':
        ret = UnionCurrency.KHR;
        break;
    }
    return ret;
  }
}
