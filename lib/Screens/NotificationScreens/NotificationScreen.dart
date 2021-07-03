import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Notification.dart';
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
    listNotification.clear();
    if (userModel == null) {
      if (mounted) {
        setState(() {});
      }
      return;
    }
    if (loading) return;

    loading = true;

    var listNotiSnap = await FirebaseFirestore.instance
        .collection("notification")
        .where("receiver", isEqualTo: userModel.username)
        .orderBy("createdDate", descending: true)
        .get();

    for (var notiSnap in listNotiSnap.docs) {
      NotificationModel model = NotificationModel();
      model.fromJson(notiSnap.data());

      listNotification
          .add(ReplyNotification(key: ValueKey(model.id), notiModel: model));
    }

    loading = false;
    reachTheEnd = true;

    if (mounted) {
      setState(() {});
    }

    return;
  }

  Future<void> getMoreNotification() async {
    // Todo: load 10 more notifications
    if (loading) return;

    loading = true;

    setState(() {
      loading = false;
      reachTheEnd = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserCredentialService.convertToUserModel(
            UserCredentialService.instance.currentUser)
        .then((value) async {
      userModel = value;
      initNotifications();

      FirebaseFirestore.instance
          .collection("notification")
          .snapshots()
          .listen((event) {
        initNotifications();
      });

      setState(() {});
    });

    UserCredentialService.instance.onAuthChange.listen((user) async {
      userModel = await UserCredentialService.convertToUserModel(user);
      initNotifications();
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
            return true;
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: initNotifications,
          child: ListView.builder(itemBuilder: (context, index) {
            if (index == listNotification.length && !reachTheEnd) {
              return CupertinoActivityIndicator(
                radius: defaultPadding,
              );
            } else if (index < listNotification.length) {
              return listNotification[index];
            } else
              return null;
          }),
        ),
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
