import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Comment.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/Components/CommentTile.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/Components/SortComment.dart';
import 'package:flutter_application_1/constant.dart';

class DetailPostScreen extends StatefulWidget {
  DetailPostScreen({
    Key key,
    this.postUI,
  }) : super(key: key);

  final PostUI postUI;

  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  String _currentCommentType = "Hot comment";

  Comment _comment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comment = Comment();
    _comment.createdDate = DateTime.now();
    _comment.content = "Wow man, best meme, thank you";
    _comment.owner = "basa";
    _comment.id = "cauicb1265";
  }

  void _onTapChangeCommentType() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [Text("Post")]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            this.widget.postUI,
            GestureDetector(
              onTap: _onTapChangeCommentType,
              child: SortComment(currentCommentType: _currentCommentType),
            ),
            CommentTile(comment: _comment),
            Divider(
              height: 2,
              thickness: 2,
            ),
            CommentTile(comment: _comment),
            Divider(
              height: 2,
              thickness: 2,
            ),
            CommentTile(comment: _comment),
            Divider(
              height: 2,
              thickness: 2,
            ),
            CommentTile(comment: _comment)
          ],
        ),
      ),
    );
  }
}
