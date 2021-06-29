import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Comment.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/CommentDetailScreen.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/Components/CommentTile.dart';
import 'package:flutter_application_1/Screens/DetailPostScreen/Components/SortComment.dart';
import 'package:flutter_application_1/constant.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class DetailPostScreen extends StatefulWidget {
  DetailPostScreen({
    Key key,
    this.postUI,
  }) : super(key: key);

  final PostUI postUI;

  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  String _currentCommentType = "Hot comment";

  Comment _comment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _comment = Comment();
    _comment.createdDate = DateTime.now();
    _comment.content = "Wow man, best meme, thank you";
    _comment.owner = "basa";
    _comment.id = "cauicb1265";

    buildScreen();

    inputController.addListener(_handleInputCommentChange);
  }

  ImageProvider _imageInComment;
  File _fileImageInComment;
  TextEditingController inputController = TextEditingController();
  List<Widget> _allComment = [];
  List<Widget> _mainScreenComponent = [];

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

class ChooseImageTypeModel extends StatefulWidget {
  ChooseImageTypeModel({
    Key key,
    @required this.onChooseImage,
  }) : super(key: key);

  final Function(File imageProvider) onChooseImage;
  @override
  _ChooseImageTypeModelState createState() => _ChooseImageTypeModelState();
}

class _ChooseImageTypeModelState extends State<ChooseImageTypeModel> {
  final _imagePicker = ImagePicker();

  void _fromLibrary() async {
    final image = await _imagePicker.getImage(source: ImageSource.gallery);

    print(image);
    if (image != null) {
      this.widget.onChooseImage(File(image.path));
    }
  }

  void _takeAPhoto() async {
    final image = await _imagePicker.getImage(source: ImageSource.camera);

    print(image);
    if (image != null) {
      this.widget.onChooseImage(File(image.path));
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
