import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Comment.dart';
import 'package:flutter_application_1/Model/Notification.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/NotificationScreens/Components/NotificationPostDetail.dart';
import 'package:flutter_application_1/constant.dart';

class ReplyNotification extends StatefulWidget {
  const ReplyNotification({Key key, @required this.notiModel})
      : super(key: key);

  final NotificationModel notiModel;

  @override
  _ReplyNotificationState createState() => _ReplyNotificationState();
}

class _ReplyNotificationState extends State<ReplyNotification> {
  UserModel _actorModel;
  Comment _comment;

  ImageProvider getAvatar() {
    return AssetImage("assets/logo/default-group-avatar.png");
  }

  String _getDuration(DateTime dateTime) {
    Duration ageDuration = DateTime.now().difference(dateTime);

    if (ageDuration.inDays >= 365) {
      return "${ageDuration.inDays / 365}y";
    } else if (ageDuration.inDays >= 30) {
      return "${ageDuration.inDays / 30}m";
    } else if (ageDuration.inDays > 0) {
      return "${ageDuration.inDays}d";
    } else if (ageDuration.inHours > 0) {
      return "${ageDuration.inHours}h";
    } else {
      return "${ageDuration.inMinutes} minutes";
    }
  }

  void _goToNotificationPostDetail() {
    Post post = Post();
    post.owner = "Basa102";
    post.title = "The funniest meme i have ever seen";
    post.image =
        "https://preview.redd.it/lwf895ptel571.png?width=960&crop=smart&auto=webp&s=f11838f1f6f95ae4da8fe9e1196396c6b15e0074";
    PostUI postUI = PostUI(post: post);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationPostDetail(
                  postUI: postUI,
                )));
  }

  Future<void> _loadActor() async {
    var _actorSnap = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: this.widget.notiModel.actor)
        .get();

    _actorModel = UserModel();
    _actorModel.fromMap(_actorSnap.docs[0].data());

    setState(() {});
  }

  Future<void> _loadComment() async {
    var _commentSnap = await FirebaseFirestore.instance
        .collection("post")
        .doc(widget.notiModel.postId)
        .collection("comment")
        .doc(widget.notiModel.commentId)
        .get();

    var _postSnap = await FirebaseFirestore.instance
        .collection("post")
        .doc(widget.notiModel.postId)
        .get();

    var post = Post.fromJson(_postSnap.data());

    _comment = Comment.fromJson(_commentSnap.data(), post);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Todo: from widget.notiModel, load _actor and _comment
    _loadActor();
    _loadComment();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToNotificationPostDetail,
      child: Padding(
        padding: EdgeInsets.only(
            left: defaultPadding * 0.5,
            top: defaultPadding,
            bottom: defaultPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: getAvatar(), fit: BoxFit.cover)),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding * 0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _actorModel == null
                              ? ""
                              : "${_actorModel.displayName}",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                              wordSpacing: 0.7,
                              fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                          text: " has replies to your post",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.3,
                              wordSpacing: 0.7,
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(children: [
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 7,
                                  left: defaultPadding * 0.5,
                                  right: defaultPadding * 0.5),
                              child: Icon(
                                CupertinoIcons.circle_fill,
                                size: 5,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          TextSpan(
                              text: _comment == null
                                  ? ""
                                  : "${_getDuration(_comment.createdDate)}",
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0.3,
                                  wordSpacing: 0.7,
                                  color: Colors.white70)),
                        ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: defaultPadding * 0.2),
                    child: _comment != null
                        ? Text(
                            "${_comment.content}",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.3,
                                wordSpacing: 0.7,
                                color: Colors.white70),
                          )
                        : null,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
