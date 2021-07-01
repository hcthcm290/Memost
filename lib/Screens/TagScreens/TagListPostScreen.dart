import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/constant.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as db;

class TagListPostScreen extends StatefulWidget {
  const TagListPostScreen({Key key, @required this.tagName}) : super(key: key);

  final String tagName;

  @override
  _TagListPostScreenState createState() => _TagListPostScreenState();
}

class _TagListPostScreenState extends State<TagListPostScreen> {
  List<PostUILoader> _listPost = [];
  List<String> listPostID = [];
  bool hasMore = true;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initListPost();
  }

  StreamSubscription querySubscription;
  // Query: tag

  void initListPost() {
    if (loading == true) return;
    loading = true;
    var query = db.FirebaseFirestore.instance
        .collection("tag")
        .doc(widget.tagName)
        .collection("content");

    query.get().then((value) {
      if (value == null || value.size == 0) return;
      listPostID = value.docs.map((e) => e.data()["id"]).toList();
    });

    querySubscription = query.snapshots().listen((value) {
      if (value == null || value.size == 0) return;
      listPostID = value.docs.map((e) => e.data()["id"]).toList();
    });
/*
    Post post = Post();
    post.owner = "Basa102";
    post.title = "The funniest meme i have ever seen";
    post.image =
        "https://preview.redd.it/lwf895ptel571.png?width=960&crop=smart&auto=webp&s=f11838f1f6f95ae4da8fe9e1196396c6b15e0074";
// */
    for (int i = 0; i < min(5, listPostID.length); i++) {
      _listPost.add(PostUILoader(
        id: listPostID[i],
      ));
    }

    loading = false;
    setState(() {});
  }

  void getMorePost() {
    if (loading == true) return;
    loading = true;
    // Todo: add more post to list post

    int loaded = 0;
    int toLoad = 0;

    for (int i = 0; i < 3; i++) {
      if (_listPost.length >= listPostID.length) {
        setState(() {
          hasMore = false;
        });

        if (loaded >= toLoad) loading = false;

        return;
      }
      toLoad++;
      _listPost.add(PostUILoader(
        id: listPostID[_listPost.length], // just some magic
        onCompleteLoad: (post) {
          loaded++;
          if (loaded >= toLoad) loading = false;
        },
      ));
    }

    setState(() {});

    //loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text("${widget.tagName}"),
      // ),

      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          floating: true,
          title: Text("${widget.tagName}"),
          shadowColor: Color.fromARGB(255, 200, 200, 200),
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            final maxScroll = scrollNotification.metrics.maxScrollExtent;
            final currentScroll = scrollNotification.metrics.pixels;

            if (maxScroll == currentScroll) {
              getMorePost();
            }
          },
          child: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == _listPost.length && hasMore) {
                return ListTile(
                  title: CupertinoActivityIndicator(
                    radius: defaultPadding,
                  ),
                );
              } else if (index < _listPost.length) {
                return _listPost[index];
              }
              if (index > _listPost.length) {
                getMorePost();
              }
            }),
          ),
        ),
      ]),
    );
  }
}
