import 'dart:io';

import 'package:hubtel_merchant_checkout_sdk/src/platform/models/otp_request_body.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/otp_request_response.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/otp_response_obj.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/verify_otp_response.dart';

import '../../../network_manager/network_manager.dart';
import '../../models/models.dart';

class CheckoutApi extends ApiCore {
  CheckoutApi({required super.requester});

  Future<ResultWrapper<ChannelFetchResponse>> fetchChannels() async {
    final response = await requester.makeRequest(
      apiEndPoint: endPoints.checkoutEndPoint.fetchChannels(),
    );

    print(response);
    final data = DataResponse<ChannelFetchResponse>.fromJson(
        response.response, (x) => ChannelFetchResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: response.apiResult);
  }

  Future<ListResultWrapper<Wallet>> fetchWallets() async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint.fetchWallets());
    final data = DataResponseList<Wallet>.fromJson(
        result.response, (x) => Wallet.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<NewGetFeesResponse>> fetchFees(
      {required String channel,
      required double amount,
      required String clientReference,
      required String customerMsisdn,
      String? cardNumber}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint.fetchFees(
            channel: channel,
            amount: amount,
            customerMsisdn: customerMsisdn,
            clientReference: clientReference));

    final data = DataResponse<NewGetFeesResponse>.fromJson(
      result.response,
      (x) => NewGetFeesResponse.fromJson(x),
    );

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<MomoResponse>> payWithMomo(
      {required MobileMoneyPaymentRequest req}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint.getReceiveMoneyEndpoint(req));
    final data = DataResponse<MomoResponse>.fromJson(
        result.response, (x) => MomoResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<CheckoutOrderStatus>> checkStatus(
      {required String clientReference}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint
            .checkStatus(clientReference: clientReference));
    final data = DataResponse<CheckoutOrderStatus>.fromJson(
        result.response, (x) => CheckoutOrderStatus.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<Setup3dsResponse>> setupDevice(
      {required SetupPayerAuthRequest request}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint
            .setupDeviceForBankPayment(requestBody: request));
    final data = DataResponse<Setup3dsResponse>.fromJson(
        result.response, (x) => Setup3dsResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<Setup3dsResponse>> setupDeviceAccessBank(
      {required SetupPayerAuthRequest request}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint
            .setupDeviceForBankPaymentAccessBank(requestBody: request));
    final data = DataResponse<Setup3dsResponse>.fromJson(
        result.response, (x) => Setup3dsResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<Enroll3dsResponse>> enroll(
      {required String transactionId}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint
            .makeEnrollment(transactionId: transactionId));
    final data = DataResponse<Enroll3dsResponse>.fromJson(
        result.response, (x) => Enroll3dsResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<Enroll3dsResponse>> enrollmentAccessBank(
      {required String transactionId}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint
            .makeEnrollmentAccessBank(transactionId: transactionId));
    final data = DataResponse<Enroll3dsResponse>.fromJson(
        result.response, (x) => Enroll3dsResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<Wallet>> addWallet(
      {required AddMobileWalletBody req}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint.addMobileWallet(request: req));
    final data = DataResponse<Wallet>.fromJson(
        result.response, (x) => Wallet.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<VerificationResponse>> checkVerificationStatus(
      {required String mobileNumber}) async {
    final result = await requester.makeRequest(
        apiEndPoint: endPoints.checkoutEndPoint
            .checkUserVerification(mobileNumber: mobileNumber));

    final data = DataResponse<VerificationResponse>.fromJson(
        result.response, (x) => VerificationResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<VerificationResponse>> intakeUserIdentification(
      {required IDVerificationBody params}) async {
    final result = await requester.makeRequest(
        apiEndPoint:
            endPoints.checkoutEndPoint.intakeUserInput(params: params));

    final data = DataResponse<VerificationResponse>.fromJson(
        result.response, (x) => VerificationResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<PreApprovalResponse>> preApprovalConfirm(
      {required PreapprovalConfirm params}) async {
    final result = await requester.makeRequest(
        apiEndPoint:
            endPoints.checkoutEndPoint.getPreApprovalConfirmEndPoint(params));

    final data = DataResponse<PreApprovalResponse>.fromJson(
        result.response, (x) => PreApprovalResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<OtpResponse>> verifyOtp(
      {required OtpBodyRequest otpRequest}) async {
    final result = await requester.makeRequest(
        apiEndPoint:
            endPoints.checkoutEndPoint.otpVerification(request: otpRequest));

    final data = DataResponse<OtpResponse>.fromJson(
        result.response, (x) => OtpResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<OtpRequestResponse>> getOtp(
      {required OtpRequestBody requestBody}) async {
    final result = await requester.makeRequest(
        apiEndPoint:
            endPoints.checkoutEndPoint.getOtp(requestBody: requestBody));

    final data = DataResponse<OtpRequestResponse>.fromJson(
        result.response, (x) => OtpRequestResponse.fromJson(x));

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  Future<ResultWrapper<OtpRequestResponse>> verifyMomoOtp(
      {required VerifyOtpBody requestBody}) async {
    final result = await requester.makeRequest(
        apiEndPoint:
            endPoints.checkoutEndPoint.verifyOtp(request: requestBody));
    final data = DataResponse<OtpRequestResponse>.fromJson(
        result.response, (x) => OtpRequestResponse.fromJson(x));
    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }

  @override
  Future<ResultWrapper<MomoResponse>> makeDirectDebitRequest(
      {required MobileMoneyPaymentRequest request}) async {
    final result = await requester.makeRequest(
        apiEndPoint:
            endPoints.checkoutEndPoint.getDirectDebitEndPoint(request));
    final data = DataResponse<MomoResponse>.fromJson(
      result.response,
      (x) => MomoResponse.fromJson(x),
    );

    return BaseApiResponse(response: data, apiResult: result.apiResult);
  }
}
