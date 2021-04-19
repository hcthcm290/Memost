
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {

  File _image;
  final picker = ImagePicker();

  @override 
  bool get wantKeepAlive => true;

  Future getImg() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null)
        _image = File(pickedFile.path);
      else
        print('no image picked'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Selecter'),
      ),
      body: Container(
        child: _image == null 
            ? Text("No image selected")
            : Image.file(_image, width: 500, height: 500, fit: BoxFit.fill,)
        ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImg,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}