
import 'package:flutter/material.dart';

class CContainer extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final BoxBorder? border;
  final BoxShape? shape;
  final double? width;
  final double? height;
  final DecorationImage? image;

  const CContainer({
    Key? key,
    this.borderRadius,
    this.color,
    this.padding,
    this.margin,
    this.child,
    this.border,
    this.shape,
    this.width,
    this.height,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color,
        border: border,
        shape: shape ?? BoxShape.rectangle,
        image: image,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: child,
    );
  }
}