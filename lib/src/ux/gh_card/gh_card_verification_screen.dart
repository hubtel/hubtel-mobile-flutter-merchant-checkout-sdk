import 'package:flutter/material.dart';

import '../../core_ui/core_ui.dart';
import '../../platform/models/models.dart';
import '../../resources/checkout_strings.dart';
import '../../custom_components/ghana_card.dart';
import '../../custom_components/verification_card.dart';

class GhanaCardVerificationScreen extends StatelessWidget {
  const GhanaCardVerificationScreen({super.key, this.verificationResponse});

  final VerificationResponse? verificationResponse;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: CheckoutStrings.titleVerification,
      bottomNavigation: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        child: CustomButton(
          title: 'Submit'.toUpperCase(),
          isEnabled: true,
          buttonAction: () => _handleSubmitButton(context),
          isDisabledBgColor: HubtelColors.lighterGrey,
          disabledTitleColor: HubtelColors.grey,
          style: HubtelButtonStyle.solid,
          isEnabledBgColor: ThemeConfig.themeColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VerificationCard(),
            GhanaCard(verificationResponse: verificationResponse),
          ],
        ),
      ),
    );
  }

  _handleSubmitButton(BuildContext context){
    Navigator.pop(context, true);
  }
}
