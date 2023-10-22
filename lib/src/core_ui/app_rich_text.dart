import 'package:flutter/cupertino.dart';

import 'core_ui.dart';

class AppRichText extends StatelessWidget {
  const AppRichText({
    Key? key,
    required this.text,
    this.otherTexts,
    this.height,
    this.maxLines,
    this.color,
    this.fontWeight,
    this.textOverflow = TextOverflow.ellipsis,
    this.fontSize,
    this.textAlign = TextAlign.start,
    this.textScaleFactor,
  }) : super(key: key);

  final String text;
  final double? height;
  final double? textScaleFactor;
  final List<InlineSpan>? otherTexts;
  final int? maxLines;
  final TextOverflow textOverflow;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      textScaleFactor: textScaleFactor ?? 1.0,
      text: TextSpan(
        text: text,
        style: AppTextStyle.body1().copyWith(
          fontSize: fontSize ?? Dimens.body1,
          height: height,
          color: color ?? HubtelColors.neutral.shade900,
          fontWeight: fontWeight,
          // fontFamily: AppTheme.appFontFamilyName,
        ),
        children: otherTexts,
      ),
    );
  }
}