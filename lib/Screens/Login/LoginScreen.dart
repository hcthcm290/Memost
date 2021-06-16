import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_1/Screens/Login/Components/AgreementAndPolicy.dart';
import 'package:flutter_application_1/Screens/Login/Components/LoginOptionCard.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/constant.dart';

import 'Components/CustomDivider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserCredentialService _userCredentialService = UserCredentialService.instance;
  String _email = "";
  String _password = "";
  String _emailError = null;
  String _passwordError = null;
  bool _processing = false;

  void _loginWithGoogle() async {
    setState(() {
      _processing = true;
    });
    try {
      String uid = await _userCredentialService.loginWithGoogle();
      if (uid != null) {
        print("signed with google uid: $uid");

        Navigator.pop(context);
      }
      setState(() {
        _processing = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _processing = false;
      });
    }
  }

  void _loginWithFacebook() async {
    setState(() {
      _processing = true;
    });
    String uid = await _userCredentialService.logInWithFacebook();
    if (uid != null) {
      print("signed with google uid: $uid");

      Navigator.pop(context);
    }
    setState(() {
      _processing = false;
    });
  }

  void _loginWithTwitter() {
    print("login with Twitter");
  }

  void _signUp() async {
    print("sign up");
  }

  void _forgotPassword() async {
    _userCredentialService.logoutWithGoogle();
  }

  void _continue() async {
    print("email: $_email , password: $_password");
    _processing = true;
    setState(() {});

    String result =
        await _userCredentialService.loginWithEmailPassword(_email, _password);

    if (result == "user-not-found") {
      _emailError = "Email not exist";
    } else if (result == "wrong-password") {
      _passwordError = "Wrong password";
    } else if (result == "unknown") {
      print("Unknown error");
    } else {
      _processing = false;
      print("login success with uid $result");

      Navigator.pop(context);
    }
    _processing = false;
    setState(() {});
  }

  FocusNode _userNameFN = FocusNode();
  FocusNode _passwordFN = FocusNode();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print("logout");
      } else {
        print("log in: ${user.uid}");
      }
    });

    var loginMethodsContainer = Container(
      padding:
          EdgeInsets.only(top: defaultPadding * 0.25, bottom: defaultPadding),
      child: Column(
        children: [
          LoginOptionCard(
            svgSource: "assets/logo/Google__G__Logo.svg",
            name: "Google",
            onTap: _loginWithGoogle,
          ),
          LoginOptionCard(
            svgSource: "assets/logo/google_drive.svg",
            name: "Facebook",
            onTap: _loginWithFacebook,
          ),
        ],
      ),
    );

    _userNameFN.addListener(() {
      setState(() {});
    });

    _passwordFN.addListener(() {
      setState(() {});
    });

    void onTapSignUp() {}

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text("")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom,
          color: Colors.black,
          child: Stack(children: [
            AbsorbPointer(
              absorbing: _processing ? true : false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log in",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white),
                    ),
                    AgreementAndPolicy(),
                    loginMethodsContainer,
                    CustomDivider(),
                    SizedBox(height: defaultPadding),
                    // Email
                    TextField(
                      onChanged: (value) {
                        _email = value;

                        if (_emailError != null) {
                          _emailError = null;
                          setState(() {});
                        }
                      },
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w300),
                      focusNode: _userNameFN,
                      decoration: InputDecoration(
                        errorText: _emailError,
                        errorStyle: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.redAccent),
                        contentPadding: EdgeInsets.only(bottom: 10),
                        labelText: "Email",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(
                                color: _userNameFN.hasFocus
                                    ? Colors.blue
                                    : Colors.white60,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                height: 0.5),
                      ),
                    ),
                    SizedBox(height: defaultPadding),
                    // Password
                    TextField(
                      onChanged: (value) {
                        _password = value;

                        if (_passwordError != null) {
                          _passwordError = null;
                          setState(() {});
                        }
                      },
                      obscureText: hidePassword,
                      obscuringCharacter: '*',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w300),
                      focusNode: _passwordFN,
                      decoration: InputDecoration(
                        errorText: _passwordError,
                        contentPadding: EdgeInsets.only(bottom: 10),
                        suffixIcon: InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            hidePassword = !hidePassword;
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: defaultPadding, top: defaultPadding),
                            child: Icon(
                              CupertinoIcons.eye,
                              color:
                                  hidePassword ? Colors.white60 : Colors.blue,
                              size: 26,
                            ),
                          ),
                        ),
                        labelText: "Password",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(
                                color: _passwordFN.hasFocus
                                    ? Colors.blue
                                    : Colors.white60,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                height: 0.5),
                      ),
                    ),
                    SizedBox(height: defaultPadding * 1.75),
                    // Signup text
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "New to Memmost? ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: Colors.white54)),
                      TextSpan(
                          text: "Sign up",
                          recognizer: TapGestureRecognizer()..onTap = _signUp,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.blue, fontWeight: FontWeight.w800)),
                    ])),
                    SizedBox(height: defaultPadding * 1.75),
                    RichText(
                      text: TextSpan(
                        text: "Forgot password",
                        recognizer: TapGestureRecognizer()
                          ..onTap = _forgotPassword,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.blue, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            if (_processing)
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
          ]),
        ),
      ),
      floatingActionButton: AbsorbPointer(
        absorbing: _processing ? true : false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding * 1.75),
          child: Material(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(defaultPadding * 2)),
            child: InkWell(
              borderRadius:
                  BorderRadius.all(Radius.circular(defaultPadding * 2)),
              onTap: _continue,
              splashColor: Colors.blue[200],
              child: Container(
                padding: EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
                margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultPadding * 2))),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Continue",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class RegisterScene extends StatefulWidget {
  @override
  _RegisterSceneState createState() => _RegisterSceneState();
}

class _RegisterSceneState extends State<RegisterScene> {
  String _email;
  String _password;
  UserCredentialService _userCredentialService = UserCredentialService.instance;
  bool _passwordHidden = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _emailValidation(String input) {
    if (input.length == 0) {
      return "Email cannot be blank";
    }
  }

  String _passwordVAlidation(String input) {
    if (input.length < 8) {
      return "Password must have at least 8 character";
    } else {
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
                      : Icons.visibility),
                )),
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
