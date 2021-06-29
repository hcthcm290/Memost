import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class Group {
  String id;
  String owner;
  DateTime createdDate;
  String name;
  String description;
  bool isDeleted;
  String type;
  Group();

  factory Group.fromJson(Map<String, dynamic> json) {
    Group a = new Group();
    if (json == null) return a;
    a.id = json["id"];
    a.owner = json["owner"];
    a.name = json["name"];
    a.type = json["type"];
    try {
      a.createdDate = DateTime.parse(json["createdDate"]);
    } catch (e) {}
    a.description = json["description"];
    a.isDeleted = json["isDeleted"];
    return a;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["owner"] = owner;
    json["name"] = name;
    json["type"] = type;
    json["createdDate"] = createdDate?.toString();
    json["description"] = description;
    json["isDeleted"] = isDeleted;
    return json;
  }

  Future<ImageProvider> getAvatar() =>
      //Future(() => NetworkImage("https://www.w3schools.com/w3css/img_lights.jpg"));
      //*
      FirebaseStorage.instance
          .ref(name)
          .child("Avatar.png")
          .getData()
          .then((value) => MemoryImage(value));
  // */
  void setAvatar(Uint8List i) =>
      FirebaseStorage.instance.ref(name).child("Avatar.png").putData(i);

  Future<ImageProvider> getBackground() => FirebaseStorage.instance
      .ref(name)
      .child("Background.png")
      .getData()
      .then((value) => MemoryImage(value));

  void setBackground(Uint8List i) =>
      FirebaseStorage.instance.ref(name).child("Background.png").putData(i);
}
