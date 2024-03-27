class WeGroupUserInfo {
  String clientRemarkName = "";
  String headPortrait = "";
  String nickname = "";
  String clientId = "";
  String clientAttribute = "";
  String memberAttributes = "";

  WeGroupUserInfo(
      {this.clientRemarkName = "",
      this.headPortrait = "",
      this.nickname = "",
      this.clientId = "",
      this.clientAttribute = "",
      this.memberAttributes = ""});

  factory WeGroupUserInfo.fromJson(Map<String, dynamic> json) {
    return WeGroupUserInfo(
      clientRemarkName: json['clientRemarkName'],
      headPortrait: json['headPortrait'],
      nickname: json['nickname'],
      clientId: json['clientId'],
      clientAttribute: json['clientAttribute'],
      memberAttributes: json['memberAttributes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'clientRemarkName': clientRemarkName,
        'headPortrait': headPortrait,
        'nickname': nickname,
        'clientId': clientId,
        'clientAttribute': clientAttribute,
        'memberAttributes': memberAttributes,
      };
}
