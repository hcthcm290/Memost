import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CustomWidgets/ListPost.dart';
import 'package:flutter_application_1/Model/Post.dart';
import 'package:flutter_application_1/constant.dart';

class TagListPostScreen extends StatefulWidget {
  const TagListPostScreen({Key key, @required this.tagName}) : super(key: key);

  final String tagName;

  @override
  _TagListPostScreenState createState() => _TagListPostScreenState();
}

class _TagListPostScreenState extends State<TagListPostScreen> {
  List<PostUI> _listPost = [];
  bool hasMore = true;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initListPost();
  }

  void initListPost() {
    if (loading == true) return;
    loading = true;
    // Todo: init list post with 15-20 post

    Post post = Post();
    post.owner = "Basa102";
    post.title = "The funniest meme i have ever seen";
    post.image =
        "https://preview.redd.it/lwf895ptel571.png?width=960&crop=smart&auto=webp&s=f11838f1f6f95ae4da8fe9e1196396c6b15e0074";

    for (int i = 0; i < 5; i++) {
      _listPost.add(PostUI(
        post: post,
      ));
    }

    loading = false;
    setState(() {});
  }

  void getMorePost() async {
    if (loading == true) return;
    loading = true;
    // Todo: add more post to list post

    await Future.delayed(Duration(seconds: 2));

    Post post = Post();
    post.owner = "Basa102";
    post.title = "The funniest meme i have ever seen";
    post.image =
        "https://preview.redd.it/lwf895ptel571.png?width=960&crop=smart&auto=webp&s=f11838f1f6f95ae4da8fe9e1196396c6b15e0074";

    for (int i = 0; i < 3; i++) {
      if (_listPost.length > 10) {
        setState(() {
          hasMore = false;
        });
        return;
      }
      _listPost.add(PostUI(
        post: post,
      ));
    }

    setState(() {});

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text("${widget.tagName}"),
      // ),

      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          floating: true,
          title: Text("${widget.tagName}"),
          shadowColor: Color.fromARGB(255, 200, 200, 200),
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            final maxScroll = scrollNotification.metrics.maxScrollExtent;
            final currentScroll = scrollNotification.metrics.pixels;

            if (maxScroll == currentScroll) {
              getMorePost();
            }
          },
          child: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == _listPost.length && hasMore) {
                return ListTile(
                  title: CupertinoActivityIndicator(
                    radius: defaultPadding,
                  ),
                );
              } else if (index < _listPost.length) {
                return _listPost[index];
              }
              if (index > _listPost.length) {
                getMorePost();
              }
            }),
          ),
        ),
      ]),
    );
  }
}
