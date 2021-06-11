import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/CreateGroupScreen/CreateGroupDescription.dart';
import 'package:flutter_application_1/constant.dart';

class CreateGroupNameScreen extends StatefulWidget {
  const CreateGroupNameScreen({Key key}) : super(key: key);

  @override
  _CreateGroupNameScreenState createState() => _CreateGroupNameScreenState();
}

class _CreateGroupNameScreenState extends State<CreateGroupNameScreen> {
  int _currentInputLength = 0;
  int _maxInputLength = 21;
  final textFieldController = TextEditingController();
  String prevTextValue = "";
  String error = "";
  bool _processing = false;

  void _handleInputChange() {
    if (textFieldController.text == prevTextValue) return;

    prevTextValue = textFieldController.text;
    _currentInputLength = textFieldController.text.length;
    error = "";
    setState(() {});
  }

  void _next() async {
    if (_currentInputLength == 0) return;

    print("process next");

    // this line use to close the keyboard
    Future.delayed(Duration(milliseconds: 300),
        () => {FocusScope.of(context).requestFocus(FocusNode())});

    setState(() {
      // Make the screen use loading icon and freeze all input
      _processing = true;
    });

    //todo: Process firestore to check for legit name
    await Future.delayed(Duration(seconds: 5));

    // if something wrong with group name
    setState(() {
      error = "something went wrong";

      // Hide the loading icon and open for input
      _processing = false;
    });

    // if everything alright
    // navigate to the description screen
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateGroupDescriptionScreen(
                  groupName: textFieldController.text,
                )));
  }

  bool _canNext() {
    if (_currentInputLength > 0 && error == "") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    textFieldController.addListener(_handleInputChange);

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
      body: Padding(
        padding:
            EdgeInsets.only(left: defaultPadding, right: defaultPadding * 2),
        child: Stack(children: [
          AbsorbPointer(
            absorbing: _processing ? true : false,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: defaultPadding),
                    child: Text(
                      "Start by creating",
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          letterSpacing: 0.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    "your",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        letterSpacing: 0.5, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "group name",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w900),
                  ),

                  // Input field
                  Padding(
                    padding: EdgeInsets.only(top: defaultPadding * 3),
                    child: Row(
                      children: [
                        Text(
                          "r/",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white24),
                        ),
                        Flexible(
                            child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: TextField(
                            autofocus: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(_maxInputLength),
                            ],
                            controller: textFieldController,
                            style: Theme.of(context).textTheme.headline5,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 0, height: 0),
                                errorText: error == "" ? null : error,
                                contentPadding: EdgeInsets.only(bottom: 8)),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "$error",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.red),
                                ))),
                        Text(
                          "${_maxInputLength - _currentInputLength}",
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Colors.white38, letterSpacing: 2),
                        )
                      ]))
                ],
              ),
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
      ),
    );
  }
}
