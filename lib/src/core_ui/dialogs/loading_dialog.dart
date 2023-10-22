import 'package:flutter/material.dart';
import '../core_ui.dart';

loadingDialog(BuildContext context, {String? loadingText}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 40,
            child: LoadingIndicator(
              loaderColor: ThemeConfig.themeColor,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            loadingText ?? 'Loading...',
            style: AppTextStyle.body2(),
          ),
        ],
      ),
    ),
  );
}
