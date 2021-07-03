class NotificationModel {
  String postId;
  String actor;
  String commentId;
  String receiver;
  String id;
  DateTime createdDate;

  void fromJson(Map<String, dynamic> json) {
    postId = json["postId"];
    actor = json["actor"];
    commentId = json["commentId"];
    receiver = json["receiver"];
    id = json["id"];
    if (json["createdDate"] != null) {
      createdDate = DateTime.parse(json["createdDate"]);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["postId"] = postId;
    json["actor"] = actor;
    json["commentId"] = commentId;
    json["receiver"] = receiver;
    json["id"] = id;
    if (createdDate == null) {
      createdDate = DateTime.now();
    }
    json["createdDate"] = createdDate.toString();

    return json;
  }
}
