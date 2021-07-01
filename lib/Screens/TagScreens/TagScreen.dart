import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/HomeScreen/Components/HomeScreenAppBar.dart';
import 'package:flutter_application_1/Screens/TagScreens/Component/TagUI.dart';
import 'package:flutter_application_1/constant.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as db;
import 'package:tuple/tuple.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({Key key}) : super(key: key);

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  void _onAvatarTap() {}

  List<Widget> _tagsWeek = [];
  List<Widget> _tagMonth = [];
  final int cutoff = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var query = db.FirebaseFirestore.instance.collection("tag");
    query.get().then((tagValue) async {
      if (tagValue == null || tagValue.size == 0) return;
      List<String> tags = tagValue.docs.map((e) => e.id).toList();
      Map<String, int> newPostInTagWeek = {};
      Map<String, int> newPostInTagMonth = {};
      for (var item in tags) {
        var deepQuery = query.doc(item).collection("content");
        var currentTag = item;
        var value = await deepQuery.get();
        if (value != null && value.size != 0) {
          newPostInTagWeek[currentTag] = value.docs
              .where((element) =>
                  DateTimeRange(
                    end: DateTime.now(),
                    start: (DateTime.parse(element.data()["createdDate"])),
                  ).duration.inDays <=
                  7)
              .length;

          newPostInTagMonth[currentTag] = value.docs
              .where((element) =>
                  DateTimeRange(
                    end: DateTime.now(),
                    start: (DateTime.parse(element.data()["createdDate"])),
                  ).duration.inDays <=
                  30)
              .length;
        }
      }

      if (newPostInTagWeek.length <= tags.length) {
        // Calculate the most popular in week & month
        List<int> topWeek = newPostInTagWeek.values.toList();
        topWeek.sort();
        int cutoffWeek = topWeek[max(topWeek.length - 9, 0)];
        newPostInTagWeek.removeWhere((key, value) => value < cutoffWeek);

        // newPostInTagMonth
        //     .removeWhere((key, value) => newPostInTagWeek.containsKey(key));

        if (newPostInTagMonth.length > 0) {
          List<int> topMonth = newPostInTagMonth.values.toList();
          topMonth.sort();
          int cutoffMonth = topMonth[max(topMonth.length - 9, 0)];
          newPostInTagMonth.removeWhere((key, value) => value < cutoffMonth);
        }

        // Add to TagWeek & TagMonth
        for (var item in newPostInTagWeek.keys) {
          _tagsWeek.add(Tag(
            tagName: item,
          ));
        }
        for (var item in newPostInTagMonth.keys) {
          _tagMonth.add(Tag(
            tagName: item,
          ));
        }

        setState(() {});
      }
    });

    /*
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
    // */
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
