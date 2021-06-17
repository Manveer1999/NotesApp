import 'package:flutter/material.dart';

class ColorNote extends StatelessWidget {

  final Function onPressed;
  final Color color;
  ColorNote({this.color,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle
        ),
        child: Text(''),
      ),
    );
  }
}
