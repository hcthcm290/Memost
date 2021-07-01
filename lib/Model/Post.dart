import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Post {
  String id;
  String owner;
  DateTime createdDate;
  String title;
  String isDeleted;
  String image;
  Post();
  factory Post.fromJson(Map<String, dynamic> json) {
    Post a = new Post();
    if (json == null) return a;
    a.id = json["id"];
    a.owner = json["owner"];
    a.title = json["title"];
    a.image = json["image"];
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
    json["title"] = title;
    json["createdDate"] = createdDate?.toString();
    json["isDeleted"] = isDeleted;
    json["image"] = image;
    return json;
  }

  Future<ImageProvider> getImage() => FirebaseStorage.instance
      .ref("post")
      .child(id)
      .child("image.png")
      .getData()
      .then((value) => MemoryImage(value));

  Future<void> setImage(Uint8List i) async {
    var value = await FirebaseStorage.instance
        .ref("post")
        .child(id)
        .child("image.png")
        .putData(i);

    var url = await value.ref.getDownloadURL();

    image = url;
    if (id != null) {
      await db.FirebaseFirestore.instance
          .collection("post")
          .doc(id)
          .set(<String, dynamic>{"image": url}, db.SetOptions(merge: true));
      return;
    } else
      return;
  }

  Future<void> upload() async {
    if (id != null && id != "") {
      await db.FirebaseFirestore.instance
          .collection("post")
          .doc(id)
          .set(toJson());
      return;
    } else {
      var docRef =
          await db.FirebaseFirestore.instance.collection("post").add(toJson());

      id = docRef.id;
      await db.FirebaseFirestore.instance
          .collection("post")
          .doc(id)
          .set(<String, dynamic>{"id": id}, db.SetOptions(merge: true));

      return;
      ;
    }
  }
}
