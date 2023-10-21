import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_checkout_sdk/core_ui/app_image_widget.dart';
import 'package:unified_checkout_sdk/core_ui/dimensions.dart';
import 'package:unified_checkout_sdk/core_ui/hubtel_colors.dart';
import 'package:unified_checkout_sdk/core_ui/text_style.dart';
import 'package:unified_checkout_sdk/custom_components/custom_indicator.dart';
import 'package:unified_checkout_sdk/custom_components/mobile_money_tile_field.dart';
import 'package:unified_checkout_sdk/platform/models/wallet.dart';
import 'package:unified_checkout_sdk/resources/checkout_drawables.dart';
import 'package:unified_checkout_sdk/resources/checkout_strings.dart';
import 'package:unified_checkout_sdk/utils/currency_formatter.dart';
import 'package:unified_checkout_sdk/utils/custom_expansion_widget.dart'
    as customExpansion;

enum OtherAccountTypes {
  Hubtel("Hubtel"),
  GMoney("GMoney"),
  Zeepay("Zeepay");

  final String rawValue;

  const OtherAccountTypes(this.rawValue);
}

class OtherPaymentExpansionTile extends StatefulWidget {
  final TextEditingController editingController;

  final TextEditingController anotherEditingController;

  bool expandOptions = false;

  bool showHubtelWalletActions = false;

  bool showGmoneyWalletActions = false;

  bool? isNewMandateChecked = false;

  bool showZeePayWalletActions = false;

  String selectedAccount = "Hubtel";

  Function(Wallet) onWalletSelected;

  Function(String) onChannelChanged;

  Function(bool?) onNewMandateChecked;

  List<Wallet> walletTypes = [
    Wallet(
        externalId: "0011",
        accountNo: "",
        accountName: "Hubtel",
        providerId: "providerId",
        provider: "provider",
        type: "type"),
    Wallet(
        externalId: "",
        accountNo: "",
        accountName: "GMoney",
        providerId: "providerId",
        provider: "provider",
        type: "type"),
    Wallet(
        externalId: "0011",
        accountNo: "0556236739",
        accountName: "Zeepay",
        providerId: "providerId",
        provider: "provider",
        type: "type"),
  ];

  List<Wallet> wallets;

  OtherPaymentExpansionTile({
    Key? key,
    required this.controller,
    required this.onExpansionChanged,
    required this.editingController,
    required this.isSelected,
    required this.wallets,
    required this.onWalletSelected,
    required this.anotherEditingController,
    required this.onChannelChanged,
    this.isNewMandateChecked = false,
    required this.onNewMandateChecked,
  }) : super(key: key);

  final customExpansion.ExpansionTileController controller;
  final void Function(bool)? onExpansionChanged;
  final bool isSelected;

  // final double value;

  @override
  State<OtherPaymentExpansionTile> createState() =>
      _OtherPaymentExpansionTileState();
}

class _OtherPaymentExpansionTileState extends State<OtherPaymentExpansionTile> {
  // List<String> bankCardTypeTabNames = [
  //   CheckoutStrings.useNewCard,
  //   CheckoutStrings.useSavedCard
  // ];

  // @override
  // void initState() {
  //   super.initState();
  //   autoSelectFirstWallet();
  // }

  bool? showGMoneyInstruction;

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
        CheckoutStrings.other,
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
            image: const AssetImage(CheckoutDrawables.hubtel_logo),
            width: Dimens.iconMedium,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
          const SizedBox(width: Dimens.paddingDefaultSmall),
          AppImageWidget.local(
            image: const AssetImage(CheckoutDrawables.g_money_logo),
            width: Dimens.iconSmall,
            height: Dimens.iconSmall,
            boxFit: BoxFit.contain,
            borderRadius: 0,
          ),
          const SizedBox(width: Dimens.paddingDefaultSmall),
          AppImageWidget.local(
            image: const AssetImage(CheckoutDrawables.zee_pay_logo),
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
        MobileMoneyTileField(
            showWalletAdditionTile: false,
            fieldController: widget.editingController,
            wallets: widget.walletTypes,
            onWalletSelected: (wallet) {
              log('payment type ${wallet.accountName}', name: '$runtimeType');
              if (wallet.accountName == 'GMoney') {
                showGMoneyInstruction = true;
              } else {
                showGMoneyInstruction = null;
              }
              _onPaymentTypeChanged(selectedAccount: wallet.accountName ?? "");
            },
            onProviderSelected: (provider) {
              log('$provider', name: '$runtimeType');
            },
            hintText: "Hubtel",),
        Visibility(
          visible: widget.showHubtelWalletActions,
          child: Container(
            alignment: Alignment.topLeft,
            child: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Your balance Hubtel will be debited immediately you confirm. \n\nNo authorization prompt will be sent to you",
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        Visibility(
            visible: showGMoneyInstruction != null ||
                widget.showZeePayWalletActions,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: MobileMoneyTileField(
                  fieldController: widget.anotherEditingController,
                  wallets: widget.wallets,
                  onWalletSelected: (wallet) {
                    widget.onWalletSelected(wallet);
                  },
                  onProviderSelected: (provider) {
                    print(provider);
                  },
                  hintText: "Hinting"),
            )),
        Visibility(
          visible: showGMoneyInstruction != null,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Checkbox(
                value: widget.isNewMandateChecked,
                onChanged: (bool? value) {
                  // setState(() {
                  //   widget.showGmoneyWalletActions = true;
                  // });
                  widget.onNewMandateChecked(value);
                }),
            const Text("Use Mandate ID")
          ]),
        ),
        Visibility(
            visible: showGMoneyInstruction != null,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                  "You will be required to enter your Mandate ID to confirm your transaction"),
            )),
        Visibility(
            visible: widget.showZeePayWalletActions,
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Steps to authorize payment",
                      style: AppTextStyle.body2()
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "1. Dial *270#",
                      style: AppTextStyle.body2(),
                    ),
                    Text(
                      "2. Select Option 8 (Account)",
                      style: AppTextStyle.body2(),
                    ),
                    Text(
                      "3. Select Option 4 (Approve Payment)",
                      style: AppTextStyle.body2(),
                    ),
                    Text(
                      "4. Enter Pin to make Payment",
                      style: AppTextStyle.body2(),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  _onPaymentTypeChanged({required String selectedAccount}) {
    log('Selected Account: $selectedAccount', name: '$runtimeType');

    if (OtherAccountTypes.Hubtel.rawValue == selectedAccount) {
      widget.onChannelChanged('hubtel-gh');
      setState(() {
        widget.showHubtelWalletActions = true;
        widget.showGmoneyWalletActions = false;
        widget.showZeePayWalletActions = false;
      });

      return;
    }

    if (OtherAccountTypes.GMoney.rawValue == selectedAccount) {
      widget.onChannelChanged('g-money');
      setState(() {
        // widget.selectedAccount = "GMoney";
        widget.showHubtelWalletActions = false;
        widget.showGmoneyWalletActions = true;
        widget.showZeePayWalletActions = false;
      });
      return;
    }

    if (OtherAccountTypes.Zeepay.rawValue == selectedAccount) {
      setState(() {
        widget.onChannelChanged('zeepay');
        widget.showHubtelWalletActions = false;
        widget.showGmoneyWalletActions = false;
        widget.showZeePayWalletActions = true;
      });

      return;
    }
  }
}
