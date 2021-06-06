import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/HomeScreenAppBar.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/UserInfoDrawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        key: _key,
        appBar: HomeScreenAppBar(
          onAvatarTap: () {
            print("on avatar tapped callback");
            _key.currentState.openDrawer();
          },
        ),
        body: Row(
          children: [
            Expanded(child: Container(color: Colors.green)),
            Expanded(child: Container(color: Colors.blue)),
          ],
        ),
        drawer: UserInfoDrawer(
          onTapClose: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
