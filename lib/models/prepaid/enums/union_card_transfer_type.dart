/// ////////////////////////////////////////////
/// @author: SJD
/// @Date: 2022/12/20 13:40
/// @Description: 转账类型，模版类型
/// /////////////////////////////////////////////
enum UnionCardTransferType {
  toBonglogCard, //卡号
  toBonglogAccount, //账号
  toSelfAccount, //自己账号类型
}

extension UnionCardTransferTypeValue on UnionCardTransferType {
  int get value {
    var ret = 0;
    switch (this) {
      case UnionCardTransferType.toBonglogCard:
        ret = 0;
        break;
      case UnionCardTransferType.toBonglogAccount:
        ret = 1;
        break;
      case UnionCardTransferType.toSelfAccount:
        ret = 2;
        break;
    }
    return ret;
  }

  static UnionCardTransferType typeFromStr(int? type) {
    var ret = UnionCardTransferType.toBonglogCard;
    switch (type) {
      case 0:
        ret = UnionCardTransferType.toBonglogCard;
        break;
      case 1:
        ret = UnionCardTransferType.toBonglogAccount;
        break;
      case 2:
        ret = UnionCardTransferType.toSelfAccount;
        break;
    }
    return ret;
  }
}
