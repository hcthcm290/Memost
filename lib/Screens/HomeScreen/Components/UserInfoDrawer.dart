import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/CreateGroupScreen/CreateGroupNameScreen.dart';
import 'package:flutter_application_1/Screens/Login/LoginScreen.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/UserInfoScreen.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:provider/provider.dart';

class UserInfoDrawer extends StatefulWidget {
  UserInfoDrawer({Key key, this.userModel, this.onTapClose}) : super(key: key);

  UserModel userModel;
  final VoidCallback onTapClose;

  @override
  _UserInfoDrawerState createState() => _UserInfoDrawerState();
}

class _UserInfoDrawerState extends State<UserInfoDrawer> {
  void onTapMyProfile() async {
    await Future.delayed(Duration(milliseconds: 300));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserInfoScreen(
                  model: this.widget.userModel,
                )));
  }

  @override
  void initState() {
    super.initState();
  }

  void onTapCreateGroup(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateGroupNameScreen()));
  }

  void onTapLogOut() async {
    this.widget.onTapClose();
    await Future.delayed(Duration(milliseconds: 500));

    await UserCredentialService.instance.logOut();
  }

  void onTapLogIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  int get heartValue {
    if (this.widget.userModel == null) {
      return 0;
    } else if (this.widget.userModel.stars == null) {
      return 0;
    } else {
      return int.tryParse(this.widget.userModel.stars);
    }
  }

  String get ageValue {
    if (this.widget.userModel == null) {
      return "0 d";
    } else {
      Duration ageDuration =
          DateTime.now().difference(this.widget.userModel.createdDate);

      if (ageDuration.inDays >= 365) {
        return "${ageDuration.inDays ~/ 365} y";
      } else if (ageDuration.inDays >= 30) {
        return "${ageDuration.inDays ~/ 30} m";
      } else {
        return "${ageDuration.inDays} d";
      }
    }
  }

  String getUserName() {
    if (this.widget.userModel == null) {
      return "Anonymous";
    } else if (this.widget.userModel.username == null ||
        this.widget.userModel.username == "") {
      return "Anonymous";
    } else {
      return this.widget.userModel.username;
    }
  }

  ImageProvider getAvatar() {
    if (this.widget.userModel == null) {
      return AssetImage("assets/logo/default-group-avatar.png");
    } else if (this.widget.userModel.username == null ||
        this.widget.userModel.username == "") {
      return AssetImage("assets/logo/default-group-avatar.png");
    } else {
      return CachedNetworkImageProvider(this.widget.userModel.avatarUrl);
    }
  }

  Drawer getUserDrawer(double drawerWidth, BuildContext context) {
    return Drawer(
        elevation: 0,
        child: Container(
          color: secondaryColor,
          child: Padding(
            padding: EdgeInsets.only(right: 1.5),
            child: Container(
              color: primaryColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: defaultPadding),
                        child: InkWell(
                          onTap: this.widget.onTapClose,
                          splashFactory: InkRipple.splashFactory,
                          child: Icon(
                            CupertinoIcons.xmark,
                            size: 24 * 1.25,
                          ),
                        ),
                      ),
                      // User icon and username
                      Center(
                        child: Container(
                          width: drawerWidth,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: defaultPadding),
                              child: Container(
                                width: drawerWidth * 0.35,
                                height: drawerWidth * 0.35,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: getAvatar(), fit: BoxFit.cover)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: defaultPadding),
                              child: Text(
                                getUserName(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: defaultPadding, bottom: defaultPadding * 0.5),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: QuickSummaryCard(
                                  propertyName: "Heart",
                                  propertyValue: heartValue.toString(),
                                  iconData: CupertinoIcons.heart_circle_fill,
                                ),
                              ),
                              VerticalDivider(
                                width: defaultPadding,
                                thickness: 1,
                              ),
                              Expanded(
                                child: QuickSummaryCard(
                                  propertyName: "Age",
                                  propertyValue: ageValue,
                                  iconData: Icons.cake_rounded,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      DrawerNavigateScreenCard(
                        title: "My profile",
                        iconData: CupertinoIcons.person_alt_circle,
                        onTap: onTapMyProfile,
                      ),
                      DrawerNavigateScreenCard(
                        title: "Create Group",
                        iconData: CupertinoIcons.person_3,
                        onTap: () => onTapCreateGroup(context),
                      ),
                      Spacer(),
                      DrawerNavigateScreenCard(
                        title: "Log out",
                        iconData: CupertinoIcons.square_arrow_left,
                        onTap: onTapLogOut,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Drawer getNoUserDrawer(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
        child: Container(
          color: secondaryColor,
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: defaultPadding),
                  child: InkWell(
                    onTap: this.widget.onTapClose,
                    splashFactory: InkRipple.splashFactory,
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 24 * 1.25,
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    CupertinoIcons.person_circle_fill,
                    color: Colors.white30,
                    size: 70,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: defaultPadding),
                  child: Text(
                    "Sign up to upvote the best meme, follow the trending, share your work and more!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: defaultPadding),
                  child: Divider(
                    height: 0.8,
                  ),
                ),
                DrawerNavigateScreenCard(
                  iconData: CupertinoIcons.person_circle,
                  title: "Sign up / Log in",
                  onTap: onTapLogIn,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width;
    print("drawer width: ${MediaQuery.of(context).size.width}");

    if (this.widget.userModel == null) {
      return getNoUserDrawer(context);
    } else {
      return getUserDrawer(drawerWidth, context);
    }
    //return getUserDrawer(drawerWidth, context);
  }
}

class QuickSummaryCard extends StatelessWidget {
  const QuickSummaryCard({
    Key key,
    this.propertyName,
    this.propertyValue,
    this.iconData,
  }) : super(key: key);

  final String propertyName;
  final String propertyValue;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: Colors.red,
          size: 35,
        ),
        Padding(
          padding: EdgeInsets.only(left: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                propertyValue,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    letterSpacing: 1,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                propertyName,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    letterSpacing: 1,
                    color: Colors.white38,
                    fontWeight: FontWeight.w100),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class DrawerNavigateScreenCard extends StatelessWidget {
  const DrawerNavigateScreenCard({
    Key key,
    this.title,
    this.iconData,
    this.onTap,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      splashFactory: InkRipple.splashFactory,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: defaultPadding),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(letterSpacing: 1, fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
      ),
    );
  }
}
