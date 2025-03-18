import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/extensions/widget_extensions.dart';
import 'package:hubtel_merchant_checkout_sdk/src/resources/checkout_strings.dart';
import 'package:provider/provider.dart';

import '../../core_ui/core_ui.dart';
import '../../network_manager/network_manager.dart';
import '../../platform/models/models.dart';
import '../view_model/checkout_view_model.dart';
import 'checkout_home_screen.dart';

enum CheckoutPaymentStatus { success, cancelled }

class CheckoutScreen extends StatefulWidget {
  final String? accessToken = '';

  // late final Function(CheckoutPaymentStatus)? checkoutCompleted;

  late final PurchaseInfo purchaseInfo;

  late final HubtelCheckoutConfiguration configuration;

  late final ThemeConfig? themeConfig;


  late final List<BankCardData>? savedBankCards;

  final viewModel = CheckoutViewModel();



  // late final Function(PaymentStatus) onCheckoutComplete;

  Color? _primaryColor;

  CheckoutScreen({
    Key? key,
    required this.purchaseInfo,
    required this.configuration,
    this.savedBankCards,
    this.themeConfig,
  }) : super(key: key) {
    CheckoutRequirements.customerMsisdn = purchaseInfo.customerMsisdn;
    CheckoutRequirements.apiKey = configuration.merchantApiKey;
    CheckoutRequirements.merchantId = configuration.merchantID;
    CheckoutRequirements.callbackUrl = configuration.callbackUrl;
  }

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<UiResult<ChannelFetchResponse>>? result;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onNewCardInputComplete() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     result = widget.viewModel.fetchChannels();
  }



  @override
  Widget build(BuildContext context) {
    ThemeConfig.themeColor = widget.themeConfig!.primaryColor;
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CheckoutViewModel())],
      child: Container(
        color: Colors.white,
        child: FutureBuilder<UiResult<ChannelFetchResponse>>(
          future: result,
          builder: (context,
              AsyncSnapshot<UiResult<ChannelFetchResponse>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: ThemeConfig.themeColor,
              ));
            } else {
              if (snapshot.hasData) {
                print("Here ${snapshot.data?.state}");
                final businessInfo = snapshot.data?.data?.getBusinessInfo() ??
                    BusinessInfo(
                      businessName: 'businessName',
                      businessImageUrl: 'businessImageUrl',
                    );
                if (snapshot.data?.state == UiState.success){
                  return CheckoutHomeScreen(
                    checkoutPurchase: widget.purchaseInfo,
                    businessInfo: businessInfo,
                    themeConfig: widget.themeConfig ??
                        ThemeConfig(
                          primaryColor: HubtelColors.teal,
                        ),
                    savedBankCards: widget.savedBankCards,
                  );
                }else{
                  return getErrorDialog(message: "Something went wrong while configuring business", context: context);
                }


              }
            }
            return Center(
              child: CircularProgressIndicator(
                  color: ThemeConfig.themeColor,
                  backgroundColor: Colors.teal[500]),
            );
          },
        ),
      ),
    );
  }
}


