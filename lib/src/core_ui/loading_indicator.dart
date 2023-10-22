
import 'package:flutter/material.dart';
import 'core_ui.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? loaderColor;
  final double strokeWidth;

  const LoadingIndicator({
    Key? key,
    this.loaderColor,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: strokeWidth,
      color: loaderColor ?? HubtelColors.teal.shade500,
    );
  }
}

class PageLoadingIndicator extends StatelessWidget {
  final Color? loaderColor;
  final double strokeWidth;

  const PageLoadingIndicator({
    Key? key,
    this.loaderColor,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HubtelColors.white,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: loaderColor ?? HubtelColors.teal.shade500,
        ),
      ),
    );
  }
}
