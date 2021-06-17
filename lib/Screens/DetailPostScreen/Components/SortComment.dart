import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constant.dart';

class SortComment extends StatelessWidget {
  const SortComment({
    Key key,
    @required String currentCommentType,
  })  : _currentCommentType = currentCommentType,
        super(key: key);

  final String _currentCommentType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: defaultPadding * 0.5, horizontal: defaultPadding),
      child: Row(
        children: [
          Text(
            _currentCommentType,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white54),
          ),
          Padding(
            padding: EdgeInsets.only(left: defaultPadding * 0.25, top: 5),
            child: Icon(
              CupertinoIcons.arrowtriangle_down_fill,
              size: 12,
              color: Colors.white54,
            ),
          )
        ],
      ),
    );
  }
}
