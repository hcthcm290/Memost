import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login/LoginScreen.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/lib.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        onTap: (index) {
          if (index == 2) {
            // activate the add post modal
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
            child: LoginScreen(),
            padding: EdgeInsets.only(bottom: 2),
          ),
          _groupPage,
          _notificationPage,
          _explorePage
        ],
        index: _screenIndex,
      ),
    );
  }

  BottomNavigationBarItem buildBottomBarIcon(IconData data, String label) {
    return BottomNavigationBarItem(icon: Icon(data), label: label);
  }
}
