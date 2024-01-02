
import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/resources/checkout_colors.dart';
import 'package:hubtel_merchant_checkout_sdk/src/utils/currency_formatter.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/repayment_schedule_table.dart';

class AmountDisplayComponent extends StatelessWidget {
  final String faintText;
  final double amount;
  final bool showBottomLine;
  final bool grayOutText;
  final AmountType type;

  const AmountDisplayComponent({Key? key, required this.faintText, required this.amount, this.showBottomLine = false, this.grayOutText = false, this.type = AmountType.paymentAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(faintText, style: AppTextStyle.body2().copyWith(fontWeight: grayOutText ? FontWeight.bold : FontWeight.normal ,color: grayOutText ? CheckoutColors.lightGreyTextBackground : Colors.black),),
            Text(type == AmountType.interestRate ? "$amount%" : amount.formatMoney(), style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold, color: grayOutText ? CheckoutColors.lightGreyTextBackground : Colors.black),)
          ],
        ),
        if (showBottomLine)
          const SizedBox(height: Dimens.paddingDefault,),
        if (showBottomLine)
          Container(padding: const EdgeInsets.only(top: 1),height: 1, color: CheckoutColors.lightGreyBorderColor,)
      ],
    );

  }
}
