import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Comment.dart';
import 'package:flutter_application_1/Model/UserModel.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/CommentDetailScreen.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/Components/CommentTile.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/Components/SortComment.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/DetailPostScreen.dart';
import 'package:flutter_application_1/Screens/UserInfoScreen/Components/PostCommentUI.dart';
import 'package:flutter_application_1/constant.dart';

// Similar to PostDetailScreen but move the user's comment tile to the top
class UserPostCommentDetailScreen extends StatefulWidget {
  UserPostCommentDetailScreen({
    Key key,
    this.postUI,
    this.focusCommentID,
    this.userModel,
  }) : super(key: key);

  final PostCommentUI postUI;
  final UserModel userModel;

  //
  final String focusCommentID;
  @override
  _UserCommentDetailScreenState createState() =>
      _UserCommentDetailScreenState();
}

class _UserCommentDetailScreenState extends State<UserPostCommentDetailScreen> {
  String _currentCommentType = "Hot comment";

  Comment _comment;

  List<Widget> _allComment = [];
  List<Widget> _mainScreenComponent = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildScreen();
    inputController.addListener(_handleInputCommentChange);
  }

  Future<void> loadAllComment() async {
    // Todo:
    // load all comment of the post,
    // remember to bring the comment of this.widget.userModel to front

    _comment = Comment();
    _comment.createdDate = DateTime.now();
    _comment.content = "Wow man, best meme, thank you";
    _comment.owner = "basa";
    _comment.id = "cauicb1265";

    _allComment.add(CommentTile(
      comment: _comment,
      numberOfReplies: 2,
      onReplyClicked: onTapReply,
    ));
    _allComment.add(CommentTile(
      comment: _comment,
      numberOfReplies: 2,
      onReplyClicked: onTapReply,
    ));
    _allComment.add(CommentTile(
      comment: _comment,
      numberOfReplies: 2,
      onReplyClicked: onTapReply,
    ));
    _allComment.add(CommentTile(
      comment: _comment,
      numberOfReplies: 2,
      onReplyClicked: onTapReply,
    ));
  }

  ImageProvider _imageInComment;
  File _fileImageInComment;
  TextEditingController inputController = TextEditingController();

  void _handleInputCommentChange() {
    // only update ui when input controller change from no text to text to save performance
    if (inputController.text.length < 2) {
      setState(() {});
    }
  }

  void _onTapChangeCommentType() {}

  void _postComment() {}

  void _handleOnTapCameraIcon() {
    showModalBottomSheet(
        context: context,
        builder: (context) => ChooseImageTypeModel(
              onChooseImage: (image) {
                setState(() {
                  _fileImageInComment = image;
                  _imageInComment = Image.file(image).image;
                });
                Navigator.pop(context);
              },
            ));
  }

  void onTapReply(Comment comment) {
    print("move to comment detail");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentDetailScreen(
                  comment: comment,
                  autoFocusInput: true,
                )));
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
            mainAxisSize: MainAxisSize.min,
            children: [Text("Post")]),
      ),
      body: Stack(children: [
        ListView.builder(
          itemBuilder: (context, index) {
            if (index < _mainScreenComponent.length) {
              return _mainScreenComponent[index];
            }
          },
        ),
        // Bottom comment input field
        buildBottomCommentInput(context),
      ]),
    );
  }

  Future<void> buildScreen() async {
    List<Widget> screenWidget = [
      this.widget.postUI,
      GestureDetector(
          onTap: _onTapChangeCommentType,
          child: SortComment(currentCommentType: _currentCommentType)),
    ];

    setState(() {
      _mainScreenComponent = screenWidget;
    });

    await loadAllComment();
    for (int i = 0; i < _allComment.length; i++) {
      screenWidget.add(_allComment[i]);
      screenWidget.add(Divider(
        height: 1,
        thickness: 1,
      ));
    }

    screenWidget.add(Container(
      height: 150,
      color: Colors.black,
    ));

    setState(() {
      _mainScreenComponent = screenWidget;
    });
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
