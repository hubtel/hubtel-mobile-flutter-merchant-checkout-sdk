import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    super.key,
    required this.imageProvider,
    required this.borderColor,
    required this.onTap,
    this.imageRadius = 30.0,
  });

  final double imageRadius;
  final ImageProvider imageProvider;
  final Color borderColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: imageRadius,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: imageRadius - 2,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: imageRadius - 5,
            backgroundImage: imageProvider,
          ),
        ),
      ),
    );
  }
}