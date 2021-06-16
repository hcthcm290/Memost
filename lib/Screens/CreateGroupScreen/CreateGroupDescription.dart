import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/CreateGroupScreen/PreviewCreateGroup.dart';
import 'package:flutter_application_1/constant.dart';

class CreateGroupDescriptionScreen extends StatefulWidget {
  const CreateGroupDescriptionScreen({Key key, this.groupName})
      : super(key: key);

  final String groupName;

  @override
  _CreateGroupDescriptionScreenState createState() =>
      _CreateGroupDescriptionScreenState();
}

class _CreateGroupDescriptionScreenState
    extends State<CreateGroupDescriptionScreen> {
  int _currentInputLength = 0;
  int _maxInputLength = 500;
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

  bool _canNext() {
    if (_currentInputLength > 0 && error == "") {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    textFieldController.addListener(_handleInputChange);
  }

  void _next() async {
    if (_currentInputLength == 0) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PreviewGroupScreen(
                  groupName: this.widget.groupName,
                  groupDescribtion: textFieldController.text,
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
      body: Padding(
        padding:
            EdgeInsets.only(left: defaultPadding, right: defaultPadding * 2),
        child: Stack(children: [
          AbsorbPointer(
            absorbing: _processing ? true : false,
            child: SingleChildScrollView(
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: defaultPadding),
                      child: Text(
                        "Let people know what",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            letterSpacing: 0.5, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      "your community is",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      "about",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: defaultPadding),
                      child: Text(
                        "No pressure, you can change this latter",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white54),
                      ),
                    ),

                    // Input field
                    Padding(
                      padding: EdgeInsets.only(top: defaultPadding),
                      child: Flexible(
                          child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: true,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(_maxInputLength),
                        ],
                        controller: textFieldController,
                        style: Theme.of(context).textTheme.headline6,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                            labelText: "Describe your group",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.blue, letterSpacing: 0),
                            errorStyle: TextStyle(fontSize: 0, height: 0),
                            errorText: error == "" ? null : error,
                            contentPadding: EdgeInsets.only(bottom: 8),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2))),
                      )),
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
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: Colors.white38, letterSpacing: 2),
                          )
                        ])),
                  ],
                ),
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
