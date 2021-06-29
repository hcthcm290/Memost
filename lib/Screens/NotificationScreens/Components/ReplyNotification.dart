import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Comment.dart';
import 'package:flutter_application_1/constant.dart';

class ReplyNotification extends StatefulWidget {
  const ReplyNotification({Key key}) : super(key: key);

  //final NotificationModel _notiModel;

  @override
  _ReplyNotificationState createState() => _ReplyNotificationState();
}

class _ReplyNotificationState extends State<ReplyNotification> {
  String _actor = "Basa Google";
  Comment _comment;

  ImageProvider getAvatar() {
    return AssetImage("assets/logo/default-group-avatar.png");
  }

  @override
  void initState() {
    super.initState();

    // Todo: from widget.notiModel, load _actor and _comment
    _comment = Comment();
    _comment.content = "Nice meme, it make my day, thank you";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                image: DecorationImage(image: getAvatar(), fit: BoxFit.cover)),
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
                        text: "$_actor",
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
                            text: "2h",
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
    );
  }
}
