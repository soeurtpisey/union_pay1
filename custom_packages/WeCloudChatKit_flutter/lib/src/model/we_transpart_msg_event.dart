enum WeTransparentEventType {
  /// 业务层
  TransparentNumber,

  /// 音视频接听
  AudioAndVideoAnswering,

  /// 音视频拒绝
  AudioAndVideoRejection,

  /// 消息已读
  ConversationMsgRead,
}

extension WeTransparentEventTypeValue on WeTransparentEventType {
  int get value {
    int ret = 0;
    switch (this) {
      case WeTransparentEventType.TransparentNumber:
        ret = -10000;
        break;
      case WeTransparentEventType.AudioAndVideoAnswering:
        ret = -2301;
        break;
      case WeTransparentEventType.AudioAndVideoRejection:
        ret = -2302;
        break;
      case WeTransparentEventType.ConversationMsgRead:
        ret = -2501;
        break;
    }
    return ret;
  }

  static WeTransparentEventType typeFromInt(int? type) {
    WeTransparentEventType ret = WeTransparentEventType.TransparentNumber;
    switch (type) {
      case -10000:
        ret = WeTransparentEventType.TransparentNumber;
        break;
      case -2301:
        ret = WeTransparentEventType.AudioAndVideoAnswering;
        break;
      case -2302:
        ret = WeTransparentEventType.AudioAndVideoRejection;
        break;
      case -2501:
        ret = WeTransparentEventType.ConversationMsgRead;
        break;
    }
    return ret;
  }
}

class WeTransparentEvent {
  WeTransparentEventType? subCmd;
  int? timestamp;
  String? clientId;
  Map<String, dynamic>? attribute;
  String? content;
  int? clientCmd;

  WeTransparentEvent({
    this.subCmd,
    this.timestamp,
    this.clientId,
    this.attribute,
    this.content,
    this.clientCmd,
  });

  factory WeTransparentEvent.fromJson(Map<String, dynamic> json) {
    return WeTransparentEvent(
      subCmd: WeTransparentEventTypeValue.typeFromInt(json['subCmd']),
      timestamp: json['timestamp'] == null ? null : json['timestamp'],
      clientId: json['clientId'],
      attribute: json['attribute'],
      content: json['content'] == null ? null : json['content'],
      clientCmd: json['clientCmd'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'subCmd': subCmd?.value,
        'timestamp': timestamp,
        'clientId': clientId,
        'attribute': attribute,
        'content': content,
        'clientCmd': clientCmd,
      };
}
