import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/CreatePostScreens/CreatePostDescriptionScreen.dart';
import 'package:flutter_application_1/Screens/Login/Components/LoginOptionCard.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadTypeModal extends StatefulWidget {
  UploadTypeModal({Key key}) : super(key: key);

  @override
  _UploadTypeModalState createState() => _UploadTypeModalState();
}

class _UploadTypeModalState extends State<UploadTypeModal> {
  final _imagePicker = ImagePicker();

  void _takeAPhoto() async {
    final image = await _imagePicker.getImage(source: ImageSource.camera);

    print(image);
    if (image != null) {
      // Todo: Navigate to upload screen
      print(image.path);
    }
  }

  void _fromLibrary() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      final image = await _imagePicker.getImage(source: ImageSource.gallery);

      print(image);
      if (image != null) {
        // Todo: Navigate to upload screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreatePostDescriptionScreen(
                      image: File(image.path),
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.circular(defaultPadding)),
      child: Padding(
        padding: EdgeInsets.only(top: defaultPadding),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              InkWell(
                splashFactory: InkRipple.splashFactory,
                onTap: _fromLibrary,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: defaultPadding * 1.5),
                        child: Icon(CupertinoIcons.arrow_up_doc,
                            size: 30, color: Colors.blue),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: defaultPadding * 1.5),
                        child: Text(
                          "Choose from library",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                splashFactory: InkRipple.splashFactory,
                onTap: _takeAPhoto,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: defaultPadding * 1.5),
                          child: Icon(CupertinoIcons.camera,
                              size: 30, color: Colors.green)),
                      Padding(
                        padding: EdgeInsets.only(left: defaultPadding * 1.5),
                        child: Text(
                          "Take a photo",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.green),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
