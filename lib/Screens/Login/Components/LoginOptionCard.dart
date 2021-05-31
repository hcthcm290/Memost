import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constant.dart';

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
