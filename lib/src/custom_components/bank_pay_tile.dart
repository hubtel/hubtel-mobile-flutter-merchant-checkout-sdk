import 'package:flutter/material.dart';

import 'package:hubtel_merchant_checkout_sdk/src/utils/custom_expansion_widget.dart'
    as customExpansion;

import '../core_ui/core_ui.dart';
import '../resources/resources.dart';
import 'custom_components.dart';

class BankPayExpansionTile extends StatefulWidget {
  BankPayExpansionTile({
    Key? key,
    required this.controller,
    required this.onExpansionChanged,
    required this.isSelected,
  }) : super(key: key);

  final customExpansion.ExpansionTileController controller;
  final void Function(bool)? onExpansionChanged;
  final bool isSelected;

  // final double value;

  @override
  State<BankPayExpansionTile> createState() => _BankPayExpansionTileState();
}

class _BankPayExpansionTileState extends State<BankPayExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return customExpansion.ExpansionTile(
      controller: widget.controller,
      headerBackgroundColor: widget.isSelected
          ? ThemeConfig.themeColor.withOpacity(0.3)
          : Colors.transparent,
      onExpansionChanged: widget.onExpansionChanged,
      maintainState: true,
      title: Text(
        CheckoutStrings.bank_pay,
        style: AppTextStyle.body2(),
      ),
      expandedAlignment: Alignment.topLeft,
      // childrenPadding: const EdgeInsets.symmetric(
      //   horizontal: Dimens.paddingDefault,
      //   vertical: Dimens.paddingDefault,
      // ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImageWidget.local(
            image: const AssetImage(CheckoutDrawables.bankPay),
            width: Dimens.seventyFive,
            height: Dimens.seventyFive,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          )
        ],
      ),
      leading: CustomRadioIndicator(
        isSelected: widget.isSelected,
      ),
      leadingWidth: Dimens.iconMedium,
      titleAlignment: ListTileTitleAlignment.center,
    );
  }
}
