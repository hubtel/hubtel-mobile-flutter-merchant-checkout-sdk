import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extensions/extensions.dart';
import 'package:unified_checkout_sdk/src/utils/utils.dart';
import '../../core_ui/core_ui.dart';
import '../../network_manager/network_manager.dart';
import '../../platform/models/models.dart';
import '../../resources/checkout_strings.dart';
import '../../utils/custom_expansion_widget.dart' as customExpansion;
import 'package:webview_flutter/webview_flutter.dart';

import '../../custom_components/custom_components.dart';

import '../../resources/html_strings.dart';
import '../bank_pay/bank_pay_receipt_screen.dart';
import '../gh_card/add_gh_card_screen.dart';
import '../gh_card/gh_card_verification_screen.dart';
import '../otp_3ds/otp_3ds_screen.dart';
import '../status/check_status_screen.dart';
import '../mandate/new_mandate_id_screen.dart';
import '../view_model/checkout_view_model.dart';

class CheckoutHomeScreen extends StatefulWidget {
  late final PurchaseInfo checkoutPurchase;

  late final BusinessInfo businessInfo;
  late final ThemeConfig? themeConfig;

  String accessToken = '';

  late final Setup3dsResponse? threeDsResponse;

  Function(PaymentStatus) checkoutCompleted;

  CheckoutHomeScreen(
      {Key? key,
      required this.checkoutPurchase,
      required this.businessInfo,
      required this.checkoutCompleted,
      this.themeConfig})
      : super(key: key);

  @override
  State<CheckoutHomeScreen> createState() => _CheckoutHomeScreenState();
}

class _CheckoutHomeScreenState extends State<CheckoutHomeScreen> {
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

  bool isNewMandateChecked = false;

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

  final checkoutHomeScreenState = _CheckoutHomeState();

  bool preselectOtherMomoWallet = true;

  late final WebViewController controller;

  final viewModel = CheckoutViewModel();

  late customExpansion.ExpansionTileController bankPayExpansionController;

  @override
  initState() {
    super.initState();
    bankPayExpansionController = customExpansion.ExpansionTileController();
    mobileMoneyExpansionController = customExpansion.ExpansionTileController();
    bankCardExpansionController = customExpansion.ExpansionTileController();
    otherPaymentWalletExpansionController =
        customExpansion.ExpansionTileController();
    mobileNumberController = TextEditingController();
    momoProviderController = TextEditingController();

    savedCardNumberFieldController = TextEditingController();
    fetchWallets();
    controller = WebViewController()
      ..loadHtmlString(CheckoutStrings.makeHtmlString(widget.accessToken ?? ''))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'DeviceCollectionComplete',
        onMessageReceived: (message) {
          if (message.message == CheckoutHtmlState.loadingBegan.toString()) {
            _checkoutInstantServiceWithBankCard(context);
            print('checkout succeeded successfully');
          } else if (message.message == CheckoutHtmlState.success.toString()) {
            print('checkout succeeded successfully');
            // TODO : Go back and go to the check status screen
          } else if (message.message == CheckoutHtmlState.htmlLoadingFailed) {
            if (!mounted) return;
            // widget.dismissDialog(context: context);

            widget.showErrorDialog(
              context: context,
              message: 'Something unexpected happened',
            );
          }
        },
      );
    cardNumberInputController.addListener(onNewCardInputComplete);
    cardDateInputController.addListener(onNewCardInputComplete);
    cardCvvInputController.addListener(onNewCardInputComplete);
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
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: AnimatedBuilder(
            builder: (context, child) {
              return CustomButton(
                title:
                    '${CheckoutStrings.pay} ${(totalAmountPayable ?? widget.checkoutPurchase.amount).formatMoney()}'
                        .toUpperCase(),
                isEnabled: checkoutHomeScreenState.isButtonEnabled.value,
                buttonAction: () {
                  checkout();
                },
                loading: checkoutHomeScreenState.isLoadingFees.value,
                isDisabledBgColor: HubtelColors.lighterGrey,
                disabledTitleColor: HubtelColors.grey,
                style: HubtelButtonStyle.solid,
                isEnabledBgColor: ThemeConfig.themeColor,
              );
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
                                                  value.replaceAll(' ', '');
                                            });
                                          },
                                          onNewCardDateChanged: (value) {
                                            setState(() {
                                              newCardExpiry =
                                                  value.replaceAll(' ', '');
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
                                              bankPayExpansionController
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
                                            await onOtherTileExpansionChanged(
                                                value);
                                            if (preselectOtherMomoWallet) {
                                              preselectWallet();
                                            }
                                          },
                                          isSelected: walletType ==
                                                  WalletType.Hubtel ||
                                              walletType == WalletType.GMoney ||
                                              walletType == WalletType.Zeepay,
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
                                            changeWalletType(provider);
                                            fetchFees2();
                                          },
                                          onNewMandateChecked: (bool? value) {
                                            setState(() {
                                              isNewMandateChecked =
                                                  !isNewMandateChecked;
                                            });

                                            log('$isNewMandateChecked',
                                                name: '$runtimeType');
                                          },
                                          isNewMandateChecked:
                                              isNewMandateChecked,
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.maxFinite,
                                          color: HubtelColors.grey.shade300,
                                        ),
                                        BankPayExpansionTile(
                                          controller:
                                              bankPayExpansionController,
                                          onExpansionChanged: (value) {
                                            if (value) {
                                              bankCardExpansionController
                                                  .collapse();
                                              mobileMoneyExpansionController
                                                  .collapse();
                                              otherPaymentWalletExpansionController
                                                  .collapse();
                                              setState(() {
                                                walletType = WalletType.BankPay;
                                              });
                                              fetchFees2();
                                            }
                                          },
                                          isSelected:
                                              walletType == WalletType.BankPay,
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
        mobileNumberController.text = selectedWallet?.accountNo ?? '';
        momoProviderController.text =
            CheckoutUtils.mapApiWalletProviderNameToKnowName(
                providerName: selectedWallet?.provider ?? '');
        selectedProvider = MomoProvider(
          name: CheckoutUtils.mapApiWalletProviderNameToKnowName(
            providerName: selectedWallet?.provider ?? '',
          ),
        );
      });
    }
  }

  void preselectWallet() {
    if (wallets.isNotEmpty) {
      setState(() {
        selectedWallet = wallets[0];
        anotherMomoSelectorController.text = selectedWallet?.accountNo ?? '';
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
      bankPayExpansionController.collapse();

      // final channel = viewModel.getMomoChannelName(selectedProvider?.name);
      // final feeSum = await computeCheckoutFeeSum(channel);
      // final purchaseAmount =
      //     widget.checkoutConfig.checkoutPurchase.instantServicePurchase?.amount ?? 0.00;

      //   setState(() {
      //     totalAmountPayable = purchaseAmount + feeSum;
      //   });
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
      bankPayExpansionController.collapse();
    }
  }

  void autoSelectProviderFromSelectedWallet() {
    setState(() {
      momoProviderController.text =
          CheckoutUtils.mapApiWalletProviderNameToKnowName(
              providerName: selectedWallet?.provider ?? '');
      selectedProvider = CheckoutUtils.getProvider(
          providerString: selectedWallet?.provider ?? '');
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
        viewModel.notifyListeners();
      } else {
        print(response.hasError);
      }
    }
  }

  _handleButtonActivation() {
    if (walletType == WalletType.Card || walletType == WalletType.BankPay) {
      checkoutHomeScreenState.isButtonEnabled.value = true;
      return;
    }

    if (selectedWallet != null && selectedProvider != null) {
      checkoutHomeScreenState.isButtonEnabled.value = true;
    }
  }

  fetchFees() async {
    // setState(() {
    //   isLoadingFees = true;
    //   isButtonEnabled = false;
    // });

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

    if (walletType == WalletType.BankPay) {
      selectedProvider = MomoProvider(
          name: CheckoutStrings.bankPay, alias: CheckoutStrings.bankPay);
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

  void changeWalletType(String channel) {
    print(channel);
    switch (channel.toLowerCase()) {
      case 'hubtel-gh':
        walletType = WalletType.Hubtel;
      case 'g-money':
        walletType = WalletType.GMoney;
      case 'zeepay':
        walletType = WalletType.Zeepay;
      default:
        break;
    }
  }

  void checkout() {
    if (!(viewModel.merchantRequiresKyc == true)) {
      _checkUserVerificationDetails();
    } else {
      if (walletType == WalletType.Momo ||
          walletType == WalletType.Zeepay ||
          walletType == WalletType.Hubtel) {
        payWithMomo();
      }

      if (walletType == WalletType.GMoney) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewMandateIdScreen(
              momoRequest: getCheckoutRequest(),
            ),
          ),
        );
      }

      if (walletType == WalletType.Card) {
        _setup();
      }

      if (walletType == WalletType.BankPay) {
        print(walletType);
        payWithMomo();
      }
    }
  }

  _checkUserVerificationDetails() async {
    widget.showLoadingDialog(
        context: context, text: CheckoutStrings.pleaseWait);

    final result = await viewModel.checkVerificationStatus(
        mobileNumber: selectedWallet?.accountNo ?? '');

    if (!mounted) return;

    Navigator.pop(context);

    if (result.state == UiState.success) {
      switch (result.data?.getVerificationStatus()) {
        case VerificationStatus.verified:
          payWithMomo();
        default:
          final navigatorResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GhanaCardVerificationScreen(
                verificationResponse: result.data,
              ),
            ),
          );

          if (navigatorResult == true) {
            payWithMomo();
          }
      }
    } else {
      //TODO: Go and intake Ghana card Details.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddGhCardScreen(
            mobileNumber: selectedWallet?.accountNo ?? '',
          ),
        ),
      );
    }
  }

  _setup() async {
    final (String? expiryMonth, String? expiryYear) =
        newCardExpiry?.getExpiryInfo() ?? (null, null);

    final dsRequest = SetupPayerAuthRequest(
      amount: 1.00,
      cardHolderName: '',
      cardNumber: newCardNumber ?? '',
      cvv: newCardCvv ?? '',
      expiryMonth: expiryMonth ?? '',
      expiryYear: expiryYear ?? '',
      customerMsisdn: CheckoutRequirements.customerMsisdn,
      description: widget.checkoutPurchase.purchaseDescription,
      clientReference: widget.checkoutPurchase.clientReference,
      callbackUrl: 'https://9cb7-154-160-1-110.ngrok-free.app/payment-callback',
    );

    widget.showLoadingDialog(
      context: context,
      text: CheckoutStrings.pleaseWait,
    );

    final apiResult = await viewModel.setup(request: dsRequest);

    if (!context.mounted) return;

    if (apiResult.state == UiState.success) {
      widget.accessToken = apiResult.data?.accessToken ?? '';
      widget.threeDsResponse = apiResult.data ?? Setup3dsResponse();

      setState(() {
        showWebView = true;

        controller.loadHtmlString(
          CheckoutStrings.makeHtmlString(
            widget.accessToken ?? '',
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

  _checkoutInstantServiceWithBankCard(BuildContext context) async {
    final result = await viewModel.enroll(
        transactionId: widget.threeDsResponse?.transactionId ?? '');

    if (!mounted) return;
    if (result.state == UiState.success) {
      Navigator.pop(context);

      final webViewCheckoutData = WebCheckoutPageData(
          jwt: result.data?.jwt ?? '',
          orderId: '',
          reference: '',
          customData: result.data?.customData ?? '');

      final onBankCallbackReceived = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CheckoutWebViewWidget(pageData: webViewCheckoutData)));

      if (onBankCallbackReceived == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckStatusScreen(
              checkoutResponse: MomoResponse(
                  transactionId: widget.threeDsResponse?.transactionId,
                  clientReference: widget.threeDsResponse?.clientReference),
              checkoutCompleted: widget.checkoutCompleted,
            ),
          ),
        );
      }
    } else {
      Navigator.pop(context);

      widget.showErrorDialog(
        context: context,
        message: result.message,
      );
    }
  }

  void onCheckoutCompleted(MomoResponse? momoResponse, BuildContext context) {
    if (walletType == WalletType.Momo) {
      widget.showPromptDialog(
          context: context,
          title: CheckoutStrings.success,
          buttonTitle: CheckoutStrings.okay,
          subtitle: CheckoutStrings.getPaymentPromptMessage(
              walletNumber: selectedWallet?.accountNo ?? ''),
          buttonAction: () {
            Navigator.pop(context);
            // Goto Transaction Status Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckStatusScreen(
                  checkoutResponse: momoResponse ?? MomoResponse(),
                  checkoutCompleted: widget.checkoutCompleted,
                  themeConfig: widget.themeConfig,
                ),
              ),
            );
          });
    } else if (walletType == WalletType.BankPay) {
      print('Fetching logo ${viewModel.channelResponse?.businessLogoUrl}');
      final businessRequirements = HtmlRequirements(
          imageUrl: CheckoutViewModel?.channelFetch?.businessLogoUrl ?? '',
          clientName: momoResponse?.customerName ?? '',
          customerMsisdn: momoResponse?.customerMsisdn ?? '',
          slipId: momoResponse?.invoiceNumber ?? '',
          email: momoResponse?.email ?? '',
          businessName: CheckoutViewModel?.channelFetch?.businessName ?? '');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BankPayReceiptScreen(
                  mobileMoneyResponse: momoResponse ?? MomoResponse(),
                  businessDetails: businessRequirements)));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckStatusScreen(
            checkoutResponse: momoResponse ?? MomoResponse(),
            checkoutCompleted: widget.checkoutCompleted,
            themeConfig: widget.themeConfig,
          ),
        ),
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
      print('from Backendc ${checkoutResponse.toString()}');
      onCheckoutCompleted(result.data, context);
    } else {
      widget.showErrorDialog(context: context, message: result.message);
    }
  }

  MobileMoneyPaymentRequest getCheckoutRequest() {
    if (walletType == WalletType.Momo) {
      if (CheckoutViewModel.checkoutType == CheckoutType.receivemoneyprompt) {
        return MobileMoneyPaymentRequest(
            customerName: '',
            customerMsisdn: selectedWallet?.accountNo ?? '',
            channel: selectedProvider?.receiveMoneyPromptValue ?? '',
            amount: '${widget.checkoutPurchase?.amount ?? 0.00}',
            primaryCallbackUrl: '',
            description: '',
            clientReference: widget.checkoutPurchase.clientReference,
            mandateId: '');
      } else if (CheckoutViewModel.checkoutType == CheckoutType.directdebit) {
        return MobileMoneyPaymentRequest(
            customerName: '',
            customerMsisdn: selectedWallet?.accountNo ?? '',
            channel: selectedProvider?.directDebitValue ?? '',
            amount: '${widget.checkoutPurchase?.amount ?? 0.00}',
            primaryCallbackUrl: '',
            description: '',
            clientReference: widget.checkoutPurchase.clientReference,
            mandateId: '');
      }
    } else if (walletType == WalletType.Hubtel) {
      final hubtelWallet = wallets
          .firstWhere((element) => element.provider?.toLowerCase() == 'hubtel');
      return MobileMoneyPaymentRequest(
          customerName: '',
          customerMsisdn: hubtelWallet?.accountNo ?? '',
          channel: 'hubtel-gh',
          amount: '${widget.checkoutPurchase?.amount ?? 0.00}',
          primaryCallbackUrl: '',
          description: '',
          clientReference: widget.checkoutPurchase.clientReference,
          mandateId: '');
    } else if (walletType == WalletType.GMoney) {
      return MobileMoneyPaymentRequest(
          customerName: '',
          customerMsisdn: selectedWallet?.accountNo ?? '',
          channel: 'g-money',
          amount: '${widget.checkoutPurchase?.amount ?? 0.00}',
          primaryCallbackUrl: '',
          description: '',
          clientReference: widget.checkoutPurchase.clientReference,
          mandateId: '');
    } else if (walletType == WalletType.Zeepay) {
      return MobileMoneyPaymentRequest(
          customerName: '',
          customerMsisdn: selectedWallet?.accountNo ?? '',
          channel: 'zeepay',
          amount: '${widget.checkoutPurchase?.amount ?? 0.00}',
          primaryCallbackUrl: CheckoutRequirements.callbackUrl,
          description: widget.checkoutPurchase?.purchaseDescription ?? '',
          clientReference: widget.checkoutPurchase.clientReference,
          mandateId: '');
    } else if (walletType == WalletType.BankPay) {
      return MobileMoneyPaymentRequest(
          customerName: '',
          customerMsisdn: CheckoutRequirements.customerMsisdn,
          channel: 'bankpay',
          amount: '${widget.checkoutPurchase?.amount ?? 0.00}',
          primaryCallbackUrl: CheckoutRequirements.callbackUrl,
          description: widget.checkoutPurchase?.purchaseDescription ?? '',
          clientReference: widget.checkoutPurchase.clientReference,
          mandateId: '');
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

class _CheckoutHomeState {
  final ValueNotifier<double?> _checkoutFees = ValueNotifier(null);
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingFees = ValueNotifier(false);
  final ValueNotifier<String> _selectedChannel = ValueNotifier('Hubtel');
  final ValueNotifier<bool> _isNewMandateChecked = ValueNotifier(false);

  ValueNotifier<double?> get checkoutFees => _checkoutFees;

  ValueNotifier<bool> get isButtonEnabled => _isButtonEnabled;

  ValueNotifier<bool> get isLoadingFees => _isLoadingFees;

  ValueNotifier<String> get selectedChannel => _selectedChannel;

  ValueNotifier<bool> get isNewMandateChecked => _isNewMandateChecked;

  onNewMandateCheckChanged(bool? value) {
    _isNewMandateChecked.value = value!;
  }
}
