/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/24 15:07
/// @Description: bongloy的账号的状态
/// /////////////////////////////////////////////

enum UnionAccountState {
  //正常
  NORMAL,
  //已冻结
  FREEZE,
  //销户
  WRITTEN_OFF,
}

extension UnionAccountStateValue on UnionAccountState {
  String get value {
    var ret = '00';
    switch (this) {
      case UnionAccountState.NORMAL:
        ret = '00';
        break;
      case UnionAccountState.FREEZE:
        ret = '02';
        break;
      case UnionAccountState.WRITTEN_OFF:
        ret = '04';
        break;
    }
    return ret;
  }

  static UnionAccountState typeFromStr(String? type) {
    var ret = UnionAccountState.NORMAL;
    switch (type) {
      case '00':
        ret = UnionAccountState.NORMAL;
        break;
      case '02':
        ret = UnionAccountState.FREEZE;
        break;
      case '04':
        ret = UnionAccountState.WRITTEN_OFF;
        break;
    }
    return ret;
  }
}
