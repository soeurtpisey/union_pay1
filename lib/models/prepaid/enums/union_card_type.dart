
/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/14 11:35
/// @Description: 虚拟卡的类型
/// /////////////////////////////////////////////

bool isAdminApplyCard = false;

enum UnionCardType {
  //虚拟卡
  virtualCard,
  //实体卡
  physicalCard,
}

extension UnionCardTypeValue on UnionCardType {
  String get value {
    String ret;
    switch (this) {
      case UnionCardType.virtualCard:
        ret = '0013';
        break;
      case UnionCardType.physicalCard:
        if (/*Env.appEnv == EnvName.prod && */isAdminApplyCard) {
          ret = '0006'; //仅正式环境，VIP黑卡，特殊权限申请，或者到BO中申请
        } else {
          ret = '0014';
        }
        break;
    }
    return ret;
  }

  static UnionCardType typeFromStr(String? type) {
    var ret = UnionCardType.virtualCard;
    switch (type) {
      case '0013':
        ret = UnionCardType.virtualCard;
        break;
      case '0014':
        ret = UnionCardType.physicalCard;
        break;
      case '0006':
        ret = UnionCardType.physicalCard;
        break;
    }
    return ret;
  }
}
