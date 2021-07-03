class UserModel {
  String username;
  String email;
  String password;
  DateTime createdDate;
  String stars;
  String avatarUrl;
  String id;
  String description;
  String displayName;

  UserModel(
      {this.username,
      this.email,
      this.password,
      this.createdDate,
      this.stars,
      this.avatarUrl}) {
    if (this.createdDate == null) {
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
    map["avatarUrl"] = avatarUrl;
    map["description"] = description;
    map["displayName"] = displayName;

    return map;
  }

  void fromMap(Map<String, dynamic> map) {
    username = map["username"];
    email = map["email"];
    password = map["createdDate"];
    createdDate = DateTime.parse(map["createdDate"]);
    stars = map["stars"];
    avatarUrl = map["avatarUrl"];
    description = map["description"];
    displayName = map["displayName"];
  }
}
