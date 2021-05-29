import 'package:flutter/gestures.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _loginWithGoogle() {
    print("login with google");
  }

  void _loginWithFacebook() {
    print("login with Facebook");
  }

  void _loginWithTwitter() {
    print("login with Twitter");
  }

  void _signUp() {
    print("sign up");
  }

  void _forgotPassword() {
    print("forgot password");
  }

  FocusNode _userNameFN = FocusNode();
  FocusNode _passwordFN = FocusNode();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
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
          LoginOptionCard(
            svgSource: "assets/logo/google_drive.svg",
            name: "Twitter",
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

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom,
          color: Colors.black,
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
                TextField(
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w300),
                  focusNode: _userNameFN,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0),
                    labelText: "Username",
                    labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                        color:
                            _userNameFN.hasFocus ? Colors.blue : Colors.white60,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        height: 0.5),
                  ),
                ),
                SizedBox(height: defaultPadding),
                TextField(
                  obscureText: hidePassword,
                  obscuringCharacter: '*',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w300),
                  focusNode: _passwordFN,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0),
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
                          color: hidePassword ? Colors.white60 : Colors.blue,
                          size: 26,
                        ),
                      ),
                    ),
                    labelText: "Password",
                    labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                        color:
                            _passwordFN.hasFocus ? Colors.blue : Colors.white60,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        height: 0.5),
                  ),
                ),
                SizedBox(height: defaultPadding * 1.75),
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
                    recognizer: TapGestureRecognizer()..onTap = _forgotPassword,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.blue, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
        margin: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius:
                BorderRadius.all(Radius.circular(defaultPadding * 2))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Continue",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.white30,
        ),
        Container(
          width: 70,
          color: Colors.black,
          child: Center(
            child: Text(
              "OR",
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginOptionCard extends StatelessWidget {
  const LoginOptionCard({
    Key key,
    this.onTap,
    @required this.svgSource,
    @required this.name,
  }) : super(key: key);

  final VoidCallback onTap;
  final String svgSource, name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(defaultPadding * 2)),
            border: Border.all(color: Colors.blue, width: 1.2)),
        child: Padding(
          padding: EdgeInsets.all(defaultPadding * 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgSource,
                height: 18,
              ),
              Spacer(),
              Text(
                "Continue with $name",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.blue, fontWeight: FontWeight.w900),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

class AgreementAndPolicy extends StatelessWidget {
  const AgreementAndPolicy({
    Key key,
  }) : super(key: key);

  void _handleUserAgreementTap(context) {}

  void _handlePrivacyPolicyTap(context) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "By continuing, you agree to our ",
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Colors.white60, fontWeight: FontWeight.w300)),
        TextSpan(
            text: "User Agreement ",
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Colors.blue, fontWeight: FontWeight.w300),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleUserAgreementTap(context)),
        TextSpan(
            text: "and ",
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Colors.white60, fontWeight: FontWeight.w300)),
        TextSpan(
            text: "Privacy Policy",
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Colors.blue, fontWeight: FontWeight.w300),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handlePrivacyPolicyTap(context)),
        TextSpan(
            text: ".",
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Colors.white60, fontWeight: FontWeight.w300)),
      ])),
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
  UserCredentialService _userCredentialService = UserCredentialService();
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
