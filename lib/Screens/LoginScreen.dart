import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RegisterScene extends StatefulWidget {
  @override
  _RegisterSceneState createState() => _RegisterSceneState();
}

class _RegisterSceneState extends State<RegisterScene> {
  String _email;
  String _password;
  UserCredentialService _userCredentialService = UserCredentialService();
  bool _passwordHidden = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _emailValidation(String input) {
    if(input.length == 0) {
      return "Email cannot be blank";
    }
  }

  String _passwordVAlidation(String input) {
    if(input.length < 8) {
      return "Password must have at least 8 character";
    }
    else {
      return null;
    }
  }

  void _onEmailInput(String input) {
    this._email = input;
  }

  void _onPasswordInput(String input) {
    this._password = input;
  }

  void _handleRegisterButtonClick() async {
    // try {
    //   UserCredential newUser = await this._userCredentialService.registerNewUserWithEmail(this._email, this._password);
    // } on Exception catch (e) {
    //   print(e);
    // }

    await _userCredentialService.verifyNewEmail("dragonnica123@gmail.com");
  }

  void _handleHidePasswordTap() {
    this._passwordHidden = !this._passwordHidden;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            onChanged: this._onEmailInput,
            decoration: InputDecoration(
              labelText: 'Email',
              fillColor: Colors.white,
            ),
          ),
          TextField(
            obscureText: this._passwordHidden,
            onChanged: this._onPasswordInput,
            decoration: InputDecoration(
              labelText: 'Password',
              fillColor: Colors.white,
              suffixIcon: GestureDetector(
                onTap: _handleHidePasswordTap,
                child: Icon(this._passwordHidden 
                          ? Icons.visibility_off 
                          : Icons.visibility),)
            ),
          ),
          ElevatedButton(
            onPressed: this._handleRegisterButtonClick, 
            child: Text("Register"),
          )
        ],
      ),
    );
  }
}