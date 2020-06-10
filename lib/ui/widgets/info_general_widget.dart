import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CardInfoGeneralWidgets extends StatelessWidget {
  final String title;
  final String avatar;
  final FutureBuilder info;
  final String image;

  CardInfoGeneralWidgets({this.title, this.avatar, this.info, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
        avatar != 'assets/world.png'
            ? CircleAvatar(
                radius: 50.0,
                child: ClipOval(
                  child: Flag(
                    avatar,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50.0,
                child: ClipOval(
                  child: Image.asset(
                    avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: info,
        ),
      ],
    );
  }
}
