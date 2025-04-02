import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../platform/models/models.dart';
import '../view_model/checkout_view_model.dart';
import '/src/core_ui/core_ui.dart';
import '../../resources/checkout_drawables.dart';
import '../../resources/checkout_strings.dart';

class CheckStatusScreen extends StatefulWidget {
  final MomoResponse checkoutResponse;

  final viewModel = CheckoutViewModel();
  late final ThemeConfig? themeConfig;
  final String? checkoutChannel;
  final WalletType? walletType;


  CheckStatusScreen({
    super.key,
    required this.checkoutResponse,
    this.themeConfig,
    this.checkoutChannel,
    this.walletType
  });

  @override
  State<CheckStatusScreen> createState() => _CheckStatusScreenState();
}

class _CheckStatusScreenState extends State<CheckStatusScreen> {
  // late PaymentStatusViewModel paymentStatusViewModel;
  PaymentStatus paymentStatus = PaymentStatus.unspecified;
  String paymentStatusErrorMessage = 'Transaction Failed';
  late CheckoutOrderStatus checkoutOrderStatus;
  bool showPendingTimer = false;
  int timeLeft = 5;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // paymentStatusViewModel = context.read<PaymentStatusViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: CheckoutStrings.processingPayment,
      hideBackNavigation: true,
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(
            CheckoutStrings.cancel,
            style: AppTextStyle.body2().copyWith(
              color: HubtelColors.crimson,
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingIndicator(
                          loaderColor: ThemeConfig.themeColor,
                        ),
                        const SizedBox(height: 24.0),
                        const Text('Checking status...',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  : switch (paymentStatus) {
                      PaymentStatus.unspecified => paymentStatusContent(
                          assetPath: CheckoutDrawables.processingPayment,
                          description:
                              CheckoutStrings.yourPaymentIsBeingProcessed,
                        ),
                      PaymentStatus.unpaid => paymentStatusContent(
                          assetPath: CheckoutDrawables.transactionError,
                          description: paymentStatusErrorMessage,
                        ),
                      PaymentStatus.paid => paymentStatusContent(
                          assetPath: CheckoutDrawables.transactionSuccessful,
                          description: CheckoutStrings.transactionSuccessful,
                        ),
                      PaymentStatus.pending => paymentStatusContent(
                          assetPath: CheckoutDrawables.transactionPending,
                          description: CheckoutStrings
                              .yourPaymentIsBeingProcessedCheckAgain,
                        ),
                      PaymentStatus.expired => paymentStatusContent(
                          assetPath: CheckoutDrawables.transactionError,
                          description: paymentStatusErrorMessage,
                        ),
                      PaymentStatus.failed => paymentStatusContent(
                          assetPath: CheckoutDrawables.transactionError,
                          description: paymentStatusErrorMessage,
                        )
                    },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: Dimens.paddingSmall,
              left: Dimens.paddingDefault,
              right: Dimens.paddingDefault,
              bottom: 13.0,
            ),
            child: CustomButton(
              width: double.infinity,
              title: switch (paymentStatus) {
                PaymentStatus.unspecified => CheckoutStrings.iHavePaid,
                PaymentStatus.paid => CheckoutStrings.done.toUpperCase(),
                PaymentStatus.unpaid => CheckoutStrings.done.toUpperCase(),
                PaymentStatus.expired => CheckoutStrings.done.toUpperCase(),
                PaymentStatus.failed => CheckoutStrings.done.toUpperCase(),
                PaymentStatus.pending => showPendingTimer
                    ? CheckoutStrings.checkAgainTimeLeft(timeLeft: timeLeft)
                        .toUpperCase()
                    : CheckoutStrings.checkAgain.toUpperCase(),
              },
              buttonAction: onButtonClick,
              isDisabledBgColor: const Color(0xFFF8F9FB),
              disabledTitleColor: const Color(0xFF9CABB8),
              style: HubtelButtonStyle.solid,
              isEnabledBgColor: ThemeConfig.themeColor,
              isEnabled:
                  !showPendingTimer || paymentStatus == PaymentStatus.paid,
            ),
          )
        ],
      ),
    );
  }

  void startTimer() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timeLeft > 0) setState(() => timeLeft--);
        if (timeLeft == 0) {
          timer.cancel();
          showPendingTimer = false;
          setState(() => timeLeft = 5);
        }
      },
    );
  }

  Widget paymentStatusContent({
    required String assetPath,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(assetPath),
        const SizedBox(height: 24.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 53.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyle.body2(),
          ),
        )
      ],
    );
  }

  onButtonClick() async {
    final isPaymentStatusPaidOrFailed = paymentStatus == PaymentStatus.paid ||
        paymentStatus == PaymentStatus.failed;
      print('payment Status $paymentStatus');

    if (paymentStatus == PaymentStatus.paid) {
      final checkoutPaymentStatus = CheckoutCompletionStatus(status: UnifiedCheckoutPaymentStatus.paymentSuccess, transactionId: widget.checkoutResponse.transactionId ?? "", paymentChannel: widget.checkoutChannel, paymentType: widget.walletType?.optionValue);
      Navigator.pop(context);
      Navigator.pop(context, checkoutPaymentStatus);
      return;
    }

    if (paymentStatus == PaymentStatus.failed) {
      final checkoutPaymentStatus = CheckoutCompletionStatus(status: UnifiedCheckoutPaymentStatus.paymentFailed, transactionId: widget.checkoutResponse.transactionId ?? "", paymentChannel: widget.checkoutChannel, paymentType: widget.walletType?.optionValue);
      Navigator.pop(context);
      Navigator.pop(context, checkoutPaymentStatus);
      return;
    }

    if (paymentStatus == PaymentStatus.pending ||
        paymentStatus == PaymentStatus.unpaid) {
      startTimer();
      setState(() => showPendingTimer = true);
    }

    final clientReference = widget.checkoutResponse.clientReference ?? "";
    setState(() => isLoading = true);
    final status =
        await widget.viewModel.checkStatus(clientReference: clientReference);
    setState(() {
      paymentStatus = status.data?.paymentStatus ?? PaymentStatus.pending;
      paymentStatusErrorMessage = paymentStatus == PaymentStatus.failed
          ? status.data?.providerDescription ?? ''
          : CheckoutStrings.somethingWentWrong;
      checkoutOrderStatus = status.data ?? CheckoutOrderStatus();
      isLoading = false;
    });
  }
}
