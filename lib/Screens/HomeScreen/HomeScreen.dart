import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/HomeScreenAppBar.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/UserInfoDrawer.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/adHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as db;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List<PostUI> _listPostUI = [];

  UserModel userModel = null;
  BuildContext _context;
  db.QuerySnapshot snapshot;
  db.QueryDocumentSnapshot lastSnapshot;
  bool _loading = false;
  bool _hasMore = true;

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _bannerAd = BannerAd(
    //   adUnitId: AdHelper.bannerAdUnitId,
    //   request: AdRequest(),
    //   size: AdSize.banner,
    //   listener: BannerAdListener(
    //     onAdLoaded: (_) {
    //       setState(() {
    //         _isBannerAdReady = true;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       print('Failed to load a banner ad: ${err.message}');
    //       _isBannerAdReady = false;
    //       ad.dispose();
    //     },
    //   ),
    // );

    // _bannerAd.load();

    UserCredentialService.instance.onAuthChange.listen((user) async {
      userModel = await UserCredentialService.convertToUserModel(user);

      setState(() {});
    });

    refreshList();
  }

  Future<void> getMorePost() async {
    if (_loading) return;

    _loading = true;

    var query = db.FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isEqualTo: "false")
        .where("createdDate", isNotEqualTo: "")
        .orderBy("createdDate", descending: true)
        .startAfterDocument(lastSnapshot)
        .limit(10);

    var value = await query.get();
    snapshot = value;

    if (snapshot.docs.length > 0)
      lastSnapshot = snapshot.docs[snapshot.docs.length - 1];

    for (var docSnap in snapshot.docs) {
      Post post = Post.fromJson(docSnap.data());

      _listPostUI.add(PostUI(post: post));
    }

    if (snapshot.docs.length < 3) _hasMore = false;

    this.setState(() {});
    _loading = false;
    return;
  }

  Future<void> refreshList() async {
    if (_loading) return;

    _loading = true;

    _listPostUI.clear();
    setState(() {});

    await Future.delayed(Duration(seconds: 2));

    _hasMore = true;

    var query = db.FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isEqualTo: "false")
        .where("createdDate", isNotEqualTo: "")
        .orderBy("createdDate", descending: true)
        .limit(20);
    var value = await query.get();
    snapshot = value;

    if (snapshot.docs.length > 0)
      lastSnapshot = snapshot.docs[snapshot.docs.length - 1];

    for (var docSnap in snapshot.docs) {
      Post post = Post.fromJson(docSnap.data());

      _listPostUI.add(PostUI(key: ValueKey(post.id), post: post));
    }

    if (snapshot.docs.length < 3) _hasMore = false;

    // Future.delayed(Duration(seconds: 2)).then((value) => scrollController
    //     .animateTo(0, duration: Duration.zero, curve: Curves.ease));

    this.setState(() {});
    _loading = false;
    return;
  }

  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd.dispose();

    super.dispose();
  }

  int itemCount() {
    if (_listPostUI == null || _listPostUI.length == 0)
      return 0;
    else
      return _listPostUI.length * 2 - 1;
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
        body: Stack(children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              final maxScroll = scrollNotification.metrics.maxScrollExtent;
              final currentScroll = scrollNotification.metrics.pixels;

              if (maxScroll == currentScroll) {
                getMorePost();
                return;
              }
              return;
            },
            child: RefreshIndicator(
              onRefresh: refreshList,
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (index % 2 != 0) {
                    return Divider(
                      height: defaultPadding * 0.75,
                      thickness: defaultPadding * 0.75,
                      color: Color.fromARGB(255, 15, 15, 15),
                    );
                  }
                  if (index > itemCount()) {
                    if (_hasMore) {
                      return CupertinoActivityIndicator(
                        radius: defaultPadding,
                      );
                    } else {
                      return Container();
                    }
                  }
                  if (index ~/ 2 < _listPostUI.length) {
                    return _listPostUI[index ~/ 2];
                  } else {
                    return null;
                  }
                },
                itemCount: itemCount() + 2,
              ),
            ),
          ),
          // if (_isBannerAdReady)
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       width: MediaQuery.of(context).size.width,
          //       height:
          //           (MediaQuery.of(context).size.width / _bannerAd.size.width) *
          //               _bannerAd.size.height.toDouble(),
          //       child: AdWidget(ad: _bannerAd),
          //     ),
          //   )
        ]),
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
