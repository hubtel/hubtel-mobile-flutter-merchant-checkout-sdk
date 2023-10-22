import 'package:flutter/material.dart';


EdgeInsets symmetricPad({
  double? vertical,
  double? horizontal,
}) {
  return EdgeInsets.symmetric(
    vertical: vertical ?? 0.0,
    horizontal: horizontal ?? 0.0,
  );
}

EdgeInsets fromLTRB({
  double? left,
  double? right,
  double? bottom,
  double? top,
}) {
  return EdgeInsets.fromLTRB(
    left ?? 0.0,
    top ?? 0.0,
    right ?? 0.0,
    bottom ?? 0.0,
  );
}

EdgeInsets onlySidePad({
  double? left,
  double? right,
  double? bottom,
  double? top,
}) {
  return EdgeInsets.only(
    left: left ?? 0.0,
    top: top ?? 0.0,
    right: right ?? 0.0,
    bottom: bottom ?? 0.0,
  );
}
