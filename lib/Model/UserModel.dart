class UserModel {
  String username;
  String email;
  String password;
  DateTime createdDate;
  String stars;

  UserModel({this.username, this.email, this.password, this.createdDate, this.stars}) {
    if(this.createdDate == null) {
      this.createdDate = DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    map["createdDate"] = createdDate.toIso8601String();
    map["stars"] = stars;

    return map;
  }
}