import 'package:firebase_auth/firebase_auth.dart';
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

  UserModel userModel = null;
  BuildContext _context;
  db.QuerySnapshot snapshot;
  List<Map<String, dynamic>> snapshotData;

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

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

    var query = db.FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isEqualTo: "false")
        .where("createdDate", isNotEqualTo: "")
        .orderBy("createdDate", descending: true)
        .limit(20);
    query.get().then((value) {
      snapshot = value;

      // snapshotData = snapshot.docs.map((e) => e.data()).toList();
      // print("before sort ${snapshotData.map((e) => e["createdDate"])}");

      // snapshotData.sort((x, y) {
      //   var x_time = DateTime.parse(x["createdDate"]);
      //   var y_time = DateTime.parse(y["createdDate"]);
      //   var result = y_time.compareTo(x_time);
      //   return result;
      // });

      //// var abc = snapshot.docs.map((e) => e.data()["createdDate"]).toList();
      // print("after sort ${snapshotData.map((e) => e["createdDate"])}");

      this.setState(() {});
    });
    // query.snapshots().listen((value) {
    //   this.setState(() {
    //     snapshot = value;
    //   });
    // });
  }

  Future<void> refreshList() async {
    var query = db.FirebaseFirestore.instance
        .collection("post")
        .where("isDeleted", isEqualTo: "false")
        .where("createdDate", isNotEqualTo: "")
        .orderBy("createdDate", descending: true)
        .limit(20);
    var value = await query.get();
    snapshot = value;

    this.setState(() {});
    return;
  }

  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd.dispose();

    super.dispose();
  }

  int itemCount() {
    if (snapshot == null || snapshot.size == 0)
      return 0;
    else
      return snapshot.size * 2 - 1;
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
          RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index % 2 != 0) {
                  return Divider(
                    height: defaultPadding * 0.75,
                    thickness: defaultPadding * 0.75,
                    color: Color.fromARGB(255, 15, 15, 15),
                  );
                }
                var postUI = Post.fromJson(snapshot?.docs[index ~/ 2]?.data());
                //var postUI = Post.fromJson(snapshotData[index ~/ 2]);
                return PostUI(
                  key: ValueKey(postUI.id),
                  post: postUI,
                );
              },
              itemCount: itemCount(),
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
