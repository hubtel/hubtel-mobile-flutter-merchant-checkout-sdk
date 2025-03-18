
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/app_page.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/extensions/widget_extensions.dart';
import 'package:hubtel_merchant_checkout_sdk/src/network_manager/extensions/ui_state.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/models.dart';
import 'package:hubtel_merchant_checkout_sdk/src/platform/models/verify_otp_response.dart';
import 'package:hubtel_merchant_checkout_sdk/src/resources/checkout_drawables.dart';
import 'package:hubtel_merchant_checkout_sdk/src/resources/checkout_strings.dart';
import 'package:hubtel_merchant_checkout_sdk/src/utils/helpers/dialer_input.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/components/buttons.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/otp_screen/otp_input.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/otp_screen/validator_mixin.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/view_model/checkout_view_model.dart';
import 'package:provider/provider.dart';



class VerifyOTPPageData {
  String phoneNumber, requestId, prefix, clientReference, hubtelPreApprovalId;
  double amount;

  VerifyOTPPageData({
    required this.phoneNumber,
    required this.requestId,
    required this.prefix,
    required this.amount,
    required this.clientReference,
    required this.hubtelPreApprovalId
  });
}

class VerifyOtp extends StatefulWidget {
  final VerifyOTPPageData pageData;

  const VerifyOtp({Key? key, required this.pageData}) : super(key: key);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> with ValidatorMixin {

  late final CheckoutViewModel viewModel = CheckoutViewModel();

  var _otpState = UiResult(
    state: UiState.idle,
  );

  var _otp = "";
  final _idFormKey = GlobalKey<FormState>();

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Verify",
      titleStyle: AppTextStyle.headline2().copyWith(
        fontSize: Dimens.font18sp,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingDefault),
              child: Form(
                key: _idFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: Dimens.paddingLarge),
                        Center(
                          child: AppImageWidget.local(image: AssetImage(CheckoutDrawables.otpPng), width: 58, height: 53,),
                        ),
                        const SizedBox(height: Dimens.paddingLarge),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.paddingMedium,
                            ),
                            child: _verifyMsgText(
                              phoneNumber: widget.pageData.phoneNumber,
                              requestCode: widget.pageData.prefix,
                            ),
                          ),
                        ),
                        const SizedBox(height: 45.0),
                        OtpInput(
                          length: 4,
                          onSubmit: (String value) {
                            onSubmitOtp(otpString: value);
                            setState(() {
                              _otp = value;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: Dimens.paddingDefault,
                          ),
                          child: Visibility(
                            visible: _otpState.state == UiState.error,
                            child: Center(
                              child: Text(
                                _otpState.message,
                                style: AppTextStyle.caption()
                                    .copyWith(color: HubtelColors.errorColor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: Dimens.paddingDefault,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: HBButton(
                                  label: "Verify".toUpperCase(),
                                  onPressed: () {
                                    if (_isFormValid()) {
                                      setState(() {
                                        _otpState = UiResult(
                                          state: UiState.idle,
                                        );
                                      });
                                      _onSendOtp();
                                    } else {
                                      setState(() {
                                        _otpState = UiResult(
                                          state: UiState.error,
                                          message: otpValidate(_otp) ?? "",
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Dimens.paddingDefault,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.paddingNano,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  CheckoutDrawables.ghanaFlag,
                                  fit: BoxFit.fitWidth,
                                  width: 23,
                                  height: 23,
                                ),
                                _dialCodeText()
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verifyMsgText({
    required String phoneNumber,
    required String requestCode,
  }) {
    final TextStyle boldStyle = AppTextStyle.body1().copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    final List<TextSpan> textSpans = [
      TextSpan(
        text: "Enter the verification code sent to ",
        style: AppTextStyle.body1().copyWith(
          color: Colors.black,
        ),
      ),
      TextSpan(
        text: phoneNumber,
        style: boldStyle,
      ),
      TextSpan(
        text: " starting with ",
        style: AppTextStyle.body1().copyWith(
          color: Colors.black,
        ),
      ),
      TextSpan(
        text: requestCode,
        style: boldStyle,
      ),
    ];

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  Widget _dialCodeText() {
    final List<TextSpan> textSpans = [
      TextSpan(
        text: "Dial",
        style: AppTextStyle.body2(),
      ),
      TextSpan(
        text: CheckoutStrings.shortCode,
        style: AppTextStyle.body2().copyWith(
          color: HubtelColors.teal,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Utils.launchDialer(number: CheckoutStrings.shortCode);
          },
      ),
      TextSpan(
        text: CheckoutStrings.selectOption,
        style: AppTextStyle.body2(),
      ),
      TextSpan(
        text: CheckoutStrings.option_5,
        style: AppTextStyle.body2().copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: CheckoutStrings.seeCode,
        style: AppTextStyle.body2(),
      ),
    ];

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  bool _isFormValid() {
    if (otpValidate(_otp) == null) {
      return true;
    } else {
      return false;
    }
  }

  _onSendOtp() async {
    if (viewModel.verifyOtpAttempts == 3) {

      widget.showInfoDialog(
        context: context,
        message:
        'Looks like you have used up all your attempts to verify your number ${widget.pageData.phoneNumber}',
      );
      return;
    }

    widget.showLoadingDialog(
      context: context,
      text: "Verifying Otp",
    );

    final verifyOtpResponse = await viewModel.verifyOtp(request: OtpBodyRequest(customerMsisdn: widget.pageData.phoneNumber, hubtelPreApprovalId: widget.pageData.hubtelPreApprovalId, clientReferenceId: widget.pageData.clientReference, otpCode: _otp));
    //
    // await authViewModel.verifyOTP(
    //   otpRequest: OTPVerifyRequest(
    //     phoneNumber: widget.pageData.phoneNumber,
    //     requestId: widget.pageData.requestId,
    //     otpCode: "${widget.pageData.prefix}-$_otp",
    //   ),
    // );
    //
    if (!context.mounted) return;
    Navigator.pop(context);
    //
    if (verifyOtpResponse.state == UiState.error) {
      setState(() {
        _otpState = UiResult(
          state: UiState.error,
          message: "OTP verification Failed",
        );
      });
      return;
    }
    //
    if (verifyOtpResponse.state == UiState.success) {
      // Navigator.pushNamed(context, routeName)
      return;
    }
  }

   onSubmitOtp({required String otpString}) async{
    widget.showLoadingDialog(context: context, text: CheckoutStrings.pleaseWait);
    final submitOtpBody = VerifyOtpBody(requestId: widget.pageData.requestId, msisdn: widget.pageData.phoneNumber, otpCode: '${widget.pageData.prefix}-$otpString');
    final response = await viewModel.verifyMomoOtp(requestBody: submitOtpBody);
    if (!mounted) return;
    Navigator.pop(context);
    if (response.state == UiState.success){
      Navigator.pop(context, true);
    }else{
      widget.showErrorDialog(context: context, message: 'OTP verification failed. Try again', onOkayTap: (){Navigator.pop(context);});
    }
}
}
