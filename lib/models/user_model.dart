class Users {
  String id;
  String name;
  String email;
  String gender;
  String password;
  String image;
  String code;
  String online;
  String country;
  String ip;

  Users({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.password,
    this.image,
    this.code,
    this.online,
    this.country,
    this.ip,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as String,
      name: json['user'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      password: json['password'] as String,
      image: json['image'] as String,
      code: json['code'] as String,
      online: json['online'] as String,
      country: json['country'] as String,
      ip: json['ip'] as String,
    );
  }
}
