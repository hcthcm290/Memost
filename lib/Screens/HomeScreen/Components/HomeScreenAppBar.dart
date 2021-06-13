import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';

class HomeScreenAppBar extends StatefulWidget with PreferredSizeWidget {
  HomeScreenAppBar({
    Key key,
    @required this.onAvatarTap,
  }) : super(key: key);

  final VoidCallback onAvatarTap;

  @override
  _HomeScreenAppBarState createState() => _HomeScreenAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(45);
}

class _HomeScreenAppBarState extends State<HomeScreenAppBar> {
  int _currentIndex = 0;
  UserModel userModel = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      userModel = await UserCredentialService.convertToUserModel(user);
      setState(() {});
    });
  }

  ImageProvider getAvatar() {
    if (userModel == null ||
        userModel.avatarUrl == null ||
        userModel.avatarUrl == "") {
      return AssetImage("assets/logo/default-group-avatar.png");
    } else {
      return CachedNetworkImageProvider(userModel.avatarUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                if (this.widget.onAvatarTap == null) {
                  print("null callback");
                  return;
                }
                this.widget.onAvatarTap();
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: getAvatar(), fit: BoxFit.cover)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding * 0.75),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(CupertinoIcons.search)),
                  Expanded(
                    child: Container(
                      height: 33,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
