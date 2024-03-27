class WeError {
  WeError._private([this._code, this._description]);

  int? _code = 0;
  String? _description;

  get code {
    return _code;
  }

  get description {
    return _description;
  }

  factory WeError.fromJson(Map map) {
    print("WeError:${map.toString()}");
    return WeError._private()
      .._code = map['code']
      .._description = _getDesc(map['code'], map['description']);
  }

  static hasError(Map map) {
    if (map['error'] == null) {
      return;
    } else {
      try {
        throw (WeError.fromJson(map['error']));
      } on Exception {}
    }
  }

  @override
  String toString() {
    return "code: " + _code.toString() + " desc: " + _description!;
  }

  static String _getDesc(int code, String? description) {
    String desc = "";
    switch (code) {
      case 401:
        desc = "非法访问";
        break;
      case 403:
        desc = "没有权限";
        break;
      case 404:
        desc = "你请求的资源不存在";
        break;
      case 500:
        desc = "操作失败";
        break;
      case 4000:
        desc = "登录失败";
        break;
      case 5000:
        desc = "系统异常";
        break;
      case 5001:
        desc = "请求参数校验异常";
        break;
      case 5002:
        desc = "请求参数解析异常";
        break;
      case 5003:
        desc = "HTTP内容类型异常";
        break;
      case 5100:
        desc = "系统处理异常";
        break;
      case 5101:
        desc = description ?? '业务处理异常'; //"业务处理异常";
        break;
      case 5102:
        desc = "数据库处理异常";
        break;
      case 5103:
        desc = "验证码校验异常";
        break;
      case 5104:
        desc = "登录授权异常";
        break;
      case 5105:
      case 5106:
        desc = "没有访问权限";
        break;
      case 5107:
        desc = "JWT Token解析异常";
        break;
      case 5108:
        desc = "默认的异常处理";
        break;
      case 6010:
        desc = "已有会话,不能重复创建会话";
        break;
      case 6011:
        desc = "成员不存在,不能创建会话";
        break;
      case 6012:
        desc = "被对方拉黑";
        break;
      case 6013:
        desc = "你把对方拉黑";
        break;
      case 6014:
        desc = "已被踢出会话";
        break;
      case 6015:
        desc = "已被禁言";
        break;
      case 6016:
        desc = "群已解散";
        break;
      case 100:
        desc = "WeCloud服务器连接失败";
        break;
      case 124:
        desc = "请求超时";
        break;
      default:
        desc = description ?? "未知错误";
        break;
    }
    return desc;
  }
}
