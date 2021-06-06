import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/constant.dart';

class UserInfoDrawer extends StatefulWidget {
  UserInfoDrawer({Key key, this.userModel, this.onTapClose}) : super(key: key);

  UserModel userModel;
  final VoidCallback onTapClose;

  @override
  _UserInfoDrawerState createState() => _UserInfoDrawerState();
}

class _UserInfoDrawerState extends State<UserInfoDrawer> {
  void onTapMyProfile() {}

  void onTapCreateGroup() {}

  void onTapLogOut() {}

  int heartValue = 132;
  String ageValue = "2 y";

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width;
    print("drawer width: ${MediaQuery.of(context).size.width}");
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
                                        image: CachedNetworkImageProvider(
                                            "https://image.slidesharecdn.com/cabproposal6-18-2012-120618144552-phpapp02/95/cab-proposal-6-182012-1-728.jpg"),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: defaultPadding),
                              child: Text(
                                "Username",
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
                        onTap: onTapCreateGroup,
                      ),
                      Spacer(),
                      DrawerNavigateScreenCard(
                        title: "Log out",
                        iconData: CupertinoIcons.square_arrow_left,
                        onTap: onTapCreateGroup,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
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
