import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/src/extensions/widget_extensions.dart';
import '/src/ux/view_model/checkout_view_model.dart';

import '../../core_ui/core_ui.dart';
import '../../network_manager/network_manager.dart';
import '../../platform/models/models.dart';
import '../../resources/resources.dart';
import 'gh_card_verification_screen.dart';

class AddGhCardScreen extends StatefulWidget {
  String mobileNumber;

  AddGhCardScreen({super.key, required this.mobileNumber});

  @override
  State<AddGhCardScreen> createState() => _AddGhCardScreenState();
}

class _AddGhCardScreenState extends State<AddGhCardScreen> {
  final _cardController = TextEditingController();

  late final state = _AddGhCardState();

  final viewModel = CheckoutViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(
        title: 'Verification',
        bottomNavigation: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: ValueListenableBuilder(
            builder: (context, uiModel, child) => CustomButton(
              title: 'Submit'.toUpperCase(),
              isEnabled: state.value.isButtonEnabled,
              buttonAction: () => _performVerificationDetailsCheck(context),
              loading: state.value.isButtonLoading,
              isDisabledBgColor: HubtelColors.lighterGrey,
              disabledTitleColor: HubtelColors.grey,
              style: HubtelButtonStyle.solid,
              isEnabledBgColor: ThemeConfig.themeColor,
            ),
            valueListenable: state.ghCardState,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimens.paddingDefault),
                Center(child: SvgPicture.asset(CheckoutDrawables.verifySvg)),
                const SizedBox(height: Dimens.paddingDefault),
                Center(
                  child: Text(
                    'Verify your Government ID',
                    style: AppTextStyle.body2()
                        .copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimens.paddingDefault),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'A valid government-issued ID card is required to verify your account',
                      style: AppTextStyle.body2(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.paddingDefault),
                Text(
                  'Ghana Card',
                  style: AppTextStyle.body2(),
                ),
                const SizedBox(height: Dimens.paddingNano),
                InputField(
                  controller: _cardController,
                  hintText: CheckoutStrings.ghanaCardNumberHint,
                  onChanged: (value) {
                    state.onCardNumberChanged(value);
                  },
                  inputType: TextInputType.number,
                  // autofocus: true,
                  hasFill: true,
                  focusBorderColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _performVerificationDetailsCheck(BuildContext context) async {
    final verificationReqParams = IDVerificationBody.create(
        widget.mobileNumber ?? "", state.value.cardNumber);

    widget.showLoadingDialog(
        context: context, text: CheckoutStrings.pleaseWait);

    final result =
        await viewModel.intakeIdDetails(params: verificationReqParams);

    if (!mounted) return;

    Navigator.pop(context);

    if (result.state == UiState.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GhanaCardVerificationScreen(
            verificationResponse: result.data,
          ),
        ),
      );
    } else {
      widget.showErrorDialog(context: context, message: result.message, onOkayTap: (){Navigator.pop(context);});
    }
  }
}

class _AddGhCardState extends ValueNotifier<_AddGhCardUiModel> {
  _AddGhCardState() : super(_AddGhCardUiModel());

  onCardNumberChanged(String number) {
    value.cardNumber = number;
    value.isButtonEnabled = value.cardNumber.length >= 15;
    log(value.cardNumber, name: '$runtimeType');
    notifyListeners();
  }

  _AddGhCardState get ghCardState => this;
}

class _AddGhCardUiModel {
  String cardNumber = '';
  bool isButtonLoading = false;
  bool isButtonEnabled = false;
}
