
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'core_ui.dart';

class AppImageWidget extends StatelessWidget {
  String? imageUrl;
  File? file;
  AssetImage? image;
  AssetImage? placeHolder;
  AssetImage? errorImage;
  double width;
  double height;
  double? borderRadius;
  BoxFit? boxFit;

  AppImageWidget({
    Key? key,
    required this.imageUrl,
    required this.placeHolder,
    required this.errorImage,
    this.borderRadius,
    this.width = Dimens.lgIconSize,
    this.height = Dimens.lgIconSize,
    this.boxFit,
  }) : super(key: key);

  AppImageWidget.local({
    Key? key,
    required this.image,
    this.width = Dimens.lgIconSize,
    this.height = Dimens.lgIconSize,
    this.borderRadius,
    this.boxFit,
  }) : super(key: key);

  AppImageWidget.file(
      {Key? key,
        required this.file,
        this.width = Dimens.lgIconSize,
        this.height = Dimens.lgIconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          child: Image(
            image: image ?? const AssetImage("assetName"),
            width: width,
            height: height,
            fit: boxFit,
            errorBuilder: (context, o, s) {
              return Container(
                color: HubtelColors.neutral,
                width: width,
                height: height,
              );
            },
          ));
    }

    if (file != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            file ?? File(""),
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, o, s) {
              return Container(
                color: HubtelColors.neutral,
                width: width,
                height: height,
              );
            },
          ));
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        child: imageUrl?.isNotEmpty == true
            ? CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            width: width,
            height: height,
            fit: boxFit ?? BoxFit.cover,
            errorWidget: (context, o, s) {
              return Image(
                image: errorImage ?? AssetImage(""),
                width: width,
                height: height,
              );
            })
        // FadeInImage.assetNetwork(
        //         placeholder: placeHolder?.assetName ?? "",
        //         image: imageUrl!,
        //         width: width,
        //         height: height,
        //         imageErrorBuilder: (context, o, s) {
        //           return Image(
        //             image: errorImage ?? AppImages.appLogo,
        //             width: width,
        //             height: height,
        //           );
        //         },
        //       )
            : Image(
          image: errorImage ?? AssetImage(""),
          width: width,
          height: height,
        ));
  }
}
