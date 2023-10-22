import 'dart:io';


import 'package:flutter/material.dart';
import 'core_ui.dart';

class PageDecoration {
  Color backgroundColor;

  PageDecoration({this.backgroundColor = HubtelColors.white});
}

typedef OnBackPressed = Function();

class AppPage extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigation;
  final OnBackPressed? onBackPressed;
  final PageDecoration? pageDecoration;
  final List<Widget>? actions;
  final double? elevation;
  final String? title;
  final String? imageUrl;
  final bool? withImage;
  final bool? hideBackNavigation;
  final TextStyle? titleStyle;
  final PreferredSizeWidget? bottom;
  final Color? appBarBackgroundColor;

  const AppPage({
    required this.body,
    this.bottomNavigation,
    this.pageDecoration,
    this.onBackPressed,
    this.actions,
    Key? key,
    this.elevation,
    this.title,
    this.titleStyle,
    this.imageUrl,
    this.withImage,
    this.hideBackNavigation,
    this.bottom,
    this.appBarBackgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appBarBackgroundColor ?? Colors.white,
      elevation: elevation ?? 0.5,
      centerTitle: true,
      leading: hideBackNavigation == true ? null : back(context),
      title: Text(title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle ??
              AppTextStyle.headline3().copyWith(
                fontWeight: FontWeight.w700,
              )),
      bottom: bottom,
      actions: actions ?? [],
    );

    var _bottomNavigation = bottomNavigation;

    if (bottomNavigation == null) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          int sensitivity = 28;
          if (details.delta.dx > sensitivity) {
            // Right Swipe
            if (Platform.isIOS) {
              Navigator.of(context).pop();
            }
          } else if (details.delta.dx < -sensitivity) {
            //Left Swipe
          }
        },
        child: Scaffold(
          backgroundColor:
          pageDecoration?.backgroundColor ?? HubtelColors.white,
          appBar: _appBar,
          body: SafeArea(child: body),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        int sensitivity = 28;
        if (details.delta.dx > sensitivity) {
          // Right Swipe
          if (Platform.isIOS) {
            Navigator.of(context).pop();
          }
        } else if (details.delta.dx < -sensitivity) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: pageDecoration?.backgroundColor ?? HubtelColors.white,
        appBar: _appBar,
        body: SafeArea(
          child: body,
        ),
        bottomNavigationBar: _bottomNavigation,
      ),
    );
  }

  Widget back(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: Dimens.zero),
        child: InkResponse(
          onTap: () {
            if (onBackPressed != null) {
              onBackPressed?.call();
            } else {
              Navigator.pop(context);
            } //Navigation.openHelp(context: context);
          },
          child: const Icon(
            Icons.chevron_left,
            size: Dimens.iconMediumLarge,
            color: HubtelColors.black,
          ),
        ));
  }
}

class GetTitle extends StatelessWidget {
  final bool? horizontalPadding;
  final String? title;
  final String? imageUrl;
  final bool? withImage;

  const GetTitle(
      {Key? key,
        this.horizontalPadding,
        this.title,
        this.imageUrl,
        this.withImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title ?? '',
        style: const TextStyle(
          color: HubtelColors.black,
          fontWeight: FontWeight.normal,
          fontSize: Dimens.h2,
        ));
  }
}
