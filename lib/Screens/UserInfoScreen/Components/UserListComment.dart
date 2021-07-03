import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/PostCommentUI.dart';
import 'package:flutter_application_1/constant.dart';

class UserListComment extends StatefulWidget {
  UserListComment({Key key, this.model}) : super(key: key);

  final UserModel model;

  @override
  _UserListCommentState createState() => _UserListCommentState();
}

class _UserListCommentState extends State<UserListComment> {
  List<PostCommentUI> _listMinePost;
  bool _loading = false;
  bool _hasMore = true;
  QueryDocumentSnapshot lastSnap;
  List<String> listPostID = [];

  Future<void> getMorePost() async {
    // load and add more mine post to _listMinePost from firebase

    // this is just a demo
    if (_loading) return;

    _loading = true;

    var mineCommentsQuery = FirebaseFirestore.instance
        .collectionGroup("comment")
        .where("isDeleted", isEqualTo: "false")
        .where("owner", isEqualTo: widget.model.username)
        .orderBy("createdDate", descending: true)
        .startAfterDocument(lastSnap)
        .limit(10);

    var mineCommentQSnap = await mineCommentsQuery.get();

    if (mineCommentQSnap.docs.length > 0) {
      lastSnap = mineCommentQSnap.docs[mineCommentQSnap.docs.length - 1];
    }

    var newPostID = mineCommentQSnap.docs
        .map((e) => e.data()["post"].toString())
        .toSet()
        .toList();
    newPostID =
        newPostID.where((element) => !listPostID.contains(element)).toList();

    if (mineCommentQSnap.docs.length == 0) {
      _hasMore = false;
    }

    listPostID +=
        mineCommentQSnap.docs.map((e) => e.data()["post"].toString()).toList();
    listPostID = listPostID.toSet().toList();

    if (newPostID.length > 0) {
      var listPostQuery = FirebaseFirestore.instance
          .collection("post")
          .where("id", whereIn: newPostID);

      var listPostQSnap = await listPostQuery.get();

      for (var postSnap in listPostQSnap.docs) {
        Post post = Post.fromJson(postSnap.data());
        _listMinePost.add(PostCommentUI(
          post: post,
          userModel: this.widget.model,
        ));
      }
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> initListPost() async {
    if (_loading) return;

    _loading = true;

    _listMinePost.clear();
    listPostID.clear();
    _hasMore = true;

    var mineCommentsQuery = FirebaseFirestore.instance
        .collectionGroup("comment")
        .where("isDeleted", isEqualTo: "false")
        .where("owner", isEqualTo: widget.model.username)
        .orderBy("createdDate", descending: true)
        .limit(10);

    try {
      await mineCommentsQuery.get();
    } catch (e) {
      print(e);
    }
    var mineCommentQSnap = await mineCommentsQuery.get();

    if (mineCommentQSnap.docs.length > 0) {
      lastSnap = mineCommentQSnap.docs[mineCommentQSnap.docs.length - 1];
    }

    if (mineCommentQSnap.docs.length < 2) {
      _hasMore = false;
    }

    listPostID +=
        mineCommentQSnap.docs.map((e) => e.data()["post"].toString()).toList();
    listPostID = listPostID.toSet().toList();

    var listPostQuery = FirebaseFirestore.instance
        .collection("post")
        .where("id", whereIn: listPostID);

    var listPostQSnap = await listPostQuery.get();

    for (var postSnap in listPostQSnap.docs) {
      Post post = Post.fromJson(postSnap.data());
      _listMinePost.add(PostCommentUI(
        post: post,
        userModel: this.widget.model,
      ));
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _listMinePost = [];
    initListPost();
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
            getMorePost().then((value) => true);
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: initListPost,
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (index == _listMinePost.length) {
                if (_hasMore) {
                  return CupertinoActivityIndicator(
                    radius: defaultPadding,
                  );
                } else {
                  return null;
                }
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
