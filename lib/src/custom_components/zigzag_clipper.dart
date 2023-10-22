
import 'package:flutter/material.dart';

class ZigzagClipper extends CustomClipper<Path> {
  final double lineCount;
  final double lineHeight;

  ZigzagClipper({this.lineCount = 40, this.lineHeight = 10});

  @override
  Path getClip(Size size) {
    var smallLineLength = size.width / lineCount;
    var path = Path();

    path.lineTo(0, size.height);
    for (int i = 1; i <= lineCount; i++) {
      if (i % 2 == 0) {
        path.lineTo(smallLineLength * i, size.height);
      } else {
        path.lineTo(smallLineLength * i, size.height - lineHeight);
      }
    }
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}