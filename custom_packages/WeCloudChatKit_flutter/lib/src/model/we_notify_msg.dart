class WeNotifyMsg {
  String title = "";
  String subTitle = "";

  WeNotifyMsg({this.title = "", this.subTitle = ""});

  factory WeNotifyMsg.fromJson(Map<String, dynamic> json) {
    return WeNotifyMsg(title: json['title'], subTitle: json['subTitle']);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subTitle': subTitle,
      };
}
