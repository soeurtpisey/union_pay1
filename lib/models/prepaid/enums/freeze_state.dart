/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/14 20:16
/// @Description: 冻结|解冻状态
/// /////////////////////////////////////////////

enum FreezeState {
  //右滑确认
  NORMAL,
  //冻结
  FREEZE,
  //解冻账号
  UNFREEZE,
}

extension FreezeStateValue on FreezeState {
  int get value {
    int ret;
    switch (this) {
      case FreezeState.NORMAL:
        ret = 0;
        break;
      case FreezeState.FREEZE:
        ret = 1;
        break;
      case FreezeState.UNFREEZE:
        ret = 2;
        break;
    }
    return ret;
  }

  static FreezeState typeFromStr(int? type) {
    var ret = FreezeState.FREEZE;
    switch (type) {
      case 0:
        ret = FreezeState.NORMAL;
        break;
      case 1:
        ret = FreezeState.FREEZE;
        break;
      case 2:
        ret = FreezeState.UNFREEZE;
        break;
    }
    return ret;
  }
}
