import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as db;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/NullableImage.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/Group.dart';
import 'package:flutter_application_1/Model/Reaction.dart';
import 'package:flutter_application_1/Model/Reaction_Type.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/DetailPostScreen.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:http/http.dart';

class PostUI extends StatefulWidget {
  final Post post;
  PostUI({
    Key key,
    @required this.post,
    this.canNavigateToDetail = true,
  }) : super(key: key);

  final bool canNavigateToDetail;

  @override
  _PostUIState createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {
  ReactionType _reactionType = ReactionType.none;
  ReactionType get reaction {
    return _reaction?.reaction ?? _reactionType;
  }

  set reaction(value) {
    if (_reaction == null)
      _reactionType = value;
    else
      _reaction.reaction = value;
    onReactionChanged();
  }

  double footerFontSize = 12;
  double footerIconSize = 27;

  String _likeCount = '1.8K';
  String _commentCount = '35K';

  ImageProvider _avatarImage;

  _PostUIState() {}
  db.CollectionReference reactionPath;
  db.Query reactionQuery;
  Reaction _reaction;

  @override
  void initState() {
    super.initState();
    initReactionQuery();

    var query = db.FirebaseFirestore.instance
        .collection("post")
        .doc(widget.post.id)
        .collection("comment")
        .where("isDeleted", isNotEqualTo: "true");

    query.get().then((value) {
      this.setState(() {
        _commentCount = value.size.toString();
      });
    });
    query.snapshots().listen((value) {
      this.setState(() {
        _commentCount = value.size.toString();
      });
    });

    // widget.group.getAvatar().then((value) => this.setState(() {
    //       _avatarImage = value;
    //     }));
  }

  void initReactionQuery() {
    reactionPath = db.FirebaseFirestore.instance
        .collection("post")
        .doc(widget.post.id)
        .collection("reaction");
    reactionQuery = reactionPath.where("owner",
        isEqualTo: UserCredentialService.instance.model);
    reactionQuery.get().then((value) {
      if (value == null || value.size == 0) return;
      setState(() {
        _reaction = Reaction.fromJson(value.docs[0].data());

        if (_reaction == null) {
          _reaction = new Reaction();
          _reaction.item = widget.post.id;
          _reaction.owner = UserCredentialService.instance.model.username;
          _reaction.reaction = ReactionType.none;
          _reaction.createdDate = DateTime.now();

          _reaction.upload(reactionPath);
        }
      });
    });

    reactionQuery.snapshots().listen((value) {
      if (value == null || value.docs == null || value.docs.length == 0) return;
      setState(() {
        _reaction = Reaction.fromJson(value.docs[0].data());
      });
    });
  }

  void _handleLovedTap() {
    if (reaction == ReactionType.loved) {
      setState(() {
        reaction = ReactionType.none;
      });
    } else {
      setState(() {
        reaction = ReactionType.loved;
      });
    }
  }

  void _handleNotLoveTap() {
    if (reaction == ReactionType.hated) {
      setState(() {
        reaction = ReactionType.none;
      });
    } else {
      setState(() {
        reaction = ReactionType.hated;
      });
    }
  }

  void _handleShareTap() {}

  void _handleCommentTap() {
    if (widget.canNavigateToDetail) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPostScreen(
                    postUI: this.widget,
                  )));
    }
  }

  void onReactionChanged() {
    _reaction.upload(reactionPath);
  }

  void _handleUsernameTap() {}

  void _handle3DotTap() {}

  void _handleTitleTap() {
    if (widget.canNavigateToDetail) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPostScreen(
                    postUI: this.widget,
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
                    reaction == ReactionType.loved
                        ? CupertinoIcons.heart_circle_fill
                        : CupertinoIcons.heart_circle,
                    size: this.footerIconSize * 1.2,
                    color: reaction == ReactionType.loved
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
                          color: reaction == ReactionType.none
                              ? Colors.white54
                              : reaction == ReactionType.loved
                                  ? Colors.redAccent.withAlpha(200)
                                  : Colors.blue.withAlpha(200))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: defaultPadding),
                  child: GestureDetector(
                    onTap: _handleNotLoveTap,
                    child: Icon(
                      reaction == ReactionType.hated
                          ? CupertinoIcons.heart_slash_circle_fill
                          : CupertinoIcons.heart_slash_circle,
                      size: this.footerIconSize * 1.2,
                      color: reaction == ReactionType.hated
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

class ListPostUI extends StatefulWidget {
  ListPostUI({Key key}) : super(key: key);

  @override
  _ListPostUIState createState() => _ListPostUIState();
}

class _ListPostUIState extends State<ListPostUI> {
  db.QuerySnapshot snapshot;

  _ListPostUIState() {
    var query = db.FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isNotEqualTo: "true");
    query.get().then((value) {
      this.setState(() {
        snapshot = value;
      });
    });
    query.snapshots().listen((value) {
      this.setState(() {
        snapshot = value;
      });
    });
  }

  Widget itemBuilder(BuildContext context, int index) {
    return PostUI(
      post: Post.fromJson(snapshot.docs[index].data()),
    );
  }

  separatorBuilder(BuildContext context, int index) => Divider(
        height: 10.0,
      );

  int itemCount() => snapshot.size;
  static int _computeActualChildCount(int itemCount) {
    return max(0, itemCount * 2 - 1);
  }

  @override
  Widget build(BuildContext context) {
    return /*
        Container(
      child: Expanded(
        flex: 100,
        child: SizedBox(
          height: 400,
          width: 400,
          child:
              // */
        SliverList(
      delegate: SliverChildBuilderDelegate(
        // Copied from ListView :)
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          Widget widget;
          if (index.isEven) {
            widget = itemBuilder(context, itemIndex);
          } else {
            widget = separatorBuilder(context, itemIndex);
            assert(() {
              if (widget == null) {
                // ignore: dead_code
                throw FlutterError('separatorBuilder cannot return null.');
              }
              return true;
            }());
          }
          return widget;
        },
        childCount: _computeActualChildCount(itemCount()),
      ),

      /*
          ),
        ),
      ), // */
    );
  }
}
