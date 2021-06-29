import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/TagScreens/TagListPostScreen.dart';
import 'package:flutter_application_1/constant.dart';

class Tag extends StatelessWidget {
  const Tag({
    Key key,
    @required this.tagName,
  }) : super(key: key);

  final String tagName;

  void onTap(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TagListPostScreen(tagName: tagName)));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () => onTap(context),
        splashFactory: InkRipple.splashFactory,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: defaultPadding, right: defaultPadding * 0.5),
                child: Icon(
                  CupertinoIcons.tag_fill,
                  size: 18,
                ),
              ),
              Text(
                "$tagName",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
