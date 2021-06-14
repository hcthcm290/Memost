import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constant.dart';

class CreateTagPostScreen extends StatefulWidget {
  CreateTagPostScreen({Key key, @required this.image, @required this.title})
      : super(key: key);

  final File image;
  final String title;

  @override
  _CreateTagPostScreenState createState() => _CreateTagPostScreenState();
}

class _CreateTagPostScreenState extends State<CreateTagPostScreen> {
  TextEditingController tag1Ctrl;
  TextEditingController tag2Ctrl;
  TextEditingController tag3Ctrl;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    tag1Ctrl = TextEditingController();
    tag2Ctrl = TextEditingController();
    tag3Ctrl = TextEditingController();

    tag1Ctrl.addListener(handleTag1Input);
    tag2Ctrl.addListener(handleTag2Input);
    tag3Ctrl.addListener(handleTag3Input);
  }

  void handleTag1Input() {}
  void handleTag2Input() {}
  void handleTag3Input() {}

  void _createPost() {
    setState(() {
      _processing = true;
    });

    // Todo: add this post to firebase

    setState(() {
      _processing = false;
    });

    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(children: [
          Spacer(),
          RichText(
            text: TextSpan(
              text: "Post",
              recognizer: TapGestureRecognizer()..onTap = () => _createPost(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: 18, color: Colors.blue),
            ),
          )
        ]),
      ),
      body: Stack(children: [
        Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.only(left: defaultPadding),
                          child: Text(this.widget.title))),
                  Flexible(
                      child: Image.file(
                    this.widget.image,
                    height: 150,
                  )),
                ],
              ),
              Row(
                children: [
                  Text("Want to add any tags"),
                ],
              ),
              TagInputField(
                hintText: "Tag 1",
                controller: tag1Ctrl,
              ),
              TagInputField(
                hintText: "Tag 2",
                controller: tag2Ctrl,
              ),
              TagInputField(
                hintText: "Tag 3",
                controller: tag3Ctrl,
              ),
            ],
          ),
        ),
        // Loading Icon
        if (_processing)
          Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          )
      ]),
    );
  }
}

class TagInputField extends StatelessWidget {
  const TagInputField({
    Key key,
    this.controller,
    this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
      padding: EdgeInsets.only(left: defaultPadding),
      child: TextField(
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(fontWeight: FontWeight.w600),
        textAlignVertical: TextAlignVertical.bottom,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorStyle: TextStyle(fontSize: 0, height: 0),
          hintText: hintText,
        ),
      ),
    ));
  }
}
