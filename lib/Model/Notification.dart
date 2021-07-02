class NotificationModel {
  String postId;
  String actor;
  String commentId;
  String receiver;
  String id;

  void fromJson(Map<String, dynamic> json) {
    postId = json["postId"];
    actor = json["actor"];
    commentId = json["commentId"];
    receiver = json["receiver"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["postId"] = postId;
    json["actor"] = actor;
    json["commentId"] = commentId;
    json["receiver"] = receiver;
    json["id"] = id;

    return json;
  }
}
