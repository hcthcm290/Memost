

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCredentialService {
  CollectionReference _usersRef = FirebaseFirestore.instance.collection('users');

  Future<UserCredential> registerNewUserWithEmail(String email, String password) async {
    if(email == null || password == null) {
      throw Exception('Email và Password không được để trống');
    }

    try {
      UserCredential newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

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
}