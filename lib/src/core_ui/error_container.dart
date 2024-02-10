
import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/resources/checkout_strings.dart';

class ErrorContainer extends StatelessWidget {
  final String message;
  final MainAxisSize axisSize;


  const ErrorContainer(
      {Key? key, required this.message, this.axisSize = MainAxisSize.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(Dimens.paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: axisSize,
          children: [
            Container(
              height: Dimens.fifty,
              width: Dimens.fifty,
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.paddingSmall,
              ),
              margin: const EdgeInsets.only(
                top: Dimens.paddingDefault,
              ),
              decoration: BoxDecoration(
                color: HubtelColors.dialogIconColor,
                borderRadius: BorderRadius.circular(Dimens.fifty),
              ),
              child: Column(
                //Exclamation
                children: [
                  Expanded(
                    child: Container(
                      width: Dimens.paddingMicro,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimens.lgBorderRadius),
                        color: HubtelColors.crimson,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: Dimens.paddingMicro,
                  ),
                  Container(
                    height: Dimens.paddingMicro,
                    width: Dimens.paddingMicro,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimens.paddingMicro / 2),
                      color: HubtelColors.crimson,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Dimens.paddingDefault,
            ),
            Text(
              CheckoutStrings.errorText,
              style: AppTextStyle.headline4(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Dimens.paddingDefaultSmall,
            ),
            Text(
              message,
              style: AppTextStyle.body2(),
              textAlign: TextAlign.center,
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: Dimens.paddingDefault),
            //   child: const Divider(),
            // ),
            const SizedBox(
              height: Dimens.paddingDefault,
            ),

            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimens.paddingDefault),
                child: Text(
                  CheckoutStrings.okay,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ThemeConfig.themeColor,
                  ),
                ),
              ),

            )
          ],
        ));
  }
}