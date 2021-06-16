import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/CreatePostScreens/CreateTagScreen.dart';
import 'package:flutter_application_1/constant.dart';

class CreatePostDescriptionScreen extends StatefulWidget {
  CreatePostDescriptionScreen({Key key, @required this.image})
      : super(key: key);

  final File image;

  @override
  _CreatePostDescriptionScreenState createState() =>
      _CreatePostDescriptionScreenState();
}

class _CreatePostDescriptionScreenState
    extends State<CreatePostDescriptionScreen> {
  int maxAvailableTitle = 280;
  int currentTitle = 0;
  final titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.addListener(_handleInput);
  }

  void _handleInput() {
    currentTitle = titleController.text.length;
    setState(() {});
  }

  bool _canNext() {
    if (titleController.text.length > 0)
      return true;
    else
      return false;
  }

  void _next() {
    if (!_canNext()) return;

    // Todo: Navigate to tag screen
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateTagPostScreen(
                  image: this.widget.image,
                  title: titleController.text,
                )));
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
              text: "Next",
              recognizer: TapGestureRecognizer()..onTap = () => _next(),
              style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 18,
                  color: _canNext() ? Colors.blue : Colors.blue.withAlpha(100)),
            ),
          )
        ]),
      ),
      body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Image.file(
                this.widget.image,
                height: 200,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: defaultPadding, top: defaultPadding),
                child: Row(
                  children: [
                    Text(
                      "Title",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "$currentTitle/$maxAvailableTitle",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.blue),
                    )
                  ],
                ),
              ),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.only(left: defaultPadding),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxAvailableTitle),
                  ],
                  controller: titleController,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorStyle: TextStyle(fontSize: 0, height: 0),
                    hintText: "Describe your meme",
                  ),
                ),
              ))
            ],
          )),
    );
  }
}
