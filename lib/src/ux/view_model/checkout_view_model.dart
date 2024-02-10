import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/channel_change_ui_logic.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/otp_request_body.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/otp_request_response.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/otp_response_obj.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/verify_otp_response.dart';

import '/src/core_storage/core_storage.dart';
import '/src/network_manager/network_manager.dart';
import '/src/platform/datasource/api/checkout_api.dart';
import '/src/platform/models/models.dart';

class CheckoutViewModel extends ChangeNotifier {
  final requester = Requester();

  final prefManager = CheckoutPrefManager();

  ChannelFetchResponse? channelResponse;

  static ChannelFetchResponse? channelFetch;

  static CheckoutType? checkoutType;

  bool? cardCheckoutCompletionStatus;

  bool? merchantRequiresKyc;

  List<Wallet>? wallets;

  late List<String>? channels;

  int verifyOtpAttempts = 0;

  final List<MomoProvider> providers = [
    MomoProvider(
        name: 'MTN Mobile Money',
        logoUrl: '',
        alias: 'mtn',
        receiveMoneyPromptValue: 'mtn-gh',
        preapprovalConfirmValue: '',
        directDebitValue: 'mtn-gh-direct-debit'),
    MomoProvider(
        name: 'Vodafone Cash',
        logoUrl: '',
        alias: 'vodafone',
        receiveMoneyPromptValue: 'vodafone-gh',
        preapprovalConfirmValue: '',
        directDebitValue: 'vodafone-gh-direct-debit'),
    MomoProvider(
        name: 'AT Money',
        logoUrl: '',
        alias: 'airtelTigo',
        receiveMoneyPromptValue: 'tigo-gh',
        preapprovalConfirmValue: '',
        directDebitValue: 'tigo-gh-direct-debit'),
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

  Future<UiResult<ChannelFetchResponse>> fetchChannels() async {
    final result = await _checkoutApi.fetchChannels();

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      channelResponse = result.response?.data;

      merchantRequiresKyc = result.response?.data?.requireNationalID;

      log('fetched channels ${channelResponse?.businessLogoUrl}',
          name: '$runtimeType');
      CheckoutViewModel.channelFetch = result.response?.data;
      notifyListeners();
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  // TODO: fetch wallets
  Future<UiResult<List<Wallet>>> fetchWallets() async {
    final result = await _checkoutApi.fetchWallets();

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      wallets = result.response?.data;

      notifyListeners();
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  // TODO: Fetch fees
  // TODO: Fetch fees
  Future<UiResult<NewGetFeesResponse>> fetchFees(
      {required String channel,
      required double amount,
      required String clientReference,
      String? cardNumber}) async {
    final result = await _checkoutApi.fetchFees(
        channel: channel,
        amount: amount,
        clientReference: clientReference,
        cardNumber: cardNumber,
        customerMsisdn: CheckoutRequirements.customerMsisdn);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      notifyListeners();
      CheckoutViewModel.checkoutType = result.response?.data?.getCheckoutType();
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: Make Receive Money Payment Prompt.
  Future<UiResult<MomoResponse>> payWithMomo(
      {required MobileMoneyPaymentRequest req}) async {
    final result = await _checkoutApi.payWithMomo(req: req);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(
        state: UiState.success,
        message: 'Success',
        data: data,
      );
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: Check PaymentStatus here
  Future<UiResult<CheckoutOrderStatus>> checkStatus(
      {required String clientReference}) async {
    final result =
        await _checkoutApi.checkStatus(clientReference: clientReference);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  ///TODO: ADD DIRECTDEBIT API
  Future<UiResult<MomoResponse>> makeDirectDebitRequest(
      {required MobileMoneyPaymentRequest request}) async {
    final result = await _checkoutApi.makeDirectDebitRequest(request: request);
    if (result.apiResult == ApiResult.Success) {
      return UiResult(
          state: UiState.success,
          message: 'Success',
          data: result.response?.data);
    } else {
      return UiResult(
          state: UiState.error,
          message: result?.response?.message ?? "",
          data: null);
    }
  }

  //TODO Setup Device for bank card Payments
  Future<UiResult<Setup3dsResponse>> setup(
      {required SetupPayerAuthRequest request}) async {
    final result = await _checkoutApi.setupDevice(request: request);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  Future<UiResult<Setup3dsResponse>> setupAccessBank(
      {required SetupPayerAuthRequest request}) async {
    final result = await _checkoutApi.setupDeviceAccessBank(request: request);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO make enrollment request in sdk
  Future<UiResult<Enroll3dsResponse>> enroll(
      {required String transactionId}) async {
    final result =
        await _checkoutApi.enrollmentAccessBank(transactionId: transactionId);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: Make enrollment with access bank endpoint
  Future<UiResult<Enroll3dsResponse>> enrollAccessBank(
      {required String transactionId}) async {
    final result =
        await _checkoutApi.enrollmentAccessBank(transactionId: transactionId);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: make call to add mobile wallet to sdk
  Future<UiResult<Wallet>> addWallet({required AddMobileWalletBody req}) async {
    final result = await _checkoutApi.addWallet(req: req);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(
          state: UiState.success,
          message: result.response?.message ?? '',
          data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: make call to check verification status of customer
  Future<UiResult<VerificationResponse>> checkVerificationStatus(
      {required String mobileNumber}) async {
    final result =
        await _checkoutApi.checkVerificationStatus(mobileNumber: mobileNumber);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: make call to intake Ghana Card details confirmation.
  Future<UiResult<VerificationResponse>> intakeIdDetails(
      {required IDVerificationBody params}) async {
    final result = await _checkoutApi.intakeUserIdentification(params: params);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  Future<UiResult<PreApprovalResponse>> makePreApprovalConfirm(
      {required PreapprovalConfirm params}) async {
    final result = await _checkoutApi.preApprovalConfirm(params: params);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: Make otpRequest
  Future<UiResult<OtpResponse>> verifyOtp(
      {required OtpBodyRequest request}) async {
    final result = await _checkoutApi.verifyOtp(otpRequest: request);

    if (result.apiResult == ApiResult.Success) {
      final data = result.response?.data;
      return UiResult(state: UiState.success, message: 'Success', data: data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: Logo to show Momo Field
  ChannelsUpdateObj getPaymentChannelsUI() {
    final showMomoField = (CheckoutViewModel.channelFetch?.channels
                ?.contains("mtn-gh") ??
            false) ||
        (CheckoutViewModel.channelFetch?.channels?.contains("vodafone-gh") ??
            false) ||
        (CheckoutViewModel.channelFetch?.channels?.contains("tigo-gh") ??
            false);

    final showBankField = (CheckoutViewModel.channelFetch?.channels
                ?.contains("cardnotpresent-visa") ??
            false) ||
        (CheckoutViewModel.channelFetch?.channels
                ?.contains("cardnotpresent-mastercard") ??
            false);
    final showOtherPaymentMethods =
        (CheckoutViewModel.channelFetch?.channels?.contains("hubtel-gh") ??
                false) ||
            (CheckoutViewModel.channelFetch?.channels?.contains("zeepay") ??
                false) ||
            (CheckoutViewModel.channelFetch?.channels?.contains("g-money") ??
                false);

    final showBankPayOptions =
        (CheckoutViewModel.channelFetch?.channels?.contains("bankpay") ??
            false);
    print('bankPayOption - $showBankPayOptions');

    return ChannelsUpdateObj(
      showBankField: showBankField,
      showBankPayField: showBankPayOptions,
      showOtherPaymentsField: showOtherPaymentMethods,
      showMomoField: showMomoField,
    );
  }

  //TODO: Get OTP
  Future<UiResult<OtpRequestResponse>> getOtp(
      {required OtpRequestBody requestBody}) async {
    final result = await _checkoutApi.getOtp(requestBody: requestBody);

    if (result.apiResult == ApiResult.Success) {
      return UiResult(
          state: UiState.success,
          message: "Success",
          data: result.response?.data);
    }
    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? '',
        data: null);
  }

  //TODO: VerifyOtp
  Future<UiResult<OtpRequestResponse>> verifyMomoOtp(
      {required VerifyOtpBody requestBody}) async {
    final result = await _checkoutApi.verifyMomoOtp(requestBody: requestBody);
    if (result.apiResult == ApiResult.Success) {
      return UiResult(
          state: UiState.success,
          message: "Success",
          data: result.response?.data);
    }

    return UiResult(
        state: UiState.error,
        message: result.response?.message ?? "",
        data: null);
  }

  Wallet? showHubtelActionString() {
    if (CheckoutViewModel.channelFetch?.channels?.contains("hubtel-gh") ??
        false) {
      return Wallet(
          externalId: "0011",
          accountNo: "",
          accountName: "Hubtel",
          providerId: "providerId",
          provider: "hubtel-gh",
          type: "type");
    }
    return null;
  }

  Wallet? showZeePayActionsString() {
    if (CheckoutViewModel.channelFetch?.channels?.contains("zeepay") ?? false) {
      return Wallet(
          externalId: "0011",
          accountNo: "0556236739",
          accountName: "Zeepay",
          providerId: "providerId",
          provider: "zeepay",
          type: "type");
    }
    return null;
  }

  Wallet? showGmoneyActionsString() {
    if (CheckoutViewModel.channelFetch?.channels?.contains("g-money") ??
        false) {
      return Wallet(
          externalId: "",
          accountNo: "",
          accountName: "GMoney",
          providerId: "providerId",
          provider: "g-money",
          type: "type");
    }

    return null;
  }

  List<Wallet> getPaymentTypes() {
    final walletTypes = [
      showHubtelActionString(),
      showZeePayActionsString(),
      showGmoneyActionsString()
    ];
    final List<Wallet> nonNullList = walletTypes
        .where((walletType) => walletType != null)
        .map<Wallet>((e) => e!)
        .toList();
    return nonNullList;
  }
}
