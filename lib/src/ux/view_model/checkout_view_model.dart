import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core_storage/core_storage.dart';
import '../../network_manager/network_manager.dart';
import '../../platform/datasource/api/checkout_api.dart';
import '../../platform/models/models.dart';

class CheckoutViewModel extends ChangeNotifier {
  final requester = Requester();

  final prefManager = CheckoutPrefManager();

  ChannelFetchResponse? channelResponse;

  static ChannelFetchResponse? channelFetch;

  static CheckoutType? checkoutType;

  bool? cardCheckoutCompletionStatus;

  bool? merchantRequiresKyc;

  List<Wallet>? wallets;

  final List<MomoProvider> providers = [
    MomoProvider(
        name: "MTN Mobile Money",
        logoUrl: "",
        alias: "mtn",
        receiveMoneyPromptValue: "mtn-gh",
        preapprovalConfirmValue: "",
        directDebitValue: "mtn-gh-direct-debit"),
    MomoProvider(
        name: "Vodafone Cash",
        logoUrl: "",
        alias: "vodafone",
        receiveMoneyPromptValue: "vodafone-gh",
        preapprovalConfirmValue: "",
        directDebitValue: "vodafone-gh-direct-debit"),
    MomoProvider(
        name: "AT Money",
        logoUrl: "",
        alias: "airtelTigo",
        receiveMoneyPromptValue: "tigo-gh",
        preapprovalConfirmValue: "",
        directDebitValue: "tigo-gh-direct-debit"),
  ];

  Future<String?> getCustomerMandateId() async {
    return await prefManager.getMandateId();
  }

  Future<void> saveBankWallet(BankCardData card) async {
    prefManager.saveBankWallet(card);
  }

  Future<List<BankCardData>?> getBankWallets() async {
    return await prefManager.getBankCards();
  }

  late final CheckoutApi _checkoutApi = CheckoutApi(requester: requester);

  //TODO: fetch channels
  Future<UiResult<ChannelFetchResponse>> fetchChannels() async {
    final result = await _checkoutApi.fetchChannels();

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      channelResponse = result.response?.data;

      merchantRequiresKyc = result.response?.data?.requireNationalID;

      log('fetched channels ${channelResponse?.businessLogoUrl}',
          name: '$runtimeType');
      CheckoutViewModel.channelFetch = result.response?.data;
      log('${channelResponse?.isHubtelInternalMerchant}', name: '$runtimeType');
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
    log("called here");
    final result = await _checkoutApi.fetchWallets();

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      wallets = result.response?.data;
      log("wallets Count here ${wallets?.length}");
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

  Future<UiResult<VerificationResponse>> checkVerificationStatus(
      {required String mobileNumber}) async {
    final result =
        await _checkoutApi.checkVerificationStatus(mobileNumber: mobileNumber);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  //TODO: make call to intake Ghana Card details confirmation.
  Future<UiResult<VerificationResponse>> intakeIdDetails(
      {required IDVerificationBody params}) async {
    final result = await _checkoutApi.intakeUserIdentification(params: params);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  Future<UiResult<PreApprovalResponse>> makePreApprovalConfirm(
      {required PreapprovalConfirm params}) async {
    final result = await _checkoutApi.preApprovalConfirm(params: params);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: "Success", data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }
}