import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Reaction.dart';
import 'package:flutter_application_1/Model/Reaction_Type.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/UserListComment.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/UserListPost.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/EditProfileScreen.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:tuple/tuple.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen({Key key, @required this.model, this.realtime = true})
      : super(key: key);

  final UserModel model;
  final bool realtime;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ImageProvider _avatarImage;
  String _totalPostCount = "0";
  String _totalLikeCount = "0";
  StreamSubscription<DocumentSnapshot> userDataSub;
  QuerySnapshot minePostSnap;

  List<Tuple2> _pages = [];

  Future<void> getTotalPostCount() async {
    var minePostQuery = FirebaseFirestore.instance
        .collection("post")
        .where("owner", isEqualTo: widget.model.username);

    minePostSnap = await minePostQuery.get();

    setState(() {
      _totalPostCount = minePostSnap.size.toString();
    });

    return;
  }

  Future<void> getTotalLikeCount() async {
    int totalLoved = 0;
    for (var snap in minePostSnap.docs) {
      var query2 = FirebaseFirestore.instance
          .collection("post")
          .doc(snap.id)
          .collection("reaction");
      var value = await query2.get();
      var data = value.docs.map((e) => Reaction.fromJson(e.data())).toList();
      int loved = data
          .where((element) => element.reaction == ReactionType.loved)
          .length;

      totalLoved += loved;
    }

    setState(() {
      _totalLikeCount = convertLikeToString(totalLoved);
    });
  }

  String convertLikeToString(int likeCount) {
    if (likeCount == null) return "";
    if (likeCount > 1000)
      return (likeCount / 1000).toStringAsPrecision(1) + 'K';
    else if (likeCount > 1000000)
      return (likeCount / 1000000).toStringAsPrecision(1) + 'M';
    else if (likeCount > 1000000000)
      return (likeCount / 1000000000).toStringAsPrecision(1) + 'B';
    else
      return likeCount.toString();
  }

  void _onTapEditProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfileScreen(
                  userModel: widget.model,
                )));
  }

  @override
  void initState() {
    super.initState();
    if (widget.model != null && widget.realtime) {
      userDataSub = FirebaseFirestore.instance
          .collection("users")
          .doc(UserCredentialService.instance.currentUser.uid)
          .snapshots()
          .listen((docSnap) {
        widget.model.fromMap(docSnap.data());
        if (widget.model.avatarUrl != null && widget.model.avatarUrl != "") {
          _avatarImage = CachedNetworkImageProvider(widget.model.avatarUrl);
        } else {
          _avatarImage = null;
        }
        if (mounted) {
          setState(() {});
        }
      });
    }
    _pages = [
      Tuple2(
          "Post",
          UserListPost(
            userModel: widget.model,
          )),
      Tuple2(
          "Comment",
          UserListComment(
            model: widget.model,
          )),
    ];
    _tabController = TabController(length: _pages.length, vsync: this);
    getTotalPostCount().then((value) => getTotalLikeCount());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Text("${this.widget.model.displayName}",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Spacer(),
              if (this.widget.model.id ==
                  UserCredentialService.instance.currentUser.uid)
                Padding(
                  padding: EdgeInsets.only(right: defaultPadding * 0.5),
                  child: GestureDetector(
                    onTap: _onTapEditProfile,
                    child: Text(
                      "Edit profile",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                )
            ],
          ),
        ),
        body: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innnerBoxIsScroll) {
            return <Widget>[
              SliverAppBar(
                  automaticallyImplyLeading: false,
                  collapsedHeight: 130,
                  stretch: true,
                  backgroundColor: Colors.black,
                  flexibleSpace: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                        ),
                        child: Row(
                          children: [
                            Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: new DecorationImage(
                                    image: _avatarImage != null
                                        ? _avatarImage
                                        : Image.asset(
                                                "assets/logo/default-group-avatar.png")
                                            .image,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.only(left: defaultPadding),
                              child: Container(
                                width: 180,
                                child: Text(
                                  "${this.widget.model.displayName}",
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 5,
                            ),
                            Column(
                              children: [
                                Text(
                                  "$_totalPostCount",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Post",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 4,
                            ),
                            Column(
                              children: [
                                Text(
                                  "$_totalLikeCount",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Likes",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 2,
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding),
                          child: Text(
                            widget.model.description == null
                                ? "My Funny Collection"
                                : widget.model.description,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: Colors.white),
                          )),
                    ],
                  )),
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: UserInfoPersistentHeader(TabBar(
                  tabs: _pages
                      .map<Widget>((page) => Tab(
                            text: page.item1,
                          ))
                      .toList(),
                  indicatorColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  labelColor: Colors.white,
                  controller: _tabController,
                )),
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: _pages.map<Widget>((page) => page.item2).toList(),
          ),
        ),
      ),
    );
  }
}

class UserInfoPersistentHeader extends SliverPersistentHeaderDelegate {
  UserInfoPersistentHeader(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
