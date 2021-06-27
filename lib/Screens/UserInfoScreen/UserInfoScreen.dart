import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/UserListComment.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/UserListPost.dart';
import 'package:tuple/tuple.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen({Key key, this.model}) : super(key: key);

  final UserModel model;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Tuple2> _pages = [
    Tuple2("Post", UserListPost()),
    Tuple2("Comment", UserListComment()),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: _pages
              .map<Tab>((page) => Tab(
                    text: page.item1,
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages.map<Widget>((page) => page.item2).toList(),
      ),
    );
  }
}
