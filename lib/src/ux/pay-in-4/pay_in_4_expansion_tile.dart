import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/custom_components/custom_components.dart';
import 'package:hubtel_merchant_checkout_sdk/src/custom_components/mobile_money_tile_field.dart';
import 'package:hubtel_merchant_checkout_sdk/src/custom_components/saved_bank_card_form.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/models.dart';
import 'package:hubtel_merchant_checkout_sdk/src/resources/checkout_drawables.dart';
import 'package:hubtel_merchant_checkout_sdk/src/resources/checkout_strings.dart';
import 'package:hubtel_merchant_checkout_sdk/src/utils/currency_formatter.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/payment_display_schedule.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/repayment_schedule_table.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/view_model/checkout_view_model.dart';
import '/src/core_ui/core_ui.dart';
import '/src/utils/custom_expansion_widget.dart' as customExpansion;

class PayIn4ExpansionTile extends StatefulWidget {
  // final TextEditingController editingController;

  // final TextEditingController anotherEditingController;

  final TextEditingController cardNumberInputController;

  final TextEditingController cvvTextController;

  final TextEditingController expiryDateController;

  final TextEditingController providerFieldTextController;

  final TextEditingController walletNumberController;

  bool expandOptions = false;

  String selectedAccount = "Hubtel";

  Function(Wallet) onWalletSelected;

  Function(String) onChannelChanged;

  // Function(bool) onMandateTap;
  List<Wallet> providers;

  ValueChanged<bool> onMandateTap;

  String initSelectedProvider;

  List<Wallet> wallets;

  bool confirmToPay;

  bool useMtnMomo = true;

  bool useVodaMomo = false;

  bool useBank = false;

  List<String> bankCardTypeTabNames = [
    CheckoutStrings.useNewCard,
    CheckoutStrings.useSavedCard
  ];

  PayIn4ExpansionTile(
      {Key? key,
      required this.controller,
      required this.onExpansionChanged,
      // required this.editingController,
      required this.isSelected,
      required this.wallets,
      required this.onWalletSelected,
      // required this.anotherEditingController,
      required this.onChannelChanged,
      required this.onMandateTap,
      required this.selectedAccount,
      required this.providers,
      required this.initSelectedProvider,
      required this.confirmToPay,
      required this.cardNumberInputController,
      required this.cvvTextController,
      required this.expiryDateController,
      required this.providerFieldTextController,
      required this.walletNumberController})
      : super(key: key);

  final customExpansion.ExpansionTileController controller;
  final void Function(bool)? onExpansionChanged;

  final bool isSelected;

  // final double value;
  @override
  State<PayIn4ExpansionTile> createState() => _OtherPaymentExpansionTileState();
}

class _OtherPaymentExpansionTileState extends State<PayIn4ExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return customExpansion.ExpansionTile(
      controller: widget.controller,
      headerBackgroundColor: widget.isSelected
          ? ThemeConfig.themeColor.withOpacity(0.3)
          : Colors.transparent,
      onExpansionChanged: widget.onExpansionChanged,
      maintainState: true,
      title: Text(
        CheckoutStrings.payIn4,
        style: AppTextStyle.body2(),
      ),
      expandedAlignment: Alignment.topLeft,
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingDefault,
        vertical: Dimens.paddingDefault,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImageWidget.local(
            image: const AssetImage(CheckoutDrawables.mtnMomoLogo),
            width: Dimens.iconMedium,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
          const SizedBox(width: Dimens.paddingDefaultSmall),
          AppImageWidget.local(
            image: const AssetImage(CheckoutDrawables.vodafoneCashLogo),
            width: Dimens.iconSmall,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
          const SizedBox(width: Dimens.paddingDefaultSmall),
          AppImageWidget.local(
            image: const AssetImage(CheckoutDrawables.visa),
            width: Dimens.iconSmall,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
          const SizedBox(width: Dimens.paddingDefaultSmall),
          AppImageWidget.local(
            image: const AssetImage(CheckoutDrawables.masterCard),
            width: Dimens.iconSmall,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
        ],
      ),
      leading: CustomRadioIndicator(
        isSelected: widget.isSelected,
      ),
      leadingWidth: Dimens.iconMedium,
      titleAlignment: ListTileTitleAlignment.center,
      children: [
        Visibility(
          visible: !widget.confirmToPay,
          child: _buildPayIn4DescriptionBottom(
              totalPaymentAmount: 1000,
              amountPayableNow: 330,
              remainingAmount: 250),
        ),
        Visibility(
            visible: widget.confirmToPay,
            child: _buildMobileMoneyWalletDisplay()),
        Visibility(
          visible: widget.confirmToPay,
          child: PaymentScheduleDisplay(
            repaymentSchedules: [
              RepaymentScheduleObj(
                repaymentTime: "Now",
                repaymentAmount: 330,
              ),
              RepaymentScheduleObj(
                repaymentTime: "12 Jan 2024",
                repaymentAmount: 250,
              ),
              RepaymentScheduleObj(
                  repaymentTime: "12 Feb 2024", repaymentAmount: 250),
              RepaymentScheduleObj(
                  repaymentTime: "12 Mar 2024", repaymentAmount: 250)
            ],
          ),
        ),
        Visibility(
          visible: widget.confirmToPay,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text("Pay in 4 is backed by letshego under these terms"),
          ),
        )
      ],
    );
  }

  _onPaymentTypeChanged({required String selectedAccount}) {
    //
    if (OtherAccountTypes.Hubtel.rawValue == selectedAccount) {
      widget.onChannelChanged('hubtel-gh');
      setState(() {
        // widget.selectedAccount = "Hubtel";
        // showHubtelWalletActions = true;
        // showGmoneyWalletActions = false;
        // showZeePayWalletActions = false;
      });

      return;
    }

    if (OtherAccountTypes.GMoney.rawValue == selectedAccount) {
      widget.onChannelChanged('g-money');
      setState(() {
        // widget.selectedAccount = "GMoney";
        // showHubtelWalletActions = false;
        // showGmoneyWalletActions = true;
        // showZeePayWalletActions = false;
      });
      return;
    }

    if (OtherAccountTypes.Zeepay.rawValue == selectedAccount) {
      setState(() {
        widget.onChannelChanged('zeepay');
        // showHubtelWalletActions = false;
        // showGmoneyWalletActions = false;
        // showZeePayWalletActions = true;
      });

      return;
    }
  }

  Widget _buildPayIn4DescriptionBottom(
      {required double totalPaymentAmount,
      required double amountPayableNow,
      required double remainingAmount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "You qualify to pay for your item of",
            style: AppTextStyle.body2(),
            children: <TextSpan>[
              TextSpan(
                text: " ${totalPaymentAmount.formatMoney()} ",
                style:
                    AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "in 4 splits",
                style: AppTextStyle.body2(),
              )
            ],
          ),
        ),
        const SizedBox(
          height: Dimens.paddingDefault,
        ),
        RichText(
          text: TextSpan(
            text: "For this",
            style: AppTextStyle.body2(),
            children: <TextSpan>[
              TextSpan(
                text: " ${totalPaymentAmount.formatMoney()} ",
                style:
                    AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text: "payment, you may pay", style: AppTextStyle.body2()),
              TextSpan(
                text: " ${amountPayableNow.formatMoney()} ",
                style:
                    AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: "now.", style: AppTextStyle.body2()),
            ],
          ),
        ),
        const SizedBox(
          height: Dimens.paddingDefault,
        ),
        RichText(
          text: TextSpan(
            text: "Pay only",
            style: AppTextStyle.body2(),
            children: <TextSpan>[
              TextSpan(
                text: " ${amountPayableNow.formatMoney()} ",
                style:
                    AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: " now. ", style: AppTextStyle.body2()),
              TextSpan(text: "The remaining", style: AppTextStyle.body2()),
              TextSpan(
                text: " ${remainingAmount.formatMoney()} ",
                style:
                    AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text: "will be debited in three equal installments.",
                  style: AppTextStyle.body2()),
            ],
          ),
        ),
        HBPlainTextButtonLarge.createTealButton(
          title: "View payment details and terms",
          buttonAction: () {},
          padding: 0,
        )
      ],
    );
  }

  Widget _buildMobileMoneyWalletDisplay() {
    return Column(
      children: [
        MobileMoneyTileField(
          fieldController: widget.providerFieldTextController,
          onWalletSelected: (wallet) {
            print(wallet);
            widget.onWalletSelected(wallet);
          },
          onProviderSelected: (provider) {
            _handleProviderSelection(provider: provider.alias ?? "");
          },
          providers: [
            MomoProvider(name: "Mtn Mobile Money", alias: "mtn"),
            MomoProvider(name: "Vodafone cash", alias: "vodafone"),
            MomoProvider(name: "Bank Card", alias: "bank")
          ],
          hintText: CheckoutStrings.mobileNetwork,
        ),
        const SizedBox(height: Dimens.paddingDefault),
        Visibility(
          visible: (widget.useMtnMomo || widget.useVodaMomo),
          child: MobileMoneyTileField(
            fieldController: widget.walletNumberController,
            onWalletSelected: widget.onWalletSelected,
            onProviderSelected: (provider) {},
            wallets: widget.wallets,
            hintText: CheckoutStrings.mobileNumber,
            isReadOnly: true,
          ),
        ),
        // const SizedBox(
        //   height: Dimens.paddingDefault,
        // ),
        Visibility(visible: widget.useBank, child: _buildBankPaymentTile()),
        const SizedBox(
          height: Dimens.paddingDefault,
        )
      ],
    );
  }

  _handleProviderSelection({required String provider}) {
    switch (provider) {
      case "mtn":
        widget.useMtnMomo = true;
        widget.useBank = false;
      case "vodafone":
        widget.useMtnMomo = true;
        widget.useBank = false;
      case "bank":
        widget.useMtnMomo = false;
        widget.useBank = true;
      default:
        print("default actions");
    }
    setState(() {});
  }

  Widget _buildBankPaymentTile() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.bankCardTypeTabNames
            .asMap()
            .entries
            .map(
              (e) => BankCardTypeTab(
            tabText: e.value,
            isSelected: e.key == 0,
            onTap: () {
              setState(() {
                // if (widget.savedCards.isEmpty) {
                //   return;
                // }
                // selectedTabIndex = e.key;
                // widget.onUseNewCardSelected(e.key == 0);
              });
            },
          ),
        )
            .toList(),
      ),
      SizedBox(height: 16,),
      NewBankCardForm(
        onCardSaveChecked: (value) {},
        onNewCardNumberChanged: (number) {},
        onNewCardDateChanged: (date) {},
        onNewCardCvvChanged: (cvv) {},
        formKey: GlobalKey<FormState>(),
        cardNumberInputController: widget.cardNumberInputController,
        cardDateInputController: widget.expiryDateController,
        cardCvvInputController: widget.expiryDateController,
      ),
      // SavedBankCardForm(
      //   cardNumberFieldController: TextEditingController(),
      //   cards: [],
      //   onCardSelected: (data) {},
      //   onCvvChanged: (cvv) {},
      //   formKey: GlobalKey<FormState>(),
      // ),
    ]);
  }
}
