import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unified_checkout_sdk/core_ui/text_style.dart';
import '../../core_ui/dimensions.dart';
import '../../resources/checkout_colors.dart';
import '../../resources/checkout_drawables.dart';
import '../../resources/checkout_strings.dart';
import '../../resources/fonts.dart';

class VerificationCard extends StatelessWidget {
  const VerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Column(
        children: [
          // Image.asset(CheckoutDrawables.verificationSuccess),
          SvgPicture.asset(CheckoutDrawables.success),
          Padding(
            padding: const EdgeInsets.only(
              top: Dimens.paddingSmall,
              bottom: Dimens.paddingSmall,
            ),
            child: Text(
              CheckoutStrings.verificationSuccess,
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   fontFamily: CheckoutFonts.nunitoSans,
              //   package: CheckoutStrings.package,
              //   fontStyle: FontStyle.normal,
              //   fontSize: Dimens.font16sp,
              //   fontWeight: FontWeight.w800,
              //   color: CheckoutColors.defaultBlackColor,
              // ),
              style: AppTextStyle.headline4()
            ),
          )
        ],
      ),
    );
  }
}
