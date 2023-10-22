import 'dart:math';

import 'package:flutter/cupertino.dart';
import '../../network_manager/network_manager.dart';

import '../../platform/datasource/api/checkout_api.dart';
import '../../platform/models/models.dart';

class CheckoutViewModel extends ChangeNotifier {
  final requester = Requester();

  ChannelFetchResponse? channelResponse;

  static ChannelFetchResponse? channelFetch;

  static CheckoutType? checkoutType;

  bool? cardCheckoutCompletionStatus;

  bool? merchantRequiresKyc;

  List<Wallet>? wallets;

  final List<MomoProvider> providers = [
    MomoProvider(
        name: "MTN",
        logoUrl: "",
        alias: "mtn-gh",
        receiveMoneyPromptValue: "mtn-gh",
        preapprovalConfirmValue: "",
        directDebitValue: "mtn-gh-direct-debit"),
    MomoProvider(
        name: "Vodafone",
        logoUrl: "",
        alias: "vodafone",
        receiveMoneyPromptValue: "vodafone-gh",
        preapprovalConfirmValue: "",
        directDebitValue: "vodafone-gh-direct-debit"),
    MomoProvider(
        name: "Airtel Tigo",
        logoUrl: "",
        alias: "airtelTigo",
        receiveMoneyPromptValue: "tigo-gh",
        preapprovalConfirmValue: "",
        directDebitValue: "tigo-gh-direct-debit"),
  ];

  late final CheckoutApi _checkoutApi = CheckoutApi(requester: requester);

  // String getMomoChannelName(String? selectedProviderName) {
  //   final lowerCasedSelectedProviderName = selectedProviderName?.toLowerCase();
  //
  //   final isProviderMTN = lowerCasedSelectedProviderName
  //           ?.contains(CheckoutStrings.mtnShortString) ??
  //       false;
  //   final isProviderVodafone =
  //       lowerCasedSelectedProviderName?.contains(CheckoutStrings.vodafone) ??
  //           false;
  //   final isProviderAirtelTigo = lowerCasedSelectedProviderName
  //           ?.contains(RegExp(CheckoutStrings.atRegex)) ??
  //       false;
  //
  //   if (isProviderMTN) return CheckoutStrings.mtnGh;
  //   if (isProviderVodafone) return CheckoutStrings.vodafone_gh_ussd;
  //   if (isProviderAirtelTigo) return CheckoutStrings.tigoGh;
  //
  //   return '';
  // }

  //TODO: fetch channels
  Future<UiResult<ChannelFetchResponse>> fetchChannels() async {
    final result = await _checkoutApi.fetchChannels();

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      channelResponse = result.response?.data;

      merchantRequiresKyc = result.response?.data?.requireNationalID;

      print("fetched channels ${channelResponse?.businessLogoUrl}");
      CheckoutViewModel.channelFetch = result.response?.data;
      print(channelResponse?.isHubtelInternalMerchant);
      notifyListeners();
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO: fetch wallets

  Future<UiResult<List<Wallet>>> fetchWallets() async {
    print("called here");
    final result = await _checkoutApi.fetchWallets();

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      wallets = result.response?.data;
      print("wallets Count here ${wallets?.length}");
      notifyListeners();
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO: Fetch fees
  Future<UiResult<NewGetFeesResponse>> fetchFees(
      {required String channel, required double amount}) async {
    final result = await _checkoutApi.fetchFees(channel, amount);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      notifyListeners();
      CheckoutViewModel.checkoutType = result.response?.data?.getCheckoutType();
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO: Make Receive Money Payment Prompt.
  Future<UiResult<MomoResponse>> payWithMomo(
      {required MobileMoneyPaymentRequest req}) async {
    final result = await _checkoutApi.payWithMomo(req: req);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      print(result.response?.data?.amountCharged);
      return UiResult(
        state: UiState.success,
        message: "Success",
        data: data,
      );
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO: Check PaymentStatus here

  Future<UiResult<CheckoutOrderStatus>> checkStatus(
      {required String clientReference}) async {
    final result =
        await _checkoutApi.checkStatus(clientReference: clientReference);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO Setup Device for bank card Payments
  Future<UiResult<Setup3dsResponse>> setup(
      {required SetupPayerAuthRequest request}) async {
    final result = await _checkoutApi.setupDevice(request: request);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO make enrollment request in sdk
  Future<UiResult<Enroll3dsResponse>> enroll(
      {required String transactionId}) async {
    final result = await _checkoutApi.enroll(transactionId: transactionId);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO: make call to add mobile wallet to sdk
  Future<UiResult<Wallet>> addWallet({required AddMobileWalletBody req}) async {
    final result = await _checkoutApi.addWallet(req: req);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO: make call to check verification status of customer

  Future<UiResult<VerificationResponse>> checkVerificationStatus({required String mobileNumber }) async{

    final result = await _checkoutApi.checkVerificationStatus(mobileNumber: mobileNumber);

    if (result.apiResult == ApiResult.Success){
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(state: UiState.error, message: result.response?.message ?? "", data: null);
  }


  //TODO: make call to intake Ghana Card details confirmation.
  Future<UiResult<VerificationResponse>> intakeIdDetails({required IDVerificationBody params}) async{

    final result = await _checkoutApi.intakeUserIdentification(params: params);

    if (result.apiResult == ApiResult.Success){
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(state: UiState.error, message: result.response?.message ?? "", data: null);
  }
}
