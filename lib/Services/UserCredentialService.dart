import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class UserCredentialService {
  UserModel model;
  final _onAuthChange = new StreamController<User>.broadcast(sync: true);
  Stream<User> get onAuthChange => _onAuthChange.stream;

  static UserCredentialService _instance = null;
  static UserCredentialService get instance {
    if (_instance == null) {
      _instance = UserCredentialService._();
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        instance.model = await UserCredentialService.convertToUserModel(event);
        _instance._currentUser = event;
        _instance._onAuthChange.add(event);
      });
    }

    return _instance;
  }

  UserCredentialService._() {}

  User _currentUser = null;
  User get currentUser => _currentUser;

  static Stream<UserModel> get user {
    return FirebaseAuth.instance.authStateChanges().map((user) {
      convertToUserModel(user).then((value) {
        return value;
      });

      return null;
    });
  }

  static Future<UserModel> convertToUserModel(User user) async {
    if (user == null) return null;
    try {
      final userModelSnapshot = await _usersRef.doc(user.uid).get();
      Map<String, dynamic> userModelData = userModelSnapshot.data();

      UserModel model = UserModel();
      model.fromMap(userModelData);
      model.id = user.uid;

      return model;
    } catch (e) {
      print(e);
    }
  }

  static CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  FacebookLogin facebookSignIn = new FacebookLogin();
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

      _onAuthChange.add(userCredential.user);
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
              username: "basa google",
              email: usrCredential.user.email,
              password: null,
              avatarUrl:
                  "https://yt3.ggpht.com/ytc/AAUvwng30OdQa0xi_lXW1JiW4rY81E5l61WhjpKptAbNUw=s88-c-k-c0x00ffffff-no-rj");

          await _usersRef.doc(usrCredential.user.uid).set(newUser.toMap());

          _onAuthChange.add(usrCredential.user);
        }

        return usrCredential.user.uid;
      }
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<void> logOut() async {
    try {
      await logoutWithGoogle();
    } catch (e) {}

    try {
      await logOutFacebook();
    } catch (e) {}

    return;
  }

  Future<void> logoutWithGoogle() async {
    try {
      await googleSignIn.disconnect();
    } catch (e) {}

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {}
    return;
  }

  Future<String> logInWithFacebook() async {
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        final FBcredential = FacebookAuthProvider.credential(accessToken.token);
        final usrCredential =
            await FirebaseAuth.instance.signInWithCredential(FBcredential);
        //Uri.http("https://graph.facebook.com", "/v2.12/me", [{"field": "name,first_name,last_name,email"}, "access_token": "${accessToken.token}"]);
        var uri = Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
        final graphResponse = await http.get(uri);
        final profile = jsonDecode(graphResponse.body);
        print("fb user profile: ${profile["email"]}");

        final qSnapshot = await _usersRef.doc(usrCredential.user.uid).get();

        if (!qSnapshot.exists) {
          final newUser = UserModel(
              username: "basa fb",
              email: profile["email"],
              password: null,
              avatarUrl:
                  "https://s3-symbol-logo.tradingview.com/facebook--big.svg");
          await _usersRef.doc(usrCredential.user.uid).set(newUser.toMap());

          _onAuthChange.add(usrCredential.user);
        }

        return usrCredential.user.uid;

      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        return null;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        return null;
    }
  }

  Future<Null> logOutFacebook() async {
    try {
      await facebookSignIn.logOut();
      await FirebaseAuth.instance.signOut();
      facebookSignIn = new FacebookLogin();
    } catch (e) {
      print("error");
    }

    print('FB Logged out.');
  }
}
