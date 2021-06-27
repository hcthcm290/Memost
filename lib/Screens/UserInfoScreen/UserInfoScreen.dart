import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/UserListComment.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/UserListPost.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:tuple/tuple.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen({Key key, @required this.model}) : super(key: key);

  final UserModel model;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ImageProvider _avatarImage;
  String _totalPostCount;
  String _totalLikeCount;

  final List<Tuple2> _pages = [
    Tuple2("Post", UserListPost()),
    Tuple2("Comment", UserListComment()),
  ];

  Future<void> getTotalPostCount() async {
    setState(() {
      _totalPostCount = "30";
    });
  }

  Future<void> getTotalLikeCount() async {
    setState(() {
      _totalLikeCount = "1K";
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    getTotalPostCount();
    getTotalLikeCount();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   bottom: TabBar(
        //     controller: _tabController,
        //     tabs: _pages
        //         .map<Tab>((page) => Tab(
        //               text: page.item1,
        //             ))
        //         .toList(),
        //   ),
        // ),
        appBar: AppBar(
          backgroundColor: Colors.black,
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
                                  "${this.widget.model.username}",
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
                                      .subtitle1
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
                            "My Funny Collection",
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
