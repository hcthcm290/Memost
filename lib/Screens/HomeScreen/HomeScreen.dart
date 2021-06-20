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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  UserModel userModel = null;
  BuildContext _context;

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    UserCredentialService.instance.onAuthChange.listen((user) async {
      userModel = await UserCredentialService.convertToUserModel(user);

      setState(() {});
    });
  }

  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd.dispose();

    super.dispose();
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
          ListView.builder(
            itemBuilder: (context, index) {
              if (index % 2 != 0) {
                return Divider(
                  height: defaultPadding * 0.75,
                  thickness: defaultPadding * 0.75,
                  color: Color.fromARGB(255, 15, 15, 15),
                );
              }

              Post post = Post();
              post.owner = "Basa102";
              post.title = "The funniest meme i have ever seen";
              post.image =
                  "https://preview.redd.it/lwf895ptel571.png?width=960&crop=smart&auto=webp&s=f11838f1f6f95ae4da8fe9e1196396c6b15e0074";
              return PostUI(post: post);
            },
          ),
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height:
                    (MediaQuery.of(context).size.width / _bannerAd.size.width) *
                        _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            )
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
