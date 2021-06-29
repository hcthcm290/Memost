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

  Future<void> getMorePost() async {
    // load and add more mine post to _listMinePost from firebase

    // this is just a demo
    if (_loading) return;

    _loading = true;

    await Future.delayed(Duration(seconds: 2));

    for (int i = 0; i < 10; i++) {
      Post post = Post();
      post.owner = "Basa102";
      post.title = "The funniest meme i have ever seen";
      post.image =
          "https://preview.redd.it/lwf895ptel571.png?width=960&crop=smart&auto=webp&s=f11838f1f6f95ae4da8fe9e1196396c6b15e0074";
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
    getMorePost();
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
          }
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == _listMinePost.length) {
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
    );
  }
}
