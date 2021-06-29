import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/Reaction_Type.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/DetailPostScreen.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/UserCommentDetailScreen.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/Model/Reaction_Type.dart';

// this is a special post ui that instead of navigate to CommentDetailScreen,
// it navigate to UserCommentDetailScreen
class PostCommentUI extends StatefulWidget {
  final Post post;
  PostCommentUI({
    Key key,
    @required this.post,
    this.canNavigateToDetail = true,
    this.userModel,
  }) : super(key: key);

  final bool canNavigateToDetail;
  final UserModel userModel;

  @override
  _PostCommentUIState createState() => _PostCommentUIState();
}

class _PostCommentUIState extends State<PostCommentUI> {
  ReactionType _reactionType = ReactionType.none;
  double footerFontSize = 12;
  double footerIconSize = 27;

  String _likeCount = '1.8K';
  String _commentCount = '35K';

  ImageProvider _avatarImage;

  _PostUIState() {}

  @override
  void initState() {
    super.initState();

    // widget.group.getAvatar().then((value) => this.setState(() {
    //       _avatarImage = value;
    //     }));
  }

  void _handleLovedTap() {
    if (_reactionType == ReactionType.loved) {
      setState(() {
        _reactionType = ReactionType.none;
      });
    } else {
      setState(() {
        _reactionType = ReactionType.loved;
      });
    }
  }

  void _handleNotLoveTap() {
    if (_reactionType == ReactionType.notloved) {
      setState(() {
        _reactionType = ReactionType.none;
      });
    } else {
      setState(() {
        _reactionType = ReactionType.notloved;
      });
    }
  }

  void _handleShareTap() {}

  void _handleCommentTap() {
    if (widget.canNavigateToDetail) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserPostCommentDetailScreen(
                    postUI: this.widget,
                    userModel: this.widget.userModel,
                  )));
    }
  }

  void _handleUsernameTap() {}

  void _handle3DotTap() {}

  void _handleTitleTap() {
    if (widget.canNavigateToDetail) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserPostCommentDetailScreen(
                    postUI: this.widget,
                    userModel: this.widget.userModel,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Color.fromARGB(255, 5, 5, 5),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(left: defaultPadding * 0.75),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Avatar
                  /// this is a way for more customize circle avatar of a post //
                  Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                          image: _avatarImage != null
                              ? _avatarImage
                              : Image.asset(
                                      "assets/logo/default-group-avatar.png")
                                  .image,
                          fit: BoxFit.cover,
                        ),
                      )),

                  // the simple round avatar
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(50),
                  //   child: CachedNetworkImage(imageUrl: widget.group.avatar, width: 50, height: 50, fit: BoxFit.fill,),
                  // ),

                  // Owner name
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: defaultPadding * 0.5, top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: this._handleUsernameTap,
                                child: Text("${widget.post?.owner}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Colors.white54,
                                            fontSize: 12))),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(
                                CupertinoIcons.circle_fill,
                                size: 5,
                                color: Colors.white54,
                              ),
                            ),
                            Text("3d",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white54))
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 3 Dot
                  Padding(
                    padding: EdgeInsets.only(right: defaultPadding * 0.75),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                          onTap: this._handle3DotTap,
                          child: Icon(
                            Icons.more_horiz,
                            size: 35,
                            color: Colors.white54,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Title
          GestureDetector(
            onTap: _handleTitleTap,
            child: Padding(
              padding: EdgeInsets.fromLTRB(defaultPadding * 0.75, 0, 0, 5),
              child: Align(
                  child: Text(
                    widget.post.title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                  ),
                  alignment: Alignment.centerLeft),
            ),
          ),
          // Image
          CachedNetworkImage(
            imageUrl: widget.post.image,
            placeholder: (context, url) => CircularProgressIndicator(),
          ),
          // Footer
          Padding(
            padding: EdgeInsets.only(
                top: defaultPadding * 0.5,
                bottom: defaultPadding * 0.5,
                left: defaultPadding * 0.5),
            child: Row(
              children: [
                Spacer(),

                // Love && NotLove
                GestureDetector(
                  onTap: _handleLovedTap,
                  child: Icon(
                    _reactionType == ReactionType.loved
                        ? CupertinoIcons.heart_circle_fill
                        : CupertinoIcons.heart_circle,
                    size: this.footerIconSize * 1.2,
                    color: _reactionType == ReactionType.loved
                        ? Colors.redAccent.withAlpha(200)
                        : Colors.white54,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: defaultPadding),
                  child: Text(this._likeCount,
                      style: TextStyle(
                          fontSize: this.footerFontSize,
                          letterSpacing: 1.2,
                          wordSpacing: 2,
                          fontWeight: FontWeight.w900,
                          color: _reactionType == ReactionType.none
                              ? Colors.white54
                              : _reactionType == ReactionType.loved
                                  ? Colors.redAccent.withAlpha(200)
                                  : Colors.blue.withAlpha(200))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: defaultPadding),
                  child: GestureDetector(
                    onTap: _handleNotLoveTap,
                    child: Icon(
                      _reactionType == ReactionType.notloved
                          ? CupertinoIcons.heart_slash_circle_fill
                          : CupertinoIcons.heart_slash_circle,
                      size: this.footerIconSize * 1.2,
                      color: _reactionType == ReactionType.notloved
                          ? Colors.blue.withAlpha(200)
                          : Colors.white54,
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),

                // Comment
                GestureDetector(
                  onTap: this._handleCommentTap,
                  child: Center(
                      child: Row(children: [
                    Icon(
                      CupertinoIcons.bubble_left_fill,
                      color: Colors.white54,
                      size: this.footerIconSize * 0.8,
                    ),
                    Padding(
                        padding:
                            EdgeInsets.fromLTRB(defaultPadding * 0.5, 0, 0, 0),
                        child: Text(
                          this._commentCount,
                          style: TextStyle(
                              fontSize: this.footerFontSize,
                              color: Colors.white54,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.left,
                        )),
                  ])),
                ),
                Spacer(
                  flex: 2,
                ),
                // Share
                GestureDetector(
                  onTap: this._handleShareTap,
                  child: Container(
                    //color: Colors.green,
                    child: Center(
                        child: Row(children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                          child: Icon(
                            CupertinoIcons.share_solid,
                            color: Colors.white54,
                            size: this.footerIconSize * 0.75,
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              defaultPadding * 0.5, 0, 0, 0),
                          child: Text(
                            'Share',
                            style: TextStyle(
                                fontSize: this.footerFontSize,
                                color: Colors.white54),
                            textAlign: TextAlign.left,
                          )),
                    ])),
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
