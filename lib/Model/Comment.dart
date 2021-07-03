import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as db;
import 'package:flutter_application_1/Model/Notification.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';

import 'Post.dart';

class Comment {
  String id;
  String owner;
  DateTime createdDate;
  Post post;
  String content;
  String prevComment; // ID
  String imgLink;
  String isDeleted;
  Comment();
  factory Comment.fromJson(Map<String, dynamic> json, Post post) {
    Comment a = new Comment();
    if (json == null) return a;
    a.id = json["id"];
    a.owner = json["owner"];
    a.post = post;
    a.content = json["content"];
    a.prevComment = json["prevComment"];
    a.imgLink = json["imgLink"];
    try {
      a.createdDate = DateTime.parse(json["createdDate"]);
    } catch (e) {}
    a.isDeleted = json["isDeleted"];
    return a;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["owner"] = owner;
    json["post"] = post.id;
    json["content"] = content;
    json["prevComment"] = prevComment;
    json["imgLink"] = imgLink;
    json["createdDate"] = createdDate?.toString();
    json["isDeleted"] = isDeleted;
    return json;
  }

  Future<ImageProvider> getImage() => FirebaseStorage.instance
      .ref("comment")
      .child(id)
      .child("image.png")
      .getData()
      .then((value) => MemoryImage(value));

  Future<void> setImage(Uint8List i) async {
    /*
     FirebaseStorage.instance
           .ref("comment")
           .child(id)
           .child("image.png")
           .putData(i)
           .then((value) {
         value.ref.getDownloadURL().then((value) {
           imgLink = value;
           if (id != null)
             db.FirebaseFirestore.instance
                 .collection("post")
                 .doc(post.id)
                 .collection("comment")
                 .doc(id)
                 .set(<String, dynamic>{"imgLink": value},
                     db.SetOptions(merge: true));
         });
       });
       // */
    //*
    TaskSnapshot imageSnap = await FirebaseStorage.instance
        .ref("comment")
        .child(id)
        .child("image.png")
        .putData(i);

    this.imgLink = await imageSnap.ref.getDownloadURL();

    if (id != null) {
      await db.FirebaseFirestore.instance
          .collection("post")
          .doc(post.id)
          .collection("comment")
          .doc(id)
          .set(<String, dynamic>{"imgLink": imgLink},
              db.SetOptions(merge: true));
      return;
    } else
      return;
    // */
  }

  Future<void> upload() async {
    if (id != null && id != "")
      return db.FirebaseFirestore.instance
          .collection("post")
          .doc(post.id)
          .collection("comment")
          .doc(id)
          .set(toJson());
    else {
      var docRef = await db.FirebaseFirestore.instance
          .collection("post")
          .doc(post.id)
          .collection("comment")
          .add(toJson());
      id = docRef.id;
      await db.FirebaseFirestore.instance
          .collection("post")
          .doc(post.id)
          .collection("comment")
          .doc(id)
          .set(<String, dynamic>{"id": id}, db.SetOptions(merge: true));

      // create notification
      NotificationModel notiModel = NotificationModel();
      notiModel.postId = post.id;
      notiModel.actor = (await UserCredentialService.convertToUserModel(
              UserCredentialService.instance.currentUser))
          .username;
      notiModel.commentId = id;
      notiModel.receiver = post.owner;
      var notiRef = await db.FirebaseFirestore.instance
          .collection("notification")
          .add(notiModel.toJson());
      notiModel.id = notiRef.id;
      notiRef.update(notiModel.toJson());

      return;
    }
  }
}
