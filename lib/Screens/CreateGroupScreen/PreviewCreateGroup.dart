import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';

class PreviewGroupScreen extends StatefulWidget {
  const PreviewGroupScreen({Key key, this.groupName, this.groupDescribtion})
      : super(key: key);

  final String groupName;
  final String groupDescribtion;
  @override
  _PreviewGroupScreenState createState() => _PreviewGroupScreenState();
}

class _PreviewGroupScreenState extends State<PreviewGroupScreen> {
  bool _processing = false;

  void _createCommunity() async {
    // Open loading icon
    setState(() {
      _processing = true;
    });

    // Todo: add group to firebase
    // example wait for 3 second
    await Future.delayed(Duration(milliseconds: 3000));

    // After done, close loading icon
    setState(() {
      _processing = false;
    });

    // Pop back to the main screen
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Todo: go to the group manangement screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(""),
      ),
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: defaultPadding),
                child: Image.asset(
                  "assets/logo/default-group-avatar.png",
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: defaultPadding),
                child: Text("g/${this.widget.groupName}",
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Colors.white)),
              ),
              Text(
                this.widget.groupDescribtion,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.white,
                    ),
              )
            ],
          ),
        ),
        if (_processing)
          Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          )
      ]),

      // Create group button
      floatingActionButton: AbsorbPointer(
        absorbing: _processing ? true : false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding * 1.75),
          child: Material(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(defaultPadding * 2)),
            child: InkWell(
              borderRadius:
                  BorderRadius.all(Radius.circular(defaultPadding * 2)),
              onTap: _createCommunity,
              splashColor: Colors.blue[200],
              child: Container(
                padding: EdgeInsets.symmetric(vertical: defaultPadding * 0.5),
                margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultPadding * 2))),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Create your group",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
