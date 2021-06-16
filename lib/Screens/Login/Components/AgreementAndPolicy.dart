import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../constant.dart';

class AgreementAndPolicy extends StatelessWidget {
  const AgreementAndPolicy({
    Key key,
    this.center = false,
  }) : super(key: key);

  final bool center;
  void _handleUserAgreementTap(context) {}

  void _handlePrivacyPolicyTap(context) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: RichText(
          textAlign: center ? TextAlign.center : TextAlign.start,
          text: TextSpan(children: [
            TextSpan(
                text: "By continuing, you agree to our ",
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Colors.white60, fontWeight: FontWeight.w300)),
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
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Colors.white60, fontWeight: FontWeight.w300)),
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
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Colors.white60, fontWeight: FontWeight.w300)),
          ])),
    );
  }
}
