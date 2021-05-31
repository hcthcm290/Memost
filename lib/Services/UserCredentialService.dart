import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class UserCredentialService {
  CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<UserCredential> registerNewUserWithEmail(
      String email, String password) async {
    if (email == null || password == null) {
      throw Exception('Email và Password không được để trống');
    }

    try {
      UserCredential newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = new UserModel(
        email: email,
        password: password,
      );

      try {
        await _usersRef.doc(newUser.user.uid).set(user.toMap());
      } catch (e) {
        print(e);
      }

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  String verifyPassword(String password) {
    if (password.length < 8) {
      return "Password must have at least 8 character";
    } else {
      return null;
    }
  }

  Future<String> verifyNewEmail(String email) async {
    QuerySnapshot qsnap =
        await _usersRef.where('email', isEqualTo: email).get();

    List<Map<String, dynamic>> list = <Map<String, dynamic>>[];

    var logger = Logger();
    qsnap.docs.forEach((element) {
      list.add(element.data());
    });

    logger.d("list");

    return "done";
  }

  Future<String> loginWithEmailPassword(String email, String password) async {}
}
