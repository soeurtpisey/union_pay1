enum PushChannel { UPUSH, VIVO, OPPO, XIAOMI, HUAWEI, FIREBASE }

extension PushChannelValue on PushChannel {
  String get value {
    String ret = "";
    switch (this) {
      case PushChannel.UPUSH:
        ret = "UPUSH";
        break;
      case PushChannel.VIVO:
        ret = "VIVO";
        break;
      case PushChannel.OPPO:
        ret = "OPPO";
        break;
      case PushChannel.XIAOMI:
        ret = "XIAOMI";
        break;
      case PushChannel.HUAWEI:
        ret = "HUAWEI";
        break;
      case PushChannel.FIREBASE:
        ret = "FIREBASE";
        break;
    }
    return ret;
  }

  static PushChannel valueFromString(String? value) {
    PushChannel ret = PushChannel.UPUSH;
    switch (value) {
      case "UPUSH":
        ret = PushChannel.UPUSH;
        break;
      case "VIVO":
        ret = PushChannel.VIVO;
        break;
      case "OPPO":
        ret = PushChannel.OPPO;
        break;
      case "XIAOMI":
        ret = PushChannel.XIAOMI;
        break;
      case "HUAWEI":
        ret = PushChannel.HUAWEI;
        break;
      case "FIREBASE":
        ret = PushChannel.FIREBASE;
        break;
    }
    return ret;
  }
}
