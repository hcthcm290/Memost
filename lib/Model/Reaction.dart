import 'package:flutter_application_1/Model/Reaction_Type.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as db;

class Reaction {
  String id;
  String owner;
  DateTime createdDate;
  String item;
  String reactionType;
  Reaction();

  ReactionType get reaction {
    switch (reactionType) {
      case "loved":
        return ReactionType.loved;
      case "hated":
        return ReactionType.hated;
      default:
        return ReactionType.none;
    }
  }

  set reaction(value) {
    switch (value) {
      case ReactionType.hated:
        reactionType = "hated";
        break;
      case ReactionType.loved:
        reactionType = "loved";
        break;
      case ReactionType.none:
        reactionType = "none";
        break;
    }
  }

  factory Reaction.fromJson(Map<String, dynamic> json) {
    Reaction a = new Reaction();
    if (json == null) return a;
    a.id = json["id"];
    a.owner = json["owner"];
    a.item = json["item"];
    a.reactionType = json["reactionType"];
    if (json["createdDate"] != null && json["createdDate"] != "") {
      try {
        a.createdDate = DateTime.parse(json["createdDate"]);
      } catch (e) {}
    }

    return a;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["owner"] = owner;
    json["reactionType"] = reactionType;
    json["item"] = item;
    json["createdDate"] = createdDate?.toString();
    return json;
  }

  Future<void> upload(db.CollectionReference uploadLocation) {
    if (id != null && id != "")
      return uploadLocation.doc(id).set(toJson());
    else {
      return uploadLocation.add(toJson()).then((docRef) {
        id = docRef.id;
        return uploadLocation
            .doc(id)
            .set(<String, dynamic>{"id": id}, db.SetOptions(merge: true));
      });
    }
  }

  Future<void> upload2(db.DocumentReference uploadLocation) {
    return upload(uploadLocation.collection("reaction"));
  }
}
