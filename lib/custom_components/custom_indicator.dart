

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_checkout_sdk/core_ui/dimensions.dart';
import 'package:unified_checkout_sdk/core_ui/hubtel_colors.dart';
import 'package:unified_checkout_sdk/core_ui/text_style.dart';

class CustomRadioIndicator extends StatelessWidget {
  const CustomRadioIndicator({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.iconMid,
      height: Dimens.iconMid,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: ThemeConfig.themeColor, width: isSelected ? 6 : 2),
        color: isSelected ? ThemeConfig.themeColor : HubtelColors.neutral,
      ),
      child: Center(
        child: Container(
          // width: 11,
          // height: 11,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HubtelColors.neutral.shade50,
          ),
        ),
      ),
    );
  }
}