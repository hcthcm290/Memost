import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';

class NotificationScreenAppBar extends StatefulWidget with PreferredSizeWidget {
  NotificationScreenAppBar({
    Key key,
    @required this.onAvatarTap,
  }) : super(key: key);

  final VoidCallback onAvatarTap;

  @override
  _NotificationScreenAppBarState createState() =>
      _NotificationScreenAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(45);
}

class _NotificationScreenAppBarState extends State<NotificationScreenAppBar> {
  int _currentIndex = 0;
  UserModel userModel = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        image: DecorationImage(
                            image: getAvatar(), fit: BoxFit.cover)),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(right: 35, top: 2),
                  child: Text(
                    "Activity",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
              Spacer(),
            ],
          ),
          Spacer(),
          Divider(
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
