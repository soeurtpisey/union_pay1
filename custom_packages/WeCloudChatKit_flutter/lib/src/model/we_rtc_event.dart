enum WeRTCType {
  VIDEO, // 视频
  VOICE, // 语音
}

extension WeRTCTypeValue on WeRTCType {
  int get value {
    int ret = 0;
    switch (this) {
      case WeRTCType.VIDEO:
        ret = 1;
        break;
      case WeRTCType.VOICE:
        ret = 2;
        break;
    }
    return ret;
  }

  static WeRTCType typeFromInt(int? type) {
    WeRTCType ret = WeRTCType.VIDEO;
    switch (type) {
      case 1:
        ret = WeRTCType.VIDEO;
        break;
      case 2:
        ret = WeRTCType.VOICE;
        break;
    }
    return ret;
  }
}

class WeRTCEvent {
  int? subCmd;
  int? conversationId;
  WeRTCType? callType;
  int? channelId;
  int? timestamp;
  String? clientId;
  String? sdpData;
  String? sdpType;
  String? candidateData;

  WeRTCEvent({
    this.subCmd,
    this.conversationId,
    this.callType = WeRTCType.VIDEO,
    this.channelId,
    this.timestamp,
    this.clientId,
    this.sdpData,
    this.sdpType,
    this.candidateData,
  });

  factory WeRTCEvent.fromJson(Map<String, dynamic> json) {
    return WeRTCEvent(
      subCmd: json['subCmd'],
      conversationId: json['conversationId'] == null?null :json['conversationId'],
      callType: json['callType'] == null? null: WeRTCTypeValue.typeFromInt(json['callType']),
      channelId: json['channelId'],
      timestamp: json['timestamp'] == null? null:json['timestamp'],
      clientId: json['clientId'],
      sdpData: json['sdpData'] == null?null :json['sdpData'],
      sdpType: json['sdpType'] == null? null: json['sdpType'],
      candidateData: json['candidateData'] == null? null:json['candidateData']
    );
  }

  Map<String, dynamic> toJson() => {
        'subCmd': subCmd,
        'conversationId': conversationId,
        'callType': callType!.value,
        'channelId': channelId,
        'timestamp': timestamp,
        'clientId': clientId,
        'sdpData': sdpData,
        'sdpType': sdpType,
        'candidateData': candidateData,
      };
}
