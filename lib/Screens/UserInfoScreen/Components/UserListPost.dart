import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/constant.dart';

class UserListPost extends StatefulWidget {
  UserListPost({Key key, @required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  _UserListPostState createState() => _UserListPostState();
}

class _UserListPostState extends State<UserListPost> {
  List<PostUI> _listMinePost;
  bool _loading = false;
  bool _hasMore = true;
  QueryDocumentSnapshot lastSnapshot;

  Future<void> getMorePost() async {
    // load and add more mine post to _listMinePost from firebase

    // this is just a demo
    if (_loading) return;

    _loading = true;

    var minePostQuery = FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isEqualTo: "false")
        .where("owner", isEqualTo: widget.userModel.username)
        .orderBy("createdDate", descending: true)
        .startAfterDocument(lastSnapshot)
        .limit(10);

    var minePostQSnap = await minePostQuery.get();

    if (minePostQSnap.docs.length != 0) {
      lastSnapshot = minePostQSnap.docs[minePostQSnap.docs.length - 1];
    }

    for (var postSnap in minePostQSnap.docs) {
      Post post = Post.fromJson(postSnap.data());

      _listMinePost.add(PostUI(
        post: post,
      ));
    }

    if (minePostQSnap.docs.length < 10) _hasMore = false;

    setState(() {
      _loading = false;
    });
  }

  Future<void> initListMinePost() async {
    if (_loading) return;

    _listMinePost.clear();

    _loading = true;

    var minePostQuery = FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isEqualTo: "false")
        .where("owner", isEqualTo: widget.userModel.username)
        .where("createdDate", isNotEqualTo: "")
        .orderBy("createdDate", descending: true)
        .limit(10);

    var minePostQSnap = await minePostQuery.get();

    if (minePostQSnap.docs.length != 0) {
      lastSnapshot = minePostQSnap.docs[minePostQSnap.docs.length - 1];
    }

    for (var postSnap in minePostQSnap.docs) {
      Post post = Post.fromJson(postSnap.data());

      _listMinePost.add(PostUI(
        post: post,
      ));
    }

    if (_listMinePost.length < 10) _hasMore = false;

    _loading = false;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listMinePost = [];
    initListMinePost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          final maxScroll = scrollNotification.metrics.maxScrollExtent;
          final currentScroll = scrollNotification.metrics.pixels;

          if (maxScroll == currentScroll) {
            getMorePost();
            return;
          }
          return;
        },
        child: RefreshIndicator(
          onRefresh: initListMinePost,
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (index == _listMinePost.length && _hasMore) {
                return CupertinoActivityIndicator(
                  radius: defaultPadding,
                );
              } else if (index < _listMinePost.length) {
                return _listMinePost[index];
              } else {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
