/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 11:44
/// @Description: 银行卡的状态
/// /////////////////////////////////////////////

enum UnionCardState {
  //正常
  NORMAL,
  //已冻结
  FREEZE,
  //未激活
  INACTIVATED,
  //已注销
  WRITTEN_OFF,
  //正在销卡
  WRITTEN_OFF_ING
}

extension UnionCardStateValue on UnionCardState {
  int get value {
    var ret = '0';
    switch (this) {
      case UnionCardState.NORMAL:
        ret = '0';
        break;
      case UnionCardState.FREEZE:
        ret = '1';
        break;
      case UnionCardState.INACTIVATED:
        ret = '2';
        break;
      case UnionCardState.WRITTEN_OFF:
        ret = '3';
        break;
      case UnionCardState.WRITTEN_OFF_ING:
        ret = '5';
        break;
    }
    return int.parse(ret);
  }

  static UnionCardState typeFromStr(String? type) {
    var ret = UnionCardState.NORMAL;
    switch (type) {
      case '0':
        ret = UnionCardState.NORMAL;
        break;
      case '1':
        ret = UnionCardState.FREEZE;
        break;
      case '2':
        ret = UnionCardState.INACTIVATED;
        break;
      case '3':
        ret = UnionCardState.WRITTEN_OFF;
        break;
      case '5':
        ret = UnionCardState.WRITTEN_OFF_ING;
        break;
    }
    return ret;
  }
}
