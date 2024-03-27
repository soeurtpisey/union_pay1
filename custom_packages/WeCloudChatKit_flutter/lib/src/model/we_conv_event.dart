import 'package:wecloudchatkit_flutter/src/model/we_message_type.dart';

class WeConvEvent {
  int? conversationId;
  int? msgId;
  WeMessageType? type;
  String? sender;
  String? operator;
  String? name;
  String? headPortrait; //会话头像改动
  String? attributes;
  String? passivityOperator;
  String? remarkName;

  WeConvEvent(
      {this.conversationId,
      this.msgId,
      this.type,
      this.sender,
      this.operator,
      this.name,
      this.headPortrait,
      this.attributes,
      this.passivityOperator,
      this.remarkName});

  factory WeConvEvent.fromJson(Map<String, dynamic> json) {
    return WeConvEvent(
      conversationId: json['conversationId'],
      msgId: json['msgId'],
      type: WeMsgTypeValue.msgTypeFromInt(json['type']),
      sender: json['sender'],
      operator: json['operator'],
      name: json['name'],
      headPortrait: json['headPortrait'],
      attributes: json['attributes'],
      passivityOperator: json['passivityOperator'],
      remarkName: json['remarkName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'msgId': msgId,
        'type': type?.value,
        'sender': sender,
        'operator': operator,
        'name': name,
        'headPortrait': headPortrait,
        'attributes': attributes,
        'passivityOperator': passivityOperator,
        'remarkName': remarkName,
      };

// WeMessage? message;

}
