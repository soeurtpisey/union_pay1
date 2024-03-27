/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/14 18:35
/// @Description: 审核状态
/// /////////////////////////////////////////////

enum AuditState {
  //默认
  normal,
  //进行中
  loading,
  //成功
  success,
  //拒绝
  failed,
  //未知
  unKnow
}

extension AuditStateValue on AuditState {
  int get value {
    var ret = -1;
    switch (this) {
    //待认证
      case AuditState.normal:
        ret = -1;
        break;
      case AuditState.loading: //未认证
        ret = 0;
        break;
      case AuditState.success: //认证成功
        ret = 1;
        break;
      case AuditState.failed: //认证拒绝
        ret = 2;
        break;
      default: //未知
        ret = -1000;
        break;
    }

    return ret;
  }

  static AuditState msgTypeFromInt(int? type) {
    var ret = AuditState.unKnow;
    switch (type) {
      case -1:
        ret = AuditState.normal;
        break;
      case 0:
        ret = AuditState.loading;
        break;
      case 1:
        ret = AuditState.success;
        break;
      case 2:
        ret = AuditState.failed;
        break;
      default:
        ret = AuditState.unKnow;
        break;
    }
    return ret;
  }
}
