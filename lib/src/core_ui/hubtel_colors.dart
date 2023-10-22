import 'package:flutter/material.dart';

import 'hubtel_color.dart';

final class HubtelColors {
  ///Brand Colors
  static const Color brandColorBlue = Color(0xFF082E4D);

  static Color brandColorOrange = const Color(0xFFF7961C);

  static Color brandColorTeal = const Color(0xFF009E96);

  static Color primaryColor = brandColorTeal;

  static Color brandColorRed = const Color(0xFFEF4923);

  ///Secondary Colors
  static Color yaleBlue = const Color(0xFF0E479D);

  static Color saffron = const Color(0xFFFECC2F);

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF000000);

  static const Color greyColor = Color(0xFFAAAAAA);

  static const Color lighterGrey = Color(0xFFEEEEF0);

  static Color tiffanyBlue = const Color(0xFF01C7B1);

  static Color crimson = const Color(0xFFED1B2E);

  static Color oceanBlue = const Color(0xFF4645AB);

  static Color caribbeanGreen = const Color(0xFF00CC8E);

  ///Neutral Colors
  static const _neutralPrimaryValue = 0xFFD2D6D9;

  static const HubtelColor neutral = HubtelColor(
    _neutralPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFF8F9FB),
      300: Color(0xFFF2F2F2),
      400: Color(0xFFE6EAED),
      500: Color(_neutralPrimaryValue),
      600: Color(0xFF9CABB8),
      700: Color(0xFF2E2E2E),
      800: Color(0xFF030F1A),
      900: Color(0xFF000000)
    },
  );

  ///Red
  static const _redPrimaryValue = 0xED1B2E;

  static const HubtelColor red = HubtelColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xFFFEF1F2),
      100: Color(0xFFFFD7D5),
      200: Color(0xFFFFB0AC),
      300: Color(0xFFFF8983),
      400: Color(0xFFFF625A),
      500: Color(_redPrimaryValue),
      600: Color(0xFFCC2F26),
      700: Color(0xFFB22922),
      800: Color(0xFF99231D),
      900: Color(0xFF801D18)
    },
  );

  ///Yellow
  static const _yellowPrimaryValue = 0xFFFECC2F;

  static const HubtelColor yellow = HubtelColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFAEE),
      100: Color(0xFFFFF4CC),
      200: Color(0xFFFFEA99),
      300: Color(0xFFFFE066),
      400: Color(0xFFFFD633),
      500: Color(_yellowPrimaryValue),
      600: Color(0xFFCCA300),
      700: Color(0xFFB28F00),
      800: Color(0xFF997B00),
      900: Color(0xFF806600)
    },
  );

  ///Teal
  static const _tealPrimaryValue = 0xFF01C7B1;

  static const HubtelColor teal = HubtelColor(
    _tealPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFAEE),
      100: Color(0xFFCCF3EF),
      200: Color(0xFF99E8DF),
      300: Color(0xFF67DDD0),
      400: Color(0xFF34D2C0),
      500: Color(_tealPrimaryValue),
      600: Color(0xFF34D2C0),
      700: Color(0xFF018B7C),
      800: Color(0xFF018B7C),
      900: Color(0xFF015E53)
    },
  );

  ///Blue
  static const _bluePrimaryValue = 0xFF007AFF;

  static const HubtelColor blue = HubtelColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE9F3FF),
      100: Color(0xFFCCE4FF),
      200: Color(0xFF99CAFF),
      300: Color(0xFF66AFFF),
      400: Color(0xFF3395FF),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF0062CC),
      700: Color(0xFF0055B2),
      800: Color(0xFF0E479D),
      900: Color(0xFF063D80)
    },
  );

  ///Cyan
  static const _cyanPrimaryValue = 0xFF5AC8FA;

  static const HubtelColor cyan = HubtelColor(
    _cyanPrimaryValue,
    <int, Color>{
      50: Color(0xFFF0FAFF),
      100: Color(0xFFDEF4FE),
      200: Color(0xFFBDE9FD),
      300: Color(0xFF9CDEFC),
      400: Color(0xFF7BD3FB),
      500: Color(_cyanPrimaryValue),
      600: Color(0xFF48A0C8),
      700: Color(0xFF3F8CAF),
      800: Color(0xFF367896),
      900: Color(0xFF244F63)
    },
  );

  ///Purple
  static const _purplePrimaryValue = 0xFF5856D6;

  static const HubtelColor purple = HubtelColor(
    _purplePrimaryValue,
    <int, Color>{
      50: Color(0xFFECEFFD),
      100: Color(0xFFDDDDF6),
      200: Color(0xFFBCBBEE),
      300: Color(0xFF9B99E6),
      400: Color(0xFF7978DE),
      500: Color(_purplePrimaryValue),
      600: Color(0xFF4645AB),
      700: Color(0xFF3E3C96),
      800: Color(0xFF353481),
      900: Color(0xFF14134D)
    },
  );

  ///Pink
  static const _pinkPrimaryValue = 0xFFFF2D55;

  static const HubtelColor pink = HubtelColor(
    _pinkPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFEDED),
      100: Color(0xFFFFD5DD),
      200: Color(0xFFFFABBB),
      300: Color(0xFFFF8199),
      400: Color(0xFFFF5777),
      500: Color(_pinkPrimaryValue),
      600: Color(0xFFCC2444),
      700: Color(0xFFB21F3B),
      800: Color(0xFF991B33),
      900: Color(0xFF80172A)
    },
  );

  ///Orange
  static const _orangePrimaryValue = 0xFFF7961C;

  static const HubtelColor orange = HubtelColor(
    _orangePrimaryValue,
    <int, Color>{
      50: Color(0xFFFFF5EC),
      100: Color(0xFFFFE9CC),
      200: Color(0xFFFFD499),
      300: Color(0xFFFFBF66),
      400: Color(0xFFFFAA33),
      500: Color(_orangePrimaryValue),
      600: Color(0xFFCC7700),
      700: Color(0xFFB76B00),
      800: Color(0xFF995A00),
      900: Color(0xFF80500D)
    },
  );

  static const _springGreenPrimaryValue = 0xFF00FFB1;

  static const HubtelColor springGreen = HubtelColor(
    _springGreenPrimaryValue,
    <int, Color>{
      50: Color(0xFFF0FFFA),
      100: Color(0xFFCCFFEF),
      200: Color(0xFF99FFDF),
      300: Color(0xFF66FFD0),
      400: Color(0xFF33FFC0),
      500: Color(_springGreenPrimaryValue),
      600: Color(0xFF00CC8E),
      700: Color(0xFF00B27C),
      800: Color(0xFF00996A),
      900: Color(0xFF008059)
    },
  );

  static const _greyPrimaryValue = 0xFF9CABB8;

  static const HubtelColor grey = HubtelColor(
    _greyPrimaryValue,
    <int, Color>{
      100: Color(0xFFF2F2F2),
      200: Color(0xFFF8F9FB),
      300: Color(0xFFE6EAED),
      400: Color(0xFFB1B1B1),
      500: Color(_greyPrimaryValue),
      600: Color(0xFFB4B4B4),
      700: Color(0xFF6C737F),
      800: Color(0xFFF8F8F8),
      900: Color(0xFFF5F5F5)
    },
  );

  static const greyShadeDeep = Color(0xFFE6EAEC);
  static const greyBackground = Color(0xFFFAFAFA);
  static const greyHint = Color(0xFFb3bac1);
  static const errorColor = Color(0xFFFF3344);
  static const logoutTextColor = Color(0xFFFF3B30);
}
