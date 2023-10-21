import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unified_checkout_sdk/core_ui/dimensions.dart';
import 'package:unified_checkout_sdk/core_ui/hubtel_colors.dart';
import 'package:unified_checkout_sdk/core_ui/text_style.dart';
import 'package:unified_checkout_sdk/core_ui/ui_extensions/widget_extensions.dart';
import 'package:unified_checkout_sdk/custom_components/bank_card_expansion.dart';
import 'package:unified_checkout_sdk/custom_components/mobile_money_expansion_tile.dart';
import 'package:unified_checkout_sdk/custom_components/payment_info_card.dart';
import 'package:unified_checkout_sdk/custom_components/show_selected_message.dart';
import 'package:unified_checkout_sdk/extensions/string_extensions.dart';
import 'package:unified_checkout_sdk/extensions/widget_extensions.dart';
import 'package:unified_checkout_sdk/network_manager/extensions/uistate.dart';
import 'package:unified_checkout_sdk/platform/models/card_data.dart';
import 'package:unified_checkout_sdk/platform/models/checkout_requirements.dart';
import 'package:unified_checkout_sdk/platform/models/mobile_money_request.dart';
import 'package:unified_checkout_sdk/platform/models/momo_provider.dart';
import 'package:unified_checkout_sdk/platform/models/momo_response.dart';
import 'package:unified_checkout_sdk/platform/models/purchase_item.dart';
import 'package:unified_checkout_sdk/platform/models/setup_payer_auth%20_response.dart';
import 'package:unified_checkout_sdk/platform/models/setup_payer_auth_request.dart';
import 'package:unified_checkout_sdk/platform/models/wallet.dart';
import 'package:unified_checkout_sdk/resources/checkout_strings.dart';
import 'package:unified_checkout_sdk/utils/checkout_utils.dart';
import 'package:unified_checkout_sdk/utils/currency_formatter.dart';
import 'package:unified_checkout_sdk/utils/helpers/edge_insets.dart';
import 'package:unified_checkout_sdk/utils/custom_expansion_widget.dart'
    as customExpansion;
import 'package:unified_checkout_sdk/ux/otp_3ds_screen.dart';
import 'package:unified_checkout_sdk/ux/viewModel/checkout_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core_ui/app_page.dart';
import '../core_ui/custom_button.dart';
import '../custom_components/other_payment_types_expansion_tile.dart';
import '../platform/models/business_info.dart';
import '../platform/models/checkout_type.dart';
import '../platform/models/payment_status.dart';
import '../platform/models/wallet_type.dart';
import 'check_status_screen.dart';

class CheckoutHomeScreen2 extends StatefulWidget {
  PurchaseInfo checkoutPurchase;

  BusinessInfo businessInfo;

  String accessToken = "";

  Setup3dsResponse? threedsResponse;

  Function(PaymentStatus) checkoutCompleted;

  CheckoutHomeScreen2(
      {Key? key,
      required this.checkoutPurchase,
      required this.businessInfo,
      required this.checkoutCompleted})
      : super(key: key);

  @override
  State<CheckoutHomeScreen2> createState() => _CheckoutHomeScreenState2();
}

class _CheckoutHomeScreenState2 extends State<CheckoutHomeScreen2> {
  late TextEditingController mobileNumberController;

  late TextEditingController momoProviderController;

  late TextEditingController savedCardNumberFieldController;

  TextEditingController cardNumberInputController = TextEditingController();

  TextEditingController cardDateInputController = TextEditingController();

  TextEditingController cardCvvInputController = TextEditingController();

  TextEditingController momoSelectorController = TextEditingController();

  TextEditingController anotherMomoSelectorController = TextEditingController();

  late customExpansion.ExpansionTileController mobileMoneyExpansionController;

  late customExpansion.ExpansionTileController bankCardExpansionController;

  late customExpansion.ExpansionTileController
      otherPaymentWalletExpansionController;

  bool? isMobileMoneyExpanded;

  bool? shouldSaveCardForFuture;

  MomoProvider? selectedProvider;

  String? savedCardCvv;

  String? newCardNumber;

  String? newCardExpiry;

  String? newCardCvv;

  WalletType? walletType;

  Wallet? selectedWallet;

  GlobalKey<FormState> newCardFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> savedCardFormKey = GlobalKey<FormState>();

  List<CardData> savedCards = [];

  bool useNewCard = true;

  bool showWebView = false;

  bool didPreSelectMomoWallet = false;

  double? totalAmountPayable;

  List<Wallet> wallets = [];

  // bool isLoadingFees = false;
  // double? checkoutFees;
  // bool isButtonEnabled = false;

  final checkoutHomeScreenState = _CheckoutHomeScreen2State();

  bool preselectOtherMomoWallet = true;

  late final WebViewController controller;

  final viewModel = CheckoutViewModel();

  @override
  initState() {
    super.initState();
    mobileMoneyExpansionController = customExpansion.ExpansionTileController();
    bankCardExpansionController = customExpansion.ExpansionTileController();
    otherPaymentWalletExpansionController =
        customExpansion.ExpansionTileController();
    mobileNumberController = TextEditingController();
    momoProviderController = TextEditingController();

    savedCardNumberFieldController = TextEditingController();
    fetchWallets();
    controller = WebViewController()
      ..loadHtmlString(CheckoutStrings.makeHtmlString(widget.accessToken ?? ""))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'DeviceCollectionComplete',
        onMessageReceived: (message) {
          if (message.message == CheckoutHtmlState.loadingBegan.toString()) {
            _checkoutInstantServiceWithBankCard();
            print("checkout succeeded successfully");
          } else if (message.message == CheckoutHtmlState.success.toString()) {
            print("checkout succeeded successfully");
            // TODO : Go back and go to the check status screen
          } else if (message.message == CheckoutHtmlState.htmlLoadingFailed) {
            if (!mounted) return;
            // widget.dismissDialog(context: context);

            widget.showErrorDialog(
              context: context,
              message: "Something unexpected happened",
            );
          }
        },
      );
    cardNumberInputController.addListener(onNewCardInputComplete);
    cardDateInputController.addListener(onNewCardInputComplete);
    cardCvvInputController.addListener(onNewCardInputComplete);

    // totalAmountPayable =
    //     widget.checkoutConfig.checkoutPurchase.instantServicePurchase?.amount ?? 0.00;
    //
    // viewModel = context.read<CheckoutViewModel>();
    // _getWallets();
    //
    // controller = WebViewController()
    //   ..loadHtmlString(CheckoutStrings.makeHtmlString(widget.accessToken ?? ""))
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..addJavaScriptChannel(
    //     'DeviceCollectionComplete',
    //     onMessageReceived: (message) {
    //       if (message.message == CheckoutHtmlState.loadingBegan.toString()) {
    //         _checkoutInstantService();
    //         print("checkout succeeded successfully");
    //       } else if (message.message == CheckoutHtmlState.success.toString()) {
    //         print("checkout succeeded successfully");
    //         // TODO : Go back and go to the check status screen
    //       } else if (message.message == CheckoutHtmlState.htmlLoadingFailed) {
    //         if (!mounted) return;
    //         // widget.dismissDialog(context: context);
    //
    //         widget.showErrorDialog(
    //           context: context,
    //           message: "Something unexpected happened",
    //         );
    //       }
    //     },
    //   );

    //
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
        appBarBackgroundColor: HubtelColors.neutral.shade300,
        hideBackNavigation: true,
        pageDecoration: PageDecoration(
          backgroundColor: HubtelColors
              .neutral.shade300, // Theme.of(context).scaffoldBackgroundColor,
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO
              // showDialog(
              //   context: context,
              //   builder: (context) => showCancelDialog(),
              // );
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.xmark_circle_fill,
              color: HubtelColors.neutral.shade900,
              size: Dimens.mdIconSize,
            ),
          )
        ],
        elevation: 0,
        onBackPressed: () {},
        bottomNavigation: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: AnimatedBuilder(
            builder: (context, child) {
              return CustomButton(
                  title:
                      '${CheckoutStrings.pay} ${(totalAmountPayable ?? widget.checkoutPurchase.amount).formatMoney()}'
                          .toUpperCase(),
                  isEnabled: checkoutHomeScreenState.isButtonEnabled.value,
                  buttonAction: () => {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CheckoutStatusScreen()))
                        // payWithMomo()
                        checkout()
                      },
                  loading: checkoutHomeScreenState.isLoadingFees.value,
                  isDisabledBgColor: HubtelColors.lighterGrey,
                  disabledTitleColor: HubtelColors.grey,
                  style: HubtelButtonStyle.solid,
                  isEnabledBgColor: HubtelColors.teal[500]);
            },
            animation: Listenable.merge([
              checkoutHomeScreenState.isButtonEnabled,
              checkoutHomeScreenState.isLoadingFees
            ]),
          ),
        ),
        body: !showWebView
            ? Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: Dimens.paddingDefault),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.paddingDefault,
                            ),
                            child: ValueListenableBuilder(
                              builder: (ctx, value, child) => PaymentInfoCard(
                                checkoutPurchase: widget.checkoutPurchase,
                                checkoutFees: checkoutHomeScreenState
                                        .checkoutFees.value ??
                                    0.00,
                                businessInfo: widget.businessInfo,
                                totalAmountPayable: totalAmountPayable,
                              ),
                              valueListenable:
                                  checkoutHomeScreenState.checkoutFees,
                            ),
                          ),
                          const SizedBox(height: Dimens.iconMediumLarge),
                          Card(
                            margin: symmetricPad(
                              horizontal: Dimens.paddingDefault,
                            ),
                            shadowColor:
                                HubtelColors.neutral.shade300.withOpacity(0.1),
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Dimens.buttonBorderRadius,
                              ),
                            ),
                            color: HubtelColors.neutral,
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.only(
                                top: Dimens.paddingDefault,
                              ),
                              decoration: BoxDecoration(
                                color: HubtelColors.neutral.shade100,
                                borderRadius: BorderRadius.circular(
                                    Dimens.buttonBorderRadius),
                              ),
                              child: Consumer<CheckoutViewModel>(
                                builder: ((context, value, child) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Dimens.paddingDefault,
                                          ),
                                          child: Text(
                                            CheckoutStrings.payWith,
                                            style:
                                                AppTextStyle.body1().copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: Dimens.four),
                                        MobileMoneyExpansionTile(
                                          controller:
                                              mobileMoneyExpansionController,
                                          mobileNumberController:
                                              mobileNumberController,
                                          providerController:
                                              momoProviderController,
                                          wallets: wallets,
                                          providers: value.providers,
                                          isSelected:
                                              walletType == WalletType.Momo,
                                          selectedProviderMessage:
                                              showSelectedProviderMessage(
                                            selectedProvider:
                                                selectedProvider ??
                                                    MomoProvider(),
                                          ),
                                          onWalletSelected: (wallet) {
                                            selectedWallet = wallet;
                                            autoSelectProviderFromSelectedWallet();
                                            fetchFees();
                                          },
                                          onProviderSelected: (provider) {
                                            setState(() {
                                              selectedProvider = provider;
                                            });
                                          },
                                          onExpansionChanged: (value) async {
                                            await onMomoTileExpansionChanged(
                                                value);
                                            if (value) {
                                              autoSelectProviderFromSelectedWallet();
                                              print(selectedWallet?.accountNo);
                                              fetchFees();
                                            }
                                          },
                                        ),

                                        //
                                        Container(
                                          height: 1,
                                          width: double.maxFinite,
                                          color: HubtelColors.grey.shade300,
                                        ),
                                        BankCardExpansionTile(
                                          controller:
                                              bankCardExpansionController,
                                          isSelected:
                                              walletType == WalletType.Card,
                                          newCardFormKey: newCardFormKey,
                                          savedCardFormKey: savedCardFormKey,
                                          savedCards: savedCards,
                                          onSavedCardCvvChanged: (value) {
                                            setState(() {
                                              savedCardCvv = value;
                                            });
                                          },
                                          onUseNewCardSelected: (value) {
                                            setState(() {
                                              useNewCard = value ?? true;
                                            });
                                          },
                                          onSavedCardSelected: (savedCard) {
                                            setState(() {
                                              // selectedSavedCard = savedCard;
                                            });
                                          },
                                          savedCardNumberFieldController:
                                              savedCardNumberFieldController,
                                          onNewCardNumberChanged: (value) {
                                            setState(() {
                                              newCardNumber =
                                                  value.replaceAll(" ", "");
                                            });
                                          },
                                          onNewCardDateChanged: (value) {
                                            setState(() {
                                              newCardExpiry =
                                                  value.replaceAll(" ", "");
                                            });
                                          },
                                          onNewCardCvvChanged: (value) {
                                            setState(() {
                                              newCardCvv = value;
                                            });
                                          },
                                          onExpansionChanged: (value) {
                                            if (value == true) {
                                              setState(() {
                                                isMobileMoneyExpanded = false;
                                                selectedWallet = null;
                                                walletType = WalletType.Card;
                                                checkoutHomeScreenState
                                                    .isButtonEnabled
                                                    .value = false;
                                              });
                                              bankCardExpansionController
                                                  .expand();
                                              mobileMoneyExpansionController
                                                  .collapse();
                                              otherPaymentWalletExpansionController
                                                  .collapse();

                                              // onNewCardInputComplete();
                                            }
                                          },
                                          onCardSaveChecked: (value) {
                                            setState(() {
                                              shouldSaveCardForFuture = value;
                                            });
                                          },
                                          cardNumberInputController:
                                              cardNumberInputController,
                                          cardDateInputController:
                                              cardDateInputController,
                                          cardCvvInputController:
                                              cardCvvInputController,
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.maxFinite,
                                          color: HubtelColors.grey.shade300,
                                        ),
                                        OtherPaymentExpansionTile(
                                          controller:
                                              otherPaymentWalletExpansionController,
                                          onExpansionChanged: (value) async {
                                            // setState(() {
                                            //   walletType == WalletType.Hubtel;
                                            // });
                                            await onOtherTileExpansionChanged(
                                                value);
                                            if (preselectOtherMomoWallet) {
                                              preselectWallet();
                                            }
                                          },

                                          isSelected:
                                              walletType == WalletType.Hubtel,
                                          editingController:
                                              momoSelectorController,
                                          onWalletSelected: (wallet) {
                                            selectedWallet = wallet;
                                          },
                                          wallets: wallets,
                                          anotherEditingController:
                                              anotherMomoSelectorController,
                                          onChannelChanged: (provider) {
                                            selectedProvider =
                                                MomoProvider(alias: provider);
                                            fetchFees2();
                                            log('onChannelChanged - provider {$provider}',
                                                name: '$runtimeType');
                                          }, onNewMandateChecked: (bool? value) {  },
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimens.paddingDefault),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : WebViewWidget(controller: controller));
  }

  void preselectMomoWallet() {
    if (wallets.isNotEmpty) {
      setState(() {
        selectedWallet = wallets[0];
        mobileNumberController.text = selectedWallet?.accountNo ?? "";
        momoProviderController.text =
            CheckoutUtils.mapApiWalletProviderNameToKnowName(
                providerName: selectedWallet?.provider ?? "");
        selectedProvider = MomoProvider(
          name: CheckoutUtils.mapApiWalletProviderNameToKnowName(
            providerName: selectedWallet?.provider ?? "",
          ),
        );
      });
    }
  }

  void preselectWallet() {
    if (wallets.isNotEmpty) {
      setState(() {
        selectedWallet = wallets[0];
        anotherMomoSelectorController.text = selectedWallet?.accountNo ?? "";
      });
    }
  }

  Future<void> onMomoTileExpansionChanged(bool value) async {
    if (value == true && !didPreSelectMomoWallet) {
      preselectMomoWallet();
      setState(() {
        didPreSelectMomoWallet = true;
      });
    }

    if (value == true) {
      setState(() {
        isMobileMoneyExpanded = true;
        walletType = WalletType.Momo;
      });
      mobileMoneyExpansionController.expand();
      bankCardExpansionController.collapse();
      otherPaymentWalletExpansionController.collapse();
    }
  }

  Future<void> onOtherTileExpansionChanged(bool value) async {
    if (value == true) {
      setState(() {
        // isExpanded = true;
        walletType = WalletType.Hubtel;
      });
      mobileMoneyExpansionController.collapse();
      bankCardExpansionController.collapse();
      otherPaymentWalletExpansionController.expand();
    }
  }

  void autoSelectProviderFromSelectedWallet() {
    setState(() {
      momoProviderController.text =
          CheckoutUtils.mapApiWalletProviderNameToKnowName(
              providerName: selectedWallet?.provider ?? "");
      selectedProvider = CheckoutUtils.getProvider(
          providerString: selectedWallet?.provider ?? "");
    });
  }

  fetchWallets() async {
    print(CheckoutViewModel.channelFetch?.isHubtelInternalMerchant);
    if ((CheckoutViewModel.channelFetch?.isHubtelInternalMerchant == true)) {
      final response = await viewModel.fetchWallets();
      if (response.state == UiState.success) {
        viewModel.wallets = response.data;
        setState(() {
          wallets = response.data ?? [];
        });
      } else {
        print(response.hasError);
      }
    }
  }

  _handleButtonActivation() {
    if (walletType == WalletType.Card) {
      checkoutHomeScreenState.isButtonEnabled.value = true;
      return;
    }
    if (selectedWallet != null && selectedProvider != null) {
      checkoutHomeScreenState.isButtonEnabled.value = true;
    }
  }

  fetchFees() async {
    if (walletType == WalletType.Card) {
      selectedProvider = MomoProvider(
          name: CheckoutStrings.BankCard,
          alias: CheckoutStrings.getChannelNameForBankPayment(
              cardNumberInputController.text));
    }

    final response = await viewModel.fetchFees(
        channel: selectedProvider?.receiveMoneyPromptValue ??
            selectedProvider?.alias ??
            "",
        amount: widget.checkoutPurchase.amount);

    if (!mounted) return;

    if (response.state == UiState.success) {
      setState(() {
        checkoutHomeScreenState.isLoadingFees.value = false;
        checkoutHomeScreenState.checkoutFees.value = response.data?.fees;
        totalAmountPayable = response.data?.amountPayable;
        _handleButtonActivation();
      });
    } else {
      checkoutHomeScreenState.isLoadingFees.value = false;
      widget.showErrorDialog(context: context, message: response.message);
    }
  }

  fetchFees2() async {
    checkoutHomeScreenState.isLoadingFees.value = true;
    checkoutHomeScreenState.isButtonEnabled.value = false;

    if (walletType == WalletType.Card) {
      selectedProvider = MomoProvider(
          name: CheckoutStrings.BankCard,
          alias: CheckoutStrings.getChannelNameForBankPayment(
              cardNumberInputController.text));
    }

    final response = await viewModel.fetchFees(
        channel: selectedProvider?.receiveMoneyPromptValue ??
            selectedProvider?.alias ??
            '',
        amount: widget.checkoutPurchase.amount);

    if (!mounted) return;

    if (response.state == UiState.success) {
      checkoutHomeScreenState.isLoadingFees.value = false;
      checkoutHomeScreenState.checkoutFees.value = response.data?.fees;
      totalAmountPayable = response.data?.amountPayable;
      _handleButtonActivation();
    } else {
      checkoutHomeScreenState.isLoadingFees.value = false;
      widget.showErrorDialog(context: context, message: response.message);
    }
  }

  void checkout() {
    if (walletType == WalletType.Momo ||
        walletType == WalletType.Zeepay ||
        walletType == WalletType.GMoney) {
      payWithMomo();
    }

    if (walletType == WalletType.Card) {
      _setup();
    }
  }

  _setup() async {
    final (String? expiryMonth, String? expiryYear) =
        newCardExpiry?.getExpiryInfo() ?? (null, null);

    final dsRequest = SetupPayerAuthRequest(
        amount: 1.00,
        cardHolderName: "",
        cardNumber: newCardNumber ?? "",
        cvv: newCardCvv ?? "",
        expiryMonth: expiryMonth ?? "",
        expiryYear: expiryYear ?? "",
        customerMsisdn: CheckoutRequirements.customerMsisdn,
        description: widget.checkoutPurchase.purchaseDescription,
        clientReference: widget.checkoutPurchase.clientReference,
        callbackUrl:
            "https://9cb7-154-160-1-110.ngrok-free.app/payment-callback");

    widget.showLoadingDialog(
      context: context,
      text: CheckoutStrings.pleaseWait,
    );

    final apiResult = await viewModel.setup(request: dsRequest);

    if (!context.mounted) return;

    if (apiResult.state == UiState.success) {
      widget.accessToken = apiResult.data?.accessToken ?? "";
      widget.threedsResponse = apiResult.data ?? Setup3dsResponse();

      setState(() {
        showWebView = true;

        controller.loadHtmlString(
          CheckoutStrings.makeHtmlString(
            widget.accessToken ?? "",
          ),
        );
      });
    } else {
      Navigator.pop(context);

      widget.showErrorDialog(
        context: context,
        message: apiResult.message,
      );
    }
  }

  _checkoutInstantServiceWithBankCard() async {
    final result = await viewModel.enroll(
        transactionId: widget.threedsResponse?.transactionId ?? "");

    if (!mounted) return;
    if (result.state == UiState.success) {
      Navigator.pop(context);

      final webViewCheckoutData = WebCheckoutPageData(
          jwt: result.data?.jwt ?? "",
          orderId: "",
          reference: "",
          customData: result.data?.customData ?? "");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CheckoutWebViewWidget(pageData: webViewCheckoutData),
        ),
      );
    } else {
      Navigator.pop(context);

      widget.showErrorDialog(
        context: context,
        message: result.message,
      );
    }
  }

  void payWithMomo() async {
    final request = getCheckoutRequest();
    widget.showLoadingDialog(
        context: context, text: CheckoutStrings.pleaseWait);
    final result = await viewModel.payWithMomo(req: request);
    if (!mounted) return;
    Navigator.pop(context);
    if (result.state == UiState.success) {
      final checkoutResponse = result.data;
      widget.showPromptDialog(
          context: context,
          title: CheckoutStrings.success,
          buttonTitle: CheckoutStrings.okay,
          subtitle: CheckoutStrings.getPaymentPromptMessage(
              walletNumber: selectedWallet?.accountNo ?? ""),
          buttonAction: () {
            Navigator.pop(context);
            // Goto Transaction Status Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckStatusScreen(
                  checkoutResponse: checkoutResponse ?? MomoResponse(),
                  checkoutCompleted: widget.checkoutCompleted,
                ),
              ),
            );
          });
    } else {
      widget.showErrorDialog(context: context, message: result.message);
    }
  }

  MobileMoneyPaymentRequest getCheckoutRequest() {
    if (walletType == WalletType.Momo) {
      if (CheckoutViewModel.checkoutType == CheckoutType.receivemoneyprompt) {
        return MobileMoneyPaymentRequest(
            customerName: "",
            customerMsisdn: selectedWallet?.accountNo ?? "",
            channel: selectedProvider?.receiveMoneyPromptValue ?? "",
            amount: "${totalAmountPayable ?? 0.00}",
            primaryCallbackUrl: "",
            description: "",
            clientReference: widget.checkoutPurchase.clientReference,
            mandateId: "");
      } else if (CheckoutViewModel.checkoutType == CheckoutType.directdebit) {
        return MobileMoneyPaymentRequest(
            customerName: "",
            customerMsisdn: selectedWallet?.accountNo ?? "",
            channel: selectedProvider?.directDebitValue ?? "",
            amount: "${totalAmountPayable ?? 0.00}",
            primaryCallbackUrl: "",
            description: "",
            clientReference: widget.checkoutPurchase.clientReference,
            mandateId: "");
      }
    } else if (walletType == WalletType.Hubtel) {
      final hubtelWallet = wallets
          .firstWhere((element) => element.provider?.toLowerCase() == "hubtel");
      return MobileMoneyPaymentRequest(
          customerName: "",
          customerMsisdn: hubtelWallet?.accountNo ?? "",
          channel: "hubtel-gh",
          amount: "${totalAmountPayable ?? 0.00}",
          primaryCallbackUrl: "",
          description: "",
          clientReference: widget.checkoutPurchase.clientReference,
          mandateId: "");
    } else if (walletType == WalletType.GMoney) {
      return MobileMoneyPaymentRequest(
          customerName: "",
          customerMsisdn: selectedWallet?.accountNo ?? "",
          channel: "gmoney",
          amount: "${totalAmountPayable ?? 0.00}",
          primaryCallbackUrl: "",
          description: "",
          clientReference: widget.checkoutPurchase.clientReference,
          mandateId: "");
    } else if (walletType == WalletType.Zeepay) {
      return MobileMoneyPaymentRequest(
          customerName: "",
          customerMsisdn: selectedWallet?.accountNo ?? "",
          channel: "zeepay",
          amount: "${totalAmountPayable ?? 0.00}",
          primaryCallbackUrl: "",
          description: "",
          clientReference: widget.checkoutPurchase.clientReference,
          mandateId: "");
    }

    return MobileMoneyPaymentRequest();
  }

  void onNewCardInputComplete() {
    final isCardNumberInputComplete =
        cardNumberInputController.text.trim().isNotEmpty &&
            cardNumberInputController.text.characters.length == 22;

    final isCardDateInputComplete =
        cardDateInputController.text.trim().isNotEmpty &&
            cardDateInputController.text.length == 5;

    final isCardCvvInputComplete =
        cardCvvInputController.text.trim().isNotEmpty &&
            cardCvvInputController.text.length == 3;

    if (isCardNumberInputComplete &&
        isCardDateInputComplete &&
        isCardCvvInputComplete) {
      fetchFees();
    }
  }
}

class _CheckoutHomeScreen2State {
  final ValueNotifier<double?> _checkoutFees = ValueNotifier(null);
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingFees = ValueNotifier(false);
  final ValueNotifier<String> _selectedChannel = ValueNotifier('Hubtel');

  ValueNotifier<double?> get checkoutFees => _checkoutFees;

  ValueNotifier<bool> get isButtonEnabled => _isButtonEnabled;

  ValueNotifier<bool> get isLoadingFees => _isLoadingFees;

  ValueNotifier<String> get selectedChannel => _selectedChannel;
}
