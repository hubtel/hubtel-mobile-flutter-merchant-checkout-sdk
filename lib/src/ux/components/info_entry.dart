import 'package:flutter/material.dart';
import '../../core_ui/core_ui.dart';
import '../../resources/resources.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key,
      required this.label,
      this.labelColor = CheckoutColors.cardLabelColor,
      required this.value,
      this.valueStyle});

  final String label;
  final Color labelColor;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.body2(),
        ),
        const Padding(padding: EdgeInsets.only(bottom: Dimens.paddingNano)),
        Text(
          value,
          style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
