import 'package:flutter/material.dart';

class InfoWidgets extends StatelessWidget {
  final String title;
  final String data;
  final Color color;

  InfoWidgets({this.title, this.data, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        Text(
          data,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
