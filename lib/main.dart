// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Group.dart';
import 'package:flutter_application_1/Model/Post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Group group = Group();
  Post post = Post();

  @override
  Widget build(BuildContext context) {
    group.id = "001";
    group.name = "memes";
    group.avatar = "https://www.w3schools.com/w3css/img_nature.jpg";

    post.id = "001";
    post.image = "https://www.w3schools.com/w3css/img_lights.jpg";
    post.owner = "basafish";
    post.title = "First post ever";
    
    return MaterialApp(
      title: 'Startup Name Generator 2',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 100, 100, 100),
        body: SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: true,
          child: Container(
            child: ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return PostUI(post: post, group: group,);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(height: 10.0,),
            ),
          ),
        ),
      ),
    );
  }
}
