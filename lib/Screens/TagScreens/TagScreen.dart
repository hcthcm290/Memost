import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/HomeScreenAppBar.dart';
import 'package:flutter_application_1/Screens/TagScreens/Component/TagUI.dart';
import 'package:flutter_application_1/constant.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({Key key}) : super(key: key);

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  void _onAvatarTap() {}

  List<Widget> _tagsWeek = [];
  List<Widget> _tagMonth = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 10; i++) {
      _tagsWeek.add(Tag(
        tagName: "Meme$i",
      ));
    }

    for (int i = 0; i < 10; i++) {
      _tagMonth.add(Tag(
        tagName: "Study$i",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: HomeScreenAppBar(
          onAvatarTap: _onAvatarTap,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Common tag this week",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white54)),
              Column(
                children: _tagsWeek,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: Divider(
                  color: Colors.white38,
                  height: 5,
                  thickness: 2,
                ),
              ),
              Text("Common tag this month",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white54)),
              Column(
                children: _tagMonth,
              )
            ],
          ),
        ));
  }
}
