
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Model/Group.dart';

class PostUI extends StatefulWidget {

  final Post post;
  final Group group;

  PostUI({Key key, @required  this.post, @required this.group})
    :
    super(key: key);

  @override
  _PostUIState createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              // Container(
              //   width: 50,
              //   height: 50,
              //   decoration: new BoxDecoration(
              //     shape: BoxShape.circle,
              //     border: Border.all(color: Colors.teal, width: 3.0, style: BorderStyle.solid),
              //     image: new DecorationImage(image: CachedNetworkImageProvider(widget.group.avatar), fit: BoxFit.cover)
              //   ),
              // )
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(imageUrl: widget.group.avatar, width: 50, height: 50, fit: BoxFit.fill,),)
            ],
          ),
          Align(child: Text(widget.post.title, style: TextStyle(fontSize: 20)), alignment: Alignment.centerLeft,),
          CachedNetworkImage(imageUrl: widget.post.image, placeholder: (context, url) => CircularProgressIndicator(),),
        ],
      ),
    );
  }
}