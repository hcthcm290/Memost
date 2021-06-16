import 'package:flutter/material.dart';

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
