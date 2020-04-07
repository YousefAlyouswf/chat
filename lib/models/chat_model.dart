class Chat {
  String id;
  String yourEmail;
  String hisEmail;
  String lastSent;
  String readMsg;
  String text;
  String yourGender;
  String hisGender;
  String yourImage;
  String hisImage;
  String yourOnline;
  String hisOnline;
  String yourCode;
  String hisCode;
  String yourName;
  String hisName;

  Chat({
    this.id,
    this.yourEmail,
    this.hisEmail,
    this.lastSent,
    this.readMsg,
    this.text,
    this.yourGender,
    this.hisGender,
    this.yourImage,
    this.hisImage,
    this.yourOnline,
    this.hisOnline,
    this.yourCode,
    this.hisCode,
    this.yourName,
    this.hisName,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      yourEmail: json['email1'] as String,
      hisEmail: json['email2'] as String,
      lastSent: json['email_sent'] as String,
      readMsg: json['readMsg'] as String,
      text: json['text'] as String,
      yourGender: json['gender1'] as String,
      hisGender: json['gender2'] as String,
      yourImage: json['image1'] as String,
      hisImage: json['image2'] as String,
      yourOnline: json['online1'] as String,
      hisOnline: json['online2'] as String,
      yourCode: json['code1'] as String,
      hisCode: json['code2'] as String,
      yourName: json['name1'] as String,
      hisName: json['name2'] as String,
    );
  }
}
