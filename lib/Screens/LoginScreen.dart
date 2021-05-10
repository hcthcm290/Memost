import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScene extends StatelessWidget {
  String _email;
  String _password;

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
  }

  void _onEmailInput(String input) {
    this._email = input;
  }

  void _onPasswordInput(String input) {
    this._password = input;
  }

  void _handleRegisterButtonClick() async {
    final formState = _formKey.currentState;
    if(true) {
      try {
        //UserCredential newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        //print(newUser.user.email);

      } on FirebaseAuthException catch (e) {
        print('Failed with error code: ${e.code}');
        print(e.message);
      } catch (e) {
        print(e);
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            validator: this._emailValidation,
            onSaved: this._onEmailInput,
            decoration: InputDecoration(
              labelText: 'Email',
              fillColor: Colors.white,
            ),
          ),
          TextFormField(
            validator: this._passwordVAlidation,
            onSaved: this._onPasswordInput,
            decoration: InputDecoration(
              labelText: 'Password',
              fillColor: Colors.white,
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