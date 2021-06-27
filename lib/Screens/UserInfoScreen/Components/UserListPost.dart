import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';

class UserListPost extends StatefulWidget {
  UserListPost({Key key, this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  _UserListPostState createState() => _UserListPostState();
}

class _UserListPostState extends State<UserListPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
