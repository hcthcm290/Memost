import 'package:flutter/widgets.dart';

class NullableImage extends StatefulWidget {
  NullableImage({Key key, @required this.image, @required this.placeholder})
      : super(key: key);

  final Future<ImageProvider> image;
  final Widget placeholder;

  @override
  _NullableImageState createState() => _NullableImageState();
}

class _NullableImageState extends State<NullableImage> {
  ImageProvider result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.image.then((value) => this.setState(() {
          result = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (result != null)
      return Image(
        image: result,
      );
    else
      return widget.placeholder;
  }
}
