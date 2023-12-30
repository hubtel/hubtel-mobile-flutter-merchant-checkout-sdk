
import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/utils/currency_formatter.dart';

class AmountDisplayComponent extends StatelessWidget {
  final String faintText;
  final double amount;
  final bool showBottomLine;

  const AmountDisplayComponent({Key? key, required this.faintText, required this.amount, this.showBottomLine = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(faintText, style: AppTextStyle.body2(),),
            Text(amount.formatMoney(), style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),)
          ],
        ),
        if (showBottomLine)
          const SizedBox(height: Dimens.paddingDefault,),
        if (showBottomLine)
          Container(padding: const EdgeInsets.only(top: 1),height: 1, color: Colors.black,)
      ],
    );

  }
}
