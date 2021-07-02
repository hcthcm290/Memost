import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/DetailPostScreen.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
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

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

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
                  _infoChanged = true;
                });
                Navigator.pop(context);
              },
            ));
  }

  Future<void> saveInfo() async {
    if (!_infoChanged) return;

    var result = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    var userDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(UserCredentialService.instance.currentUser.uid);

    if (_fileAvatar != null) {
      var imageData = await _fileAvatar.readAsBytes();
      var image = await FirebaseStorage.instance
          .ref("users")
          .child(widget.userModel.id)
          .child("image.png")
          .putData(imageData);

      var url = await image.ref.getDownloadURL();

      Map<String, dynamic> avatarMap = {};
      avatarMap["avatarUrl"] = url;

      await userDocRef.update(avatarMap);

      _fileAvatar = null;
      this.widget.userModel.avatarUrl = url;
    }

    Map<String, dynamic> infos = {};
    infos["displayName"] = nameController.text;
    infos["description"] = descController.text;
    await userDocRef.update(infos);

    this.widget.userModel.displayName = nameController.text;
    this.widget.userModel.description = descController.text;

    Navigator.of(context, rootNavigator: true).pop();

    _infoChanged = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAvatarImage();
    nameController.text = widget.userModel.displayName;
    nameController.addListener(() {
      if (this._infoChanged == false &&
          nameController.text != widget.userModel.displayName) {
        this._infoChanged = true;
        setState(() {});
      }
    });

    descController.text = widget.userModel.description != null
        ? "${widget.userModel.description}"
        : "My Funny Collection";
    descController.addListener(() {
      if (this._infoChanged == false &&
          nameController.text != widget.userModel.description) {
        this._infoChanged = true;
        setState(() {});
      }
    });
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
              onPressed: saveInfo,
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
                    controller: nameController,
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
                      controller: descController,
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
