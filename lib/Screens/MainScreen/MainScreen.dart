import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/CreatePostScreens/LoginModal.dart';
import 'package:flutter_application_1/Screens/CreatePostScreens/UploadTypeModal.dart';
import 'package:flutter_application_1/Screens/HomeScreen/HomeScreen.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _groupPage = Container();
  var _notificationPage = Container();
  var _explorePage = Container();

  int _currentIndex = 0;
  int _screenIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white30,
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          onTap: (index) {
            if (index == 2) {
              if (UserCredentialService.instance.currentUser == null) {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(child: LoginModal()));
              } else {
                showModalBottomSheet(
                    context: context, builder: (context) => UploadTypeModal());
              }
            } else {
              _currentIndex = index;
              switch (index) {
                case 0:
                  _screenIndex = 0;
                  break;
                case 1:
                  _screenIndex = 1;
                  break;
                case 3:
                  _screenIndex = 2;
                  break;
                case 4:
                  _screenIndex = 3;
                  break;
              }
              setState(() {});
            }
          },
          currentIndex: _currentIndex,
          items: [
            buildBottomBarIcon(
                _currentIndex == 0
                    ? CupertinoIcons.house_alt_fill
                    : CupertinoIcons.house_alt,
                "Home"),
            buildBottomBarIcon(
                _currentIndex == 1
                    ? CupertinoIcons.circle_grid_hex_fill
                    : CupertinoIcons.circle_grid_hex,
                "Group"),
            buildBottomBarIcon(CupertinoIcons.plus, ""),
            buildBottomBarIcon(
                _currentIndex == 3
                    ? CupertinoIcons.bell_fill
                    : CupertinoIcons.bell,
                "Activity"),
            buildBottomBarIcon(
                _currentIndex == 4
                    ? CupertinoIcons.paperplane_fill
                    : CupertinoIcons.paperplane,
                "Explore")
          ],
        ),
        body: IndexedStack(
          children: <Widget>[
            Container(
              child: HomeScreen(),
              padding: EdgeInsets.only(bottom: 2),
            ),
            _groupPage,
            _notificationPage,
            _explorePage
          ],
          index: _screenIndex,
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomBarIcon(IconData data, String label) {
    return BottomNavigationBarItem(icon: Icon(data), label: label);
  }
}
