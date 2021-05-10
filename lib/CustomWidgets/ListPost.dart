
import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/Group.dart';
import 'package:flutter_application_1/Model/Reaction_Type.dart';

class PostUI extends StatefulWidget {

  final Post post;
  final Group group;

  PostUI({Key key, @required  this.post, @required this.group})
    :
    super(key: key);

  @override
  _PostUIState createState() => _PostUIState();
}

enum ReactionType {
    none,
    loved,
    notloved
}

class _PostUIState extends State<PostUI> {

  ReactionType _reactionType = ReactionType.none;
  double footerFontSize = 12;
  double footerIconSize = 25;

  String _likeCount = '1.8K';
  String _commentCount = '35K';

  void _handleLovedTap() {
    if(_reactionType == ReactionType.loved)
    {
      setState(() {
        _reactionType = ReactionType.none;
      });
    }
    else
    {
      setState(() {
        _reactionType = ReactionType.loved;
      });
    }
  }

  void _handleNotLoveTap() {
    if(_reactionType == ReactionType.notloved)
    {
      setState(() {
        _reactionType = ReactionType.none;
      });
    }
    else
    {
      setState(() {
        _reactionType = ReactionType.notloved;
      });
    }
  }

  void _handleShareTap() {

  }

  void _handleCommentTap() {

  }

  void _handleGroupNameTap() {

  }

  void _handleUsernameTap() {

  }

  void _handle3DotTap() {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Color.fromARGB(255, 0, 0, 0),
      child: Column(
        children: [ 
          // Header
          IntrinsicHeight(
            child: Row(
              children: [
                // Avatar
                /// this is a way for more customize circle avatar of a post //
                Container(
                  width: 50,
                  height: 50,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(image: CachedNetworkImageProvider(widget.group.avatar), fit: BoxFit.cover)
                    
                  ),
                ),
                Container(
                  width: 5,
                  height: 50,
                  color: Colors.black,
                ),
                
                // the simple round avatar
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(50),
                //   child: CachedNetworkImage(imageUrl: widget.group.avatar, width: 50, height: 50, fit: BoxFit.fill,),
                // ),

                // Title
                Expanded(
                  child: Column(
                    children: [
                      Spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: this._handleGroupNameTap,
                          child: Text("r/${widget.group.name}", style: TextStyle(fontSize: 20, color: Colors.white),)
                        )
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: this._handleUsernameTap,
                              child: Text("u/${widget.post.owner}", style: TextStyle(fontSize: 15, color: Colors.white))
                            ),
                            Spacer(flex: 1,),
                            //Icon(Icons.album, color: Colors.white, size: 10,),
                            Spacer(flex: 1,),
                            Text("3 Days ago", style: TextStyle(fontSize: 15, color: Colors.white))
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                
                Container(
                  width: 15,
                  height: 50,
                  color: Colors.black,
                ),

                // 3 Dot
                GestureDetector(
                  onTap: this._handle3DotTap,
                  child: Icon(Icons.more_horiz, size: 40, color: Colors.white,)
                )
              ],
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Align(
              child: Text(widget.post.title, style: TextStyle(fontSize: 18, color: Colors.white)), 
              alignment: Alignment.centerLeft
            ),
          ),
          // Image
          CachedNetworkImage(imageUrl: widget.post.image, placeholder: (context, url) => CircularProgressIndicator(),),
          // Footer
          Row(
            children: [
              // Love && NotLove
              Container(
                width: 110,
                height: 50,
                //color: Colors.blue,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _handleLovedTap,
                      child: Icon(
                        _reactionType == ReactionType.loved ? CupertinoIcons.heart_fill : CupertinoIcons.heart, 
                        size: this.footerIconSize, 
                        color: _reactionType == ReactionType.loved ? Colors.redAccent : Colors.white,
                      ),
                    ),
                    Spacer(flex: 1,),
                    Text(this._likeCount, 
                      style: TextStyle(
                        fontSize: this.footerFontSize, fontWeight: FontWeight.w800,
                        color: _reactionType == ReactionType.none 
                          ? Colors.white 
                          : _reactionType == ReactionType.loved
                            ? Colors.redAccent
                            : Colors.blue
                      )
                    ),
                    Spacer(flex: 1,),
                    GestureDetector(
                      onTap: _handleNotLoveTap,
                      child: Icon(
                        _reactionType == ReactionType.notloved ? CupertinoIcons.heart_slash_fill : CupertinoIcons.heart_slash, 
                        size: this.footerIconSize, 
                        color: _reactionType == ReactionType.notloved ? Colors.blue : Colors.white,
                      ),
                    ),
                    Spacer(flex: 10)
                  ], 
                ),
              ),
              Spacer(flex: 1,),
              // Comment
              GestureDetector(
                onTap: this._handleCommentTap,
                child: Container(
                  width: 80,
                  height: 50,
                  //color: Colors.pink,
                  child: Center(
                    child: Row(
                      children: [
                        Spacer(flex: 3,),
                        Icon(CupertinoIcons.bubble_left, color: Colors.white, size: this.footerIconSize,),
                        Spacer(flex: 1),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(this._commentCount, style: TextStyle(fontSize: this.footerFontSize, color: Colors.white, fontWeight: FontWeight.w800), textAlign: TextAlign.left,)
                        ),
                        Spacer(flex: 3,),
                      ]
                    )
                  ),
                ),
              ),
              Spacer(flex: 10,),
              // Share
              GestureDetector(
                onTap: this._handleShareTap,
                child: Container(
                  width: 80,
                  height: 50,
                  //color: Colors.green,
                  child: Center(
                    child: Row(
                      children: [
                        Spacer(),
                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 6),child: Icon(CupertinoIcons.share, color: Colors.white, size: this.footerIconSize,)),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text('Share', style: TextStyle(fontSize: this.footerFontSize, color: Colors.white), textAlign: TextAlign.left,)
                        ),
                        Spacer(),
                      ]
                    )
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}