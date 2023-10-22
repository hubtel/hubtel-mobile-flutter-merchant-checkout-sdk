import 'package:flutter/material.dart';

import 'core_ui.dart';

const TextStyle _baseTextStyle = TextStyle(
  fontFamily: AppTextStyle.nunitoSans,
);

class AppTextStyle {
  static const nunitoSans = 'NunitoSans';

  static TextStyle headline1() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.h1,
      color: HubtelColors.black,
    );
  }

  static TextStyle headline2() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.h2,
      color: Colors.black,
    );
  }

  static TextStyle headline3() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.h3,
      color: Colors.black,
    );
  }

  static TextStyle headline4() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.h4,
      color: Colors.black,
    );
  }

  static TextStyle headline5() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.h5,
      color: Colors.black,
    );
  }

  static TextStyle headline6() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.h6,
      color: Colors.black,
    );
  }

  static TextStyle body1() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: Dimens.body1,
      color: Colors.black,
    );
  }

  static TextStyle body2() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: Dimens.body2,
      color: Colors.black,
    );
  }

  static TextStyle button() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.button,
      color: Colors.black,
    );
  }

  static TextStyle caption() {
    return _baseTextStyle.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: Dimens.caption,
      color: Colors.black,
    );
  }
}

class ThemeConfig {
  late final Color _primaryColor;

  ThemeConfig({required primaryColor}) {
    _primaryColor = primaryColor;
  }

  Color get primaryColor => _primaryColor;

  static TextTheme textTheme = TextTheme(
    /// Largest of the display styles. [headline1]
    displayLarge: AppTextStyle.headline1(),

    /// Largest of the display styles. [headline2]
    displayMedium: AppTextStyle.headline2(),

    /// Largest of the display styles. [headline3]
    displaySmall: AppTextStyle.headline3(),

    /// Largest of the display styles. [headline4]
    headlineMedium: AppTextStyle.headline4(),

    /// Largest of the display styles. [headline5]
    headlineSmall: AppTextStyle.headline5(),

    /// Largest of the display styles. [headline6]
    titleLarge: AppTextStyle.headline6(),

    bodyLarge: AppTextStyle.body1(),

    labelLarge: AppTextStyle.button(),
    bodySmall: AppTextStyle.body2(), // use for caption
  );

  static Color themeColor = HubtelColors.teal;
}
