import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/HomeScreenAppBar.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/UserInfoDrawer.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as db;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  UserModel userModel = null;
  BuildContext _context;
  db.QuerySnapshot snapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserCredentialService.instance.onAuthChange.listen((user) async {
      userModel = await UserCredentialService.convertToUserModel(user);

      setState(() {});
    });

    var query = db.FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isNotEqualTo: "true");
    query.get().then((value) {
      this.setState(() {
        snapshot = value;
      });
    });
    query.snapshots().listen((value) {
      this.setState(() {
        snapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 40, 40, 40),
        key: _key,
        appBar: HomeScreenAppBar(
          onAvatarTap: () {
            print("on avatar tapped callback");
            _key.currentState.openDrawer();
          },
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            if (index % 2 != 0) {
              return Divider(
                height: defaultPadding * 0.75,
                thickness: defaultPadding * 0.75,
                color: Color.fromARGB(255, 15, 15, 15),
              );
            }
            return PostUI(
              post: Post.fromJson(snapshot?.docs[index]?.data()),
            );
          },
          itemCount: snapshot?.size ?? 0,
        ),
        drawer: UserInfoDrawer(
          userModel: this.userModel,
          onTapClose: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
