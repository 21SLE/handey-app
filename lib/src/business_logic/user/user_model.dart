class UserModel {
  int userId;
  String userName;
  String email;
  String password;
  String resetTime;
  String theme;

  UserModel({this.userName, this.email, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['username'];
    email = json['email'];
    password = json['password'];
    resetTime = json['resetTime'];
    theme = json['theme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.userName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['resetTime'] = this.resetTime;
    data['theme'] = this.theme;
    return data;
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, password: $password, username: $userName, resetTime: $resetTime, theme: $theme}';
  }

}
