

import 'package:flutter/material.dart';
import 'lib.dart';
import 'package:flutter_application_1/imgPicker.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  
  int _selectedIndex = 0;
  
  static const TextStyle _defaultStyle = TextStyle(fontSize: 30, color: Colors.black26);
  
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MainPage(),
    TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter text here',
      ),
    ),
  ];

  PageController _pageController;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
  }

  @override 
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _OnItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bottom Navigation Test'),),
      body: PageView(
        children: _widgetOptions,
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: new NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30,),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, size: 40,),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: 30,),
            label: ''
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _OnItemTap,
      ),
    );
  }
}