import 'package:flutter/material.dart';

import '../core_ui.dart';

class HBPromptDialog extends StatelessWidget {
  String title;
  String subtitle;
  String buttonTitle;
  VoidCallback? buttonAction;

  HBPromptDialog(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.buttonTitle,
      required this.buttonAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HBRoundedDialog(
      padding: const EdgeInsets.all(Dimens.paddingDefault),
      borderRadius: Dimens.defaultBorderRadius,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyle.headline3(),
          ),
          const SizedBox(
            height: 8,
          ),
          Align(alignment: Alignment.center, child: Text(subtitle)),
          const SizedBox(
            height: 8,
          ),
          HBPlainTextButtonLarge.createCustomButton(
            title: buttonTitle,
            buttonAction: buttonAction,
            padding: 0,
            color: ThemeConfig.themeColor,
          )
        ],
      ),
    );
  }
}
