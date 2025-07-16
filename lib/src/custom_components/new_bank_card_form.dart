import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core_ui/core_ui.dart';
import '../resources/resources.dart';
import '../utils/utils.dart';
import 'ccontainer.dart';

class NewBankCardForm extends StatefulWidget {
  const NewBankCardForm({
    super.key,
    required this.onCardSaveChecked,
    required this.onNewCardNumberChanged,
    required this.onNewCardDateChanged,
    required this.onNewCardCvvChanged,
    required this.formKey,
    required this.cardNumberInputController,
    required this.cardDateInputController,
    required this.cardCvvInputController,
  });

  final TextEditingController cardNumberInputController;
  final TextEditingController cardDateInputController;
  final TextEditingController cardCvvInputController;

  final void Function(bool?) onCardSaveChecked;
  final void Function(String)? onNewCardNumberChanged;
  final void Function(String)? onNewCardDateChanged;
  final void Function(String)? onNewCardCvvChanged;
  final GlobalKey<FormState> formKey;

  @override
  State<NewBankCardForm> createState() => _NewBankCardFormState();
}

class _NewBankCardFormState extends State<NewBankCardForm> {
  bool saveCardForFuture = false;
  String cardNumber = "";
  final FocusNode cardNumberFocusNode = FocusNode();
  final FocusNode cvvFocusNode = FocusNode();
  final FocusNode expiryFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    [cardNumberFocusNode, cvvFocusNode, expiryFocusNode].forEach((el){
      el.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          InputField(
            controller: widget.cardNumberInputController,
            hasFill: true,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 16) {
                return CheckoutStrings.invalidCardNumber;
              }
              return null;
            },
            onChanged: (val) {
              setState(() {
                cardNumber = val;
              });
              widget.onNewCardNumberChanged?.call(val);
              if (val.trim().length == 22){
                FocusScope.of(context).requestFocus(expiryFocusNode);
              }
            },
            hintText: CheckoutStrings.bankCardHintText,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              CardNumberInputFormatter(),
            ],
            inputType: const TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            suffixWidget: (cardNumber.startsWith("4") && cardNumber.length >= 3)
                ? CContainer(
                    padding: onlySidePad(right: Dimens.paddingDefault),
                    child: AppImageWidget.local(
                      image: const AssetImage(CheckoutDrawables.visa),
                      width: Dimens.iconMedium,
                      height: Dimens.iconSmall,
                      boxFit: BoxFit.contain,
                      borderRadius: 0,
                    ),
                  )
                : (cardNumber.startsWith("5") && cardNumber.length >= 3)
                    ? CContainer(
                        padding: onlySidePad(right: Dimens.paddingDefault),
                        child: AppImageWidget.local(
                          image: const AssetImage(CheckoutDrawables.masterCard),
                          width: Dimens.iconMedium,
                          height: Dimens.iconSmall,
                          boxFit: BoxFit.contain,
                          borderRadius: 0,
                        ),
                      )
                    : SizedBox.shrink(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(Dimens.inputBorderRadius),
            ),
            // contentPadding: symmetricPad(
            //   horizontal: AppDimens.paddingDefault,
            // ),
          ),
          const SizedBox(height: Dimens.paddingDefault),
          Row(
            children: [
              Expanded(
                child: InputField(
                  node: expiryFocusNode,
                  controller: widget.cardDateInputController,
                  hasFill: true,
                  hintText: CheckoutStrings.monthAndYearBankHint,
                  inputType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    CardExpiryFormatter(),
                  ],
                  onChanged: (val) {
                    if (val.trim().length == 5){
                      FocusScope.of(context).requestFocus(cvvFocusNode);
                    }
                    widget.onNewCardDateChanged?.call(val);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5)
                      return CheckoutStrings.invalidDateFormat;
                    return null;
                  },
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(Dimens.inputBorderRadius),
                  ),
                  // contentPadding: symmetricPad(
                  //   horizontal: AppDimens.paddingDefault,
                  // ),
                ),
              ),
              const SizedBox(width: Dimens.paddingDefault),
              Expanded(
                child: InputField(
                  node: cvvFocusNode,
                  isPassword: true,
                  maxLines: 1,
                  controller: widget.cardCvvInputController,
                  hasFill: true,
                  hintText: CheckoutStrings.cvv,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  inputType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  onChanged: widget.onNewCardCvvChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return CheckoutStrings.invalidCardCvv;
                    }
                    return null;
                  },
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(Dimens.inputBorderRadius),
                  ),
                  // contentPadding: symmetricPad(
                  //   horizontal: AppDimens.paddingDefault,
                  // ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.paddingDefault),
          GestureDetector(
            onTap: () {
              setState(() {
                saveCardForFuture = !saveCardForFuture;
                widget.onCardSaveChecked(saveCardForFuture);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(CheckoutStrings.saveCardForFuture,
                    style: AppTextStyle.body2()),

                CContainer(
                  padding: symmetricPad(
                    horizontal: Dimens.paddingDefaultMini,
                    vertical: Dimens.paddingDefaultMini,
                  ),
                  borderRadius: BorderRadius.circular(
                    Dimens.defaultBorderRadiusLarge,
                  ),
                  width: Dimens.radioButtonSize,
                  color: saveCardForFuture
                      ? ThemeConfig.themeColor
                      : HubtelColors.neutral.shade400,
                  child: AnimatedToggleSwitch<bool>.dual(
                      current: saveCardForFuture,
                      first: false,
                      second: true,
                      height: Dimens.defaultIconNormal,
                      indicatorSize: const Size(
                        Dimens.defaultIconNormal,
                        Dimens.defaultIconNormal,
                      ),
                      style: ToggleStyle(
                        borderColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        indicatorColor: HubtelColors.neutral.shade50,
                        indicatorBorderRadius: BorderRadius.circular(
                          Dimens.defaultStoreItemCardWidth,
                        ),
                      ),
                      spacing: 0,
                      onChanged: (value) {
                        setState(() {
                          saveCardForFuture = value;
                          widget.onCardSaveChecked(value);
                        });
                      }),
                ),
                // Checkbox(
                //   value: saveCardForFuture,
                //   onChanged: (value) {
                //     setState(() {
                //       saveCardForFuture = value ?? false;
                //       widget.onCardSaveChecked(value);
                //     });
                //   },
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
