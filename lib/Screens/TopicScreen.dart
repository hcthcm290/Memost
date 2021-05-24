import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as db;
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Group.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TopicScreen extends StatefulWidget {
  UserCredentialService credentialService;
  String groupName;

  TopicScreen({@required this.groupName, this.credentialService}) {
    // DB table add
    /*
    Group temp = new Group();
    temp.name = "Memes";
    temp.createdDate = DateTime.now();
    db.FirebaseFirestore.instance
        .collection("group")
        .doc(temp.name)
        .set(temp.toJson());
    // */
  }
  @override
  _TopicScreenState createState() =>
      _TopicScreenState(credentialService: credentialService);
}

// TODO: Make 404 page

class _TopicScreenState extends State<TopicScreen> {
  Group group;
  UserCredentialService _userCredentialService;
  db.FirebaseFirestore store = db.FirebaseFirestore.instance;
  bool _isSubscribed = false;
  db.DocumentReference topicNode;
  db.CollectionReference postNode;

  _TopicScreenState({UserCredentialService credentialService}) {
    _userCredentialService = credentialService;
    if (_userCredentialService == null)
      _userCredentialService = UserCredentialService();
  }

  @override
  void initState() {
    db.FirebaseFirestore.instance
        .collection("group")
        .doc(widget.groupName)
        .get()
        .then((value) {
      setState(() {
        group = Group.fromJson(value.data());
      });
    });
    super.initState();
    topicNode = store.collection("topic").doc(widget.groupName);
    postNode = topicNode.collection("posts");
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ImageProvider _getBigImage() {
    return AssetImage("images/lake.jpg");
  }

  ImageProvider _getSmallImage() {
    return AssetImage("images/lake.jpg");
  }

  String _getTopicName() {
    return group?.name ?? "";
  }

  String _subButtonName() {
    if (_isSubscribed) {
      return "Unsubscribe";
    } else {
      return "Subscribe";
    }
  }

  void _onSubButtonPressed() {
    setState(() {
      _isSubscribed = !_isSubscribed;
    });
  }

  Widget nullWidget() {
    return Container(
      width: 0,
      height: 0,
    );
  }

  Widget listPost() {
    if (group != null)
      return ListPostUI(group: group);
    else
      return nullWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Stack(
            children: [
              Container(
                child: Image(
                  fit: BoxFit.fitHeight,
                  image: _getBigImage(),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                height: 150,
                width: 1000,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Divider(
                  height: 10.0,
                  thickness: 10,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                height: 220,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 80, 0, 0),
                      child: CircleAvatar(
                        backgroundImage: _getSmallImage(),
                        radius: 40,
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      flex: 20,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 100, 0, 10),
                        child: AutoSizeText(
                          "r/" + _getTopicName(),
                          style: TextStyle(
                            fontSize: 50,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Spacer(flex: 5),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 100, 0, 10),
                      child: ElevatedButton(
                        child: Text(
                          _subButtonName(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        onPressed: _onSubButtonPressed,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: 10,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          listPost()
        ],
      ),
    );
  }
}
