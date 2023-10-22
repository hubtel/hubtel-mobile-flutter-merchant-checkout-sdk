
import 'package:flutter/material.dart';
import '../core_ui.dart';

extension WidgetExtensions on StatefulWidget {
  showLoadingDialog({required BuildContext context, required String text}) {
    loadingDialog(context, loadingText: text);
  }
}