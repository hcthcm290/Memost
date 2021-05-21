import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TopicScene extends StatefulWidget {
  @override
  _TopicSceneState createState() => _TopicSceneState();
}

class _TopicSceneState extends State<TopicScene> {
  String _topicName = "memes";
  String _password;
  UserCredentialService _userCredentialService = UserCredentialService();
  bool _isSubscribed = false;

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
      child: Column(
        children: [
          Image(
            fit: BoxFit.fitWidth,
            image: _getBigImage(),
          ),
          Container(
            height: 100,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _getSmallImage(),
                  radius: 50,
                ),
                Expanded(
                  child: AutoSizeText(
                    _getTopicName(),
                    softWrap: false,
                    style: TextStyle(fontSize: 100),
                    maxLines: 1,
                  ),
                ),
                ElevatedButton(
                  child: Text(_subButtonName()),
                  onPressed: _onSubButtonPressed,
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
