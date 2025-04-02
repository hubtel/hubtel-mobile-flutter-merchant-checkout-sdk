import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/hubtel_merchant_checkout_sdk.dart';
import 'package:hubtel_merchant_checkout_sdk/src/utils/error_container.dart';

import '../core_ui/core_ui.dart';
import '../resources/resources.dart';

extension WidgetExtension on StatefulWidget {
  showPromptDialog({
    required BuildContext context,
    required String title,
    required String buttonTitle,
    required String subtitle,
    required VoidCallback buttonAction,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => HBPromptDialog(
        title: title,
        subtitle: subtitle,
        buttonTitle: buttonTitle,
        buttonAction: buttonAction,
      ),
    );
  }

  Future<dynamic> showCheckoutErrorDialog(
      {required BuildContext context,
        required String message,
        VoidCallback? onOkayTap}) async{
    return await showDialog(
      context: context,
      builder: (context) => HBRoundedDialog(
        padding: const EdgeInsets.all(0),
        borderRadius: Dimens.defaultBorderRadius,
        widget: SizedBox(
          // width: Dimens.xlgImageSize,
            child: ErrorContainer(message: message, axisSize: MainAxisSize.min, onOkayTap: onOkayTap,)
        ),
      ),
    );
  }

  showErrorDialog({
    required BuildContext context,
    required String message,
    VoidCallback? onOkayTap
  }) {
    showDialog(
      context: context,
      builder: (context) => HBRoundedDialog(
        padding: const EdgeInsets.all(0),
        borderRadius: Dimens.defaultBorderRadius,
        widget: SizedBox(
          width: Dimens.xlgImageSize,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimens.paddingNano,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  CheckoutStrings.errorText,
                  style: AppTextStyle.headline4(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  message,
                  style: AppTextStyle.body2(),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimens.paddingNano,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: onOkayTap ?? (){
                      final checkoutPaymentStatus = CheckoutCompletionStatus(status: UnifiedCheckoutPaymentStatus.paymentFailed, transactionId: "");
                      Navigator.pop(context);
                      Navigator.pop(context, checkoutPaymentStatus);
                    },
                    child: SizedBox(
                      width: Dimens.xlgImageSize,
                      child: Text(CheckoutStrings.okay.toUpperCase(),
                          style: AppTextStyle.body2().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showInfoDialog({
    required BuildContext context,
    required String message,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    showAppDialog(context, text: message, textColor: textColor, actions: [
      TextButton(
        onPressed: onTap ?? () => Navigator.pop(context),
        child: Text(
          "okay".toUpperCase(),
          style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}

extension HelperWigetExtension on StatelessWidget {
  showPromptDialog({
    required BuildContext context,
    required String title,
    required String buttonTitle,
    required String subtitle,
    required VoidCallback buttonAction,
  }) {
    showDialog(
      context: context,
      builder: (context) => HBPromptDialog(
        title: title,
        subtitle: subtitle,
        buttonTitle: buttonTitle,
        buttonAction: buttonAction,
      ),
    );
  }


  showErrorDialog({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => HBRoundedDialog(
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        borderRadius: Dimens.defaultBorderRadius,
        widget: SizedBox(
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error',
                style: AppTextStyle.headline3(),
              ),
              const SizedBox(
                height: Dimens.paddingNano,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  message,
                  style: AppTextStyle.body2().copyWith(
                    color: HubtelColors.errorColor,
                  ),
                ),
              ),
              const SizedBox(
                height: Dimens.paddingNano,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    CheckoutStrings.okay.toUpperCase(),
                    style: AppTextStyle.body2().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future showAppDialog(BuildContext context,
    {required String text, List<Widget>? actions, Color? textColor}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 15),
          Text(
            text,
            style: AppTextStyle.body1().copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
      actions: actions,
    ),
  );
}

Widget getErrorDialog({required String message, required BuildContext context}){
  return HBRoundedDialog(
    padding: const EdgeInsets.all(0),
    borderRadius: Dimens.defaultBorderRadius,
    widget: SizedBox(
      width: Dimens.xlgImageSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.paddingNano,
            ),
            child: Text(
              CheckoutStrings.errorText,
              style: AppTextStyle.headline4(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              message,
              style: AppTextStyle.body2(),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              bottom: Dimens.paddingNano,
            ),
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: SizedBox(
                  width: Dimens.xlgImageSize,
                  child: Text(CheckoutStrings.okay.toUpperCase(),
                      style: AppTextStyle.body2().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
