


import 'package:flutter/material.dart';
import '../core_ui.dart';

class HBRoundedDialog extends StatelessWidget {

  double? borderRadius;

  Widget widget;

  EdgeInsetsGeometry? padding;

  HBRoundedDialog({
    Key? key,
    required this.widget,
    this.borderRadius,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 16)),
      // backgroundColor: Colors.yellow,
      child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: widget
      ),
    );
  }
}