class WeChatRoomMember {
  int? chatRoomId; //	聊天室房间id	integer(int64)
  String? clientId; //	客户端id	string

  WeChatRoomMember({this.chatRoomId, this.clientId});

  factory WeChatRoomMember.fromJson(Map<String, dynamic> json) {
    return WeChatRoomMember(
      chatRoomId: json['chatRoomId'],
      clientId: json['clientId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatRoomId': chatRoomId,
        'clientId': clientId,
      };
}
