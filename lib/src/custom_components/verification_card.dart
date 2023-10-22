import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core_ui/core_ui.dart';
import '../resources/checkout_drawables.dart';
import '../resources/checkout_strings.dart';

class VerificationCard extends StatelessWidget {
  const VerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Column(
        children: [
          // Image.asset(CheckoutDrawables.verificationSuccess),
          SvgPicture.asset(CheckoutDrawables.verificationSuccessSvg),
          Padding(
            padding: const EdgeInsets.only(
              top: Dimens.paddingSmall,
              bottom: Dimens.paddingSmall,
            ),
            child: Text(
              CheckoutStrings.verificationSuccess,
              textAlign: TextAlign.center,
              style: AppTextStyle.headline4()
            ),
          )
        ],
      ),
    );
  }
}
