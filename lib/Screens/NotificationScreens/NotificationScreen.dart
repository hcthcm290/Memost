import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/UserInfoDrawer.dart';
import 'package:flutter_application_1/Screens/NotificationScreens/Components/NotificationScreenAppBar.dart';
import 'package:flutter_application_1/Screens/NotificationScreens/Components/ReplyNotification.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/Model/Comment.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  UserModel userModel;

  List<Widget> listNotification = [];
  bool reachTheEnd = false;
  bool loading = false;

  Future<void> initNotifications() async {
    // Todo: load 10 notifications
    await Future.delayed(Duration(seconds: 2));

    for (int i = 0; i < 10; i++) {
      listNotification.add(ReplyNotification());
    }
    setState(() {});
  }

  Future<void> getMoreNotification() async {
    // Todo: load 10 more notifications
    if (loading) return;

    loading = true;

    await Future.delayed(Duration(seconds: 2));

    for (int i = 0; i < 10; i++) {
      listNotification.add(ReplyNotification());
    }

    if (listNotification.length > 30) {
      reachTheEnd = true;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotifications();

    UserCredentialService.convertToUserModel(
            UserCredentialService.instance.currentUser)
        .then((value) {
      setState(() {
        userModel = value;
      });
    });

    UserCredentialService.instance.onAuthChange.listen((user) async {
      userModel = await UserCredentialService.convertToUserModel(user);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black,
      appBar: NotificationScreenAppBar(onAvatarTap: () {
        _key.currentState.openDrawer();
      }),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          final maxScroll = scrollNotification.metrics.maxScrollExtent;
          final currentScroll = scrollNotification.metrics.pixels;

          if (maxScroll == currentScroll) {
            getMoreNotification();
          }
        },
        child: ListView.builder(itemBuilder: (context, index) {
          if (index == listNotification.length && !reachTheEnd) {
            return CupertinoActivityIndicator(
              radius: defaultPadding,
            );
          } else if (index < listNotification.length) {
            return listNotification[index];
          }
        }),
      ),
      drawer: UserInfoDrawer(
        userModel: this.userModel,
        onTapClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
