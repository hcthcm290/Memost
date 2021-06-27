import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';

class UserListComment extends StatefulWidget {
  UserListComment({Key key, this.model}) : super(key: key);

  final UserModel model;

  @override
  _UserListCommentState createState() => _UserListCommentState();
}

class _UserListCommentState extends State<UserListComment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
