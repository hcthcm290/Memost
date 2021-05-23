import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as db;
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TopicScene extends StatefulWidget {
  @override
  _TopicSceneState createState() => _TopicSceneState();
}

class _TopicSceneState extends State<TopicScene> {
  String _topicName;
  UserCredentialService _userCredentialService;
  db.FirebaseStorage store = db.FirebaseStorage.instance;
  bool _isSubscribed = false;
  db.Reference node;

  _TopicSceneState(
      {String topicName = "memes", UserCredentialService credentialService}) {
    _topicName = topicName;
    node = store.ref("topic").child(_topicName);
    _userCredentialService = credentialService;
    if (_userCredentialService == null)
      _userCredentialService = UserCredentialService();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ImageProvider _getBigImage() {
    return AssetImage("images/lake.jpg");
  }

  ImageProvider _getSmallImage() {
    return AssetImage("images/lake.jpg");
  }

  String _getTopicName() {
    return "\t" + _topicName + "\t";
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // TODO: Rating
          Image(
            fit: BoxFit.fitWidth,
            image: _getBigImage(),
          ),
          // TODO: Content
          Container(
            height: 100,
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      // TODO: Username
                      CircleAvatar(
                        backgroundImage: _getSmallImage(),
                        radius: 50,
                      )
                      // TODO: Date posted
                    ],
                  ),
                ),
                // TODO: Post name
                Expanded(
                  child: AutoSizeText(
                    _getTopicName(),
                    softWrap: false,
                    style: TextStyle(fontSize: 100),
                    maxLines: 1,
                  ),
                ),
                // TODO: Post preview
                // TODO: Post action
                Container(
                  child: Row(
                    children: [
                      // TODO: Like
                      // TODO: Dislike
                      // TODO: Comment (link)
                      // TODO: Other actions: Copy link, Report
                    ],
                  ),
                )
              ],
            ),
          ),
          // Posts
        ],
      ),
    );
  }
}
