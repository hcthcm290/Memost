import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login/Components/AgreementAndPolicy.dart';
import 'package:flutter_application_1/Screens/Login/Components/LoginOptionCard.dart';
import 'package:flutter_application_1/Screens/Login/LoginScreen.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';

class LoginModal extends StatelessWidget {
  const LoginModal({Key key}) : super(key: key);

  void _loginWithGoogle() async {
    try {
      String uid = await UserCredentialService.instance.loginWithGoogle();
      if (uid != null) {
        print("signed with google uid: $uid");
      }
    } catch (e) {
      print(e);
    }
  }

  void _loginWithFacebook() async {
    String uid = await UserCredentialService.instance.logInWithFacebook();
  }

  void _handleLogInTap(context) {
    print("login");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 350,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultPadding),
              topRight: Radius.circular(defaultPadding))),
      child: Padding(
        padding: EdgeInsets.only(top: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Create an account to continue",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
            SizedBox(
              width: width * 0.75,
              child: AgreementAndPolicy(
                center: true,
              ),
            ),
            SizedBox(
              width: width * 0.75,
              child: LoginOptionCard(
                svgSource: "assets/logo/Google__G__Logo.svg",
                name: "Google",
                onTap: _loginWithGoogle,
              ),
            ),
            SizedBox(
              width: width * 0.75,
              child: LoginOptionCard(
                svgSource: "assets/logo/google_drive.svg",
                name: "Facebook",
                onTap: _loginWithFacebook,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: defaultPadding),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Already a member? ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.white)),
                  TextSpan(
                      text: "Log in",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.blue, fontWeight: FontWeight.w700),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _handleLogInTap(context)),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
