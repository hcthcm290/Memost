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
  @Deprecated("Use Get/SetImage instead")
  String image;
  Post();
  factory Post.fromJson(Map<String, dynamic> json) {
    Post a = new Post();
    if (json == null) return a;
    a.id = json["id"];
    a.owner = json["owner"];
    a.title = json["title"];
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
    return json;
  }

  Future<ImageProvider> getImage() => FirebaseStorage.instance
      .ref("Post")
      .child(id)
      .child("image.png")
      .getData()
      .then((value) => MemoryImage(value));

  void setImage(Uint8List i) => FirebaseStorage.instance
      .ref("Post")
      .child(id)
      .child("image.png")
      .putData(i);
  Future<void> upload() {
    if (id != null && id != "")
      return db.FirebaseFirestore.instance
          .collection("Post")
          .doc(id)
          .set(toJson());
    else {
      return db.FirebaseFirestore.instance
          .collection("Post")
          .add(toJson())
          .then((docRef) {
        id = docRef.id;
        return db.FirebaseFirestore.instance
            .collection("Post")
            .doc(id)
            .set(<String, dynamic>{"id": id});
      });
    }
  }
}
