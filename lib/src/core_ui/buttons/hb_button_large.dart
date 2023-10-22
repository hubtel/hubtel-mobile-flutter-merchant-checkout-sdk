import 'package:flutter/material.dart';

import '../core_ui.dart';

class HBPlainTextButtonLarge extends StatefulWidget {
  String title;

  Color enabledTextColor;

  Color disabledTextColor;

  VoidCallback? buttonAction;

  bool isEnabled;

  double? buttonPaddings;
  double? fontSize;

  HBPlainTextButtonLarge({
    Key? key,
    required this.title,
    required this.enabledTextColor,
    required this.disabledTextColor,
    required this.buttonAction,
    this.isEnabled = true,
    this.buttonPaddings,
    this.fontSize,
  }) : super(key: key);

  @override
  State<HBPlainTextButtonLarge> createState() => _HBPlainTextButtonLargeState();

  factory HBPlainTextButtonLarge.createCustomButton({
    required String title,
    required VoidCallback? buttonAction,
    double? padding,
    double? fontSize,
    double? width,
    Color? color,
  }) {
    return HBPlainTextButtonLarge(
      title: title,
      enabledTextColor: color ?? HubtelColors.teal,
      disabledTextColor: HubtelColors.neutral.shade300,
      buttonAction: buttonAction,
      buttonPaddings: padding,
      fontSize: fontSize,
    );
  }

  factory HBPlainTextButtonLarge.createTealButton({
    required String title,
    required VoidCallback? buttonAction,
    double? padding,
    double? fontSize,
    double? width,
  }) {
    return HBPlainTextButtonLarge(
      title: title,
      enabledTextColor: HubtelColors.teal,
      disabledTextColor: HubtelColors.neutral.shade300,
      buttonAction: buttonAction,
      buttonPaddings: padding,
      fontSize: fontSize,
    );
  }

  factory HBPlainTextButtonLarge.createCrimsonButton({
    required String title,
    required VoidCallback? buttonAction,
    double? padding,
    double? fontSize,
    double? width,
  }) {
    return HBPlainTextButtonLarge(
      title: title,
      enabledTextColor: HubtelColors.crimson,
      disabledTextColor: HubtelColors.neutral.shade300,
      buttonAction: buttonAction,
      buttonPaddings: padding,
      fontSize: fontSize,
    );
  }
}

class _HBPlainTextButtonLargeState extends State<HBPlainTextButtonLarge> {
  @override
  Widget build(BuildContext context) {
    final enabledColor =
        widget.isEnabled ? widget.enabledTextColor : widget.disabledTextColor;

    return Padding(
      padding: EdgeInsets.all(widget.buttonPaddings ?? 16.0),
      child: TextButton(
        onPressed: widget.isEnabled ? widget.buttonAction : null,
        child: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize ?? 16,
            color: enabledColor,
          ),
        ),
      ),
    );
  }
}
