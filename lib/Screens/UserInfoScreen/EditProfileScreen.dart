import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/DetailPostScreen.dart';
import 'package:flutter_application_1/constant.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key, this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _infoChanged = false;

  ImageProvider _avatarImage = null;
  File _fileAvatar;

  Future<void> _getAvatarImage() async {
    if (widget.userModel.avatarUrl == null ||
        widget.userModel.avatarUrl == "") {
      _avatarImage = Image.asset("assets/logo/default-group-avatar.png").image;
    } else {
      _avatarImage = CachedNetworkImageProvider(widget.userModel.avatarUrl);
    }

    setState(() {});
  }

  void _changeAvatar() {
    showModalBottomSheet(
        context: context,
        builder: (context) => ChooseImageTypeModel(
              onChooseImage: (image) {
                setState(() {
                  _fileAvatar = image;
                  _avatarImage = Image.file(image).image;
                });
                Navigator.pop(context);
              },
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAvatarImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Edit Profile",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {},
              child: Text("Save",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: _infoChanged ? Colors.blue : Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        color: Colors.black,
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          image: _avatarImage,
                          fit: BoxFit.cover,
                        ),
                      )),
                  TextButton(
                      onPressed: _changeAvatar,
                      child: Text(
                        "Change avatar",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.blue),
                      ))
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Row(
              children: [
                Text(
                  "Name",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
                Flexible(
                  child: TextFormField(
                    initialValue: "${widget.userModel.displayName}",
                    textAlign: TextAlign.end,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Short Desciption",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.white, fontSize: 12),
                    ),
                    TextFormField(
                      initialValue: widget.userModel.description != null
                          ? "${widget.userModel.description}"
                          : "My Funny Collection",
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      minLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
