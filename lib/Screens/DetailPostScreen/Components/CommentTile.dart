import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Comment.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/CommentDetailScreen.dart';
import 'package:flutter_application_1/constant.dart';

class CommentTile extends StatefulWidget {
  CommentTile(
      {Key key,
      @required this.comment,
      this.numberOfReplies,
      this.onReplyClicked,
      this.avatarSizePercentage = 1})
      : super(key: key);

  final Comment comment;
  final int numberOfReplies;
  final Function(Comment comment) onReplyClicked;
  final double avatarSizePercentage;

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  Comment _comment;
  bool _commentLiked;

  ImageProvider _getUserAvatar(String userID) {
    // Todo: fetch user avatar from firebase, if user doesnot have avater return default avatar
    return Image.asset("assets/logo/default-group-avatar.png").image;
  }

  String _getOwnerName(String userID) {
    // Todo: Fetch data
    return "basa102";
  }

  String _getCommentLikedCount(String commentID) {
    // Todo: Fetch data
    return "153";
  }

  void _handleLikeComment(String commentID) {
    // Todo: Push data
    _commentLiked = !_commentLiked;
    setState(() {});
  }

  void _handleOnReplyTap(String commentID) {
    this.widget.onReplyClicked(this.widget.comment);
    print("tap reply");
  }

  void _moveToCommentDetail(String commentID) {
    // Todo: Move to screen CommentDetail
    print("move to comment detail");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentDetailScreen(
                  comment: this.widget.comment,
                )));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comment = this.widget.comment;

    // Todo: fetch data from server to known if comment was liked or not
    _commentLiked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: defaultPadding * 0.5, horizontal: defaultPadding * 0.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40 * (1 - this.widget.avatarSizePercentage),
                  height: 40 * (1 - this.widget.avatarSizePercentage),
                ),
                Container(
                    width: 40 * this.widget.avatarSizePercentage,
                    height: 40 * this.widget.avatarSizePercentage,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        image: _getUserAvatar(_comment.owner),
                        fit: BoxFit.cover,
                      ),
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: defaultPadding * 0.5, top: defaultPadding * 0.25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(children: [
                    Text(
                      _getOwnerName(_comment.owner),
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultPadding * 0.75),
                      child: Text(
                        _getDuration(_comment.createdDate),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 10, color: Colors.white54),
                      ),
                    ),
                  ]),

                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _comment.content,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      if (this.widget.comment.imgLink != null &&
                          this.widget.comment.imgLink != "")
                        CachedNetworkImage(
                            imageUrl: this.widget.comment.imgLink),
                    ],
                  ),
                  // Reply and like button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => this._handleOnReplyTap(_comment.id),
                        child: Container(
                          padding: EdgeInsets.only(
                              right: defaultPadding * 0.75,
                              top: defaultPadding * 0.5,
                              bottom: defaultPadding * 0.5),
                          child: Text(
                            "Reply",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    fontSize: 12,
                                    color: Colors.white54,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: defaultPadding * 1.5),
                        child: GestureDetector(
                          onTap: () => _handleLikeComment(_comment.id),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 0.75,
                                vertical: defaultPadding * 0.5),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _handleLikeComment(
                                      this.widget.comment.id),
                                  child: Icon(
                                    CupertinoIcons.heart_circle_fill,
                                    size: 18,
                                    color: _commentLiked == true
                                        ? Colors.red
                                        : Colors.white70,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: defaultPadding * 0.75),
                                    child: Text(
                                      _getCommentLikedCount(_comment.id),
                                      style: TextStyle(color: Colors.white70),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (this.widget.numberOfReplies != null &&
                      this.widget.numberOfReplies > 0)
                    // View more replies
                    GestureDetector(
                      onTap: () => _moveToCommentDetail(_comment.id),
                      child: Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 2, right: defaultPadding * 0.5, top: 3),
                              child: Icon(
                                CupertinoIcons.arrowtriangle_down_fill,
                                color: Colors.blue,
                                size: 10,
                              ),
                            ),
                            Text(
                              "View ${this.widget.numberOfReplies} replies",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
