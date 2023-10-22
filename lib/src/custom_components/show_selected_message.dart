import 'package:flutter/material.dart';
import '../core_ui/core_ui.dart';
import '../platform/models/models.dart';
import '../resources/checkout_strings.dart';

Widget showSelectedProviderMessage({required MomoProvider selectedProvider}) {
  switch (selectedProvider.name) {
    case CheckoutStrings.mtnMobileMoney:
      return AppRichText(
        text: CheckoutStrings.paymentWithMomoInfoHead,
        fontSize: Dimens.body2,
        maxLines: 8,
        otherTexts: [
          TextSpan(
            text: CheckoutStrings.mtnMomoShortCode,
            style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: CheckoutStrings.paymentWithMomoInfoTail,
              style: AppTextStyle.body2()
          ),
        ],
      );
    case CheckoutStrings.vodafoneCash:
      return const SizedBox();
    case CheckoutStrings.airtelTigoMoney:
      return const SizedBox();
    default:
      return const SizedBox();
  }
}