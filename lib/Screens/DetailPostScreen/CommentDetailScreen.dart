import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Comment.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/Components/CommentTile.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/DetailPostScreen.dart';
import 'package:flutter_application_1/Services/UserCredentialService.dart';
import 'package:flutter_application_1/constant.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as db;

class CommentDetailScreen extends StatefulWidget {
  CommentDetailScreen({Key key, this.comment, this.autoFocusInput = false})
      : super(key: key);

  final Comment comment;
  final bool autoFocusInput;

  @override
  _CommentDetailScreenState createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  List<Comment> subComments = [];
  TextEditingController inputController = TextEditingController();
  ImageProvider _imageInComment;
  File _fileImageInComment;

  Comment comment() => widget.comment;
  UserModel get userModel => UserCredentialService.instance.model;
  db.QuerySnapshot snapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputController.addListener(_handleInputCommentChange);

    // Todo: Fetch subcomment for comment
    /*
    UserCredentialService.convertToUserModel(
            UserCredentialService.instance.currentUser)
        .then((value) {
      setState(() {
        userModel = value;
      });
    });
    UserCredentialService.instance.onAuthChange.listen((user) async {
      userModel = await UserCredentialService.convertToUserModel(user);

      setState(() {});
    });
    // */

    var query = db.FirebaseFirestore.instance
        .collection("post")
        .doc(comment().post.id)
        .collection("comment")
        .where("isDeleted", isNotEqualTo: "true")
        .where("prevComment", isEqualTo: comment().id);

    query.get().then((value) {
      this.setState(() {
        snapshot = value;
        loadComment();
      });
    });
    db.FirebaseFirestore.instance
        .collection("post")
        .doc(comment().post.id)
        .collection("comment")
        .where("isDeleted", isNotEqualTo: "true")
        .where("prevComment", isEqualTo: comment().id)
        .snapshots()
        .listen((value) {
      this.setState(() {
        snapshot = value;
        loadComment();
      });
    });

/*
    Comment commentWithImage = Comment();
    commentWithImage.content = "Comment with image";
    commentWithImage.createdDate = DateTime.now();
    commentWithImage.imgLink =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/2010-kodiak-bear-1.jpg/220px-2010-kodiak-bear-1.jpg";
    commentWithImage.owner = "basa102";

    subComments.add(commentWithImage);
    subComments.add(widget.comment);
    // */
  }

  void loadComment() {
    subComments.clear();
    subComments = snapshot.docs
        .map((e) => Comment.fromJson(e.data(), comment().post))
        .toList();
  }

  void _handleInputCommentChange() {
    // only update ui when input controller change from no text to text to save performance
    if (inputController.text.length < 2) {
      setState(() {});
    }
  }

  void _handleOnTapCameraIcon() {
    showModalBottomSheet(
        context: context,
        builder: (context) => ChooseImageTypeModel(
              onChooseImage: (image) {
                setState(() {
                  _imageInComment = Image.file(image).image;
                  _fileImageInComment = image;
                });
                Navigator.pop(context);
              },
            ));
  }

  void _postComment() {
    Comment cmt = new Comment();
    cmt.content = inputController.text;
    cmt.createdDate = DateTime.now();
    cmt.isDeleted = "false";
    cmt.owner = userModel.username;
    cmt.post = comment().post;
    cmt.prevComment = comment().id;
    cmt.upload().then((_) {
      if (_fileImageInComment != null)
        cmt.setImage(_fileImageInComment.readAsBytesSync());
      FocusScope.of(context).unfocus();
      inputController.text = "";
      _imageInComment = null;
      _fileImageInComment = null;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Post"),
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          child: ListView.builder(
              itemCount: subComments.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Base comment
                  return CommentTile(
                    key: ValueKey(this.widget.comment.id),
                    comment: this.widget.comment,
                  );
                } else {
                  // Sub comment
                  return CommentTile(
                    key: ValueKey(subComments[index - 1].id),
                    avatarSizePercentage: 0.8,
                    comment: subComments[index - 1],
                  );
                }
              }),
        ),
        buildBottomCommentInput(context)
      ]),
    );
  }

  Align buildBottomCommentInput(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(bottom: defaultPadding * 0.5),
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              height: 2,
              thickness: 2,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: defaultPadding * 0.75,
                right: defaultPadding * 0.75,
                top: defaultPadding * 0.75,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 0.75,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_imageInComment != null)
                      Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 0.75),
                        child: Container(
                          width: 75,
                          height: 75,
                          child: Stack(children: [
                            Image(
                              image: _imageInComment,
                              height: 75,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _imageInComment = null;
                                    _fileImageInComment = null;
                                  });
                                },
                                child: Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    TextField(
                      autofocus: this.widget.autoFocusInput,
                      controller: inputController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.white54, fontSize: 10),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        hintText: "Write comment...",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: defaultPadding * 0.75,
                  right: defaultPadding * 0.75,
                  top: defaultPadding * 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _handleOnTapCameraIcon,
                    child: Icon(
                      CupertinoIcons.camera_fill,
                      color: Colors.white54,
                      size: 30,
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: _postComment,
                      child: Container(
                        decoration: BoxDecoration(
                            color: inputController.text.length > 0
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "Post",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
