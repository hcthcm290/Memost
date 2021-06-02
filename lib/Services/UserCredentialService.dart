import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserCredentialService {
  CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  final googleSignIn = GoogleSignIn();

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

  Future<String> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> loginWithGoogle() async {
    try {
      final user = await googleSignIn.signIn();

      if (user == null) {
        return null;
      } else {
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final usrCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final qSnapshot = await _usersRef.doc(usrCredential.user.uid).get();

        if (!qSnapshot.exists) {
          final newUser = UserModel(
            username: null,
            email: usrCredential.user.email,
            password: null,
          );

          await _usersRef.doc(usrCredential.user.uid).set(newUser.toMap());
        }

        return usrCredential.user.uid;
      }
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<void> logoutWithGoogle() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
