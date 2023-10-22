import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../core_ui/core_ui.dart';
import '../platform/models/models.dart';
import '../resources/checkout_strings.dart';
import '../utils/bank_card_helper.dart';
import '../utils/helpers/edge_insets.dart';

class BankTileDropdown extends StatefulWidget {
  const BankTileDropdown({
    super.key,
    required this.fieldController,
    required this.cards,
    required this.hintText,
    required this.onCardSelected,
  });

  final TextEditingController fieldController;
  final List<CardData>? cards;
  final String hintText;
  final void Function(CardData) onCardSelected;

  @override
  State<BankTileDropdown> createState() => _BankTileDropdownState();
}

class _BankTileDropdownState extends State<BankTileDropdown> {
  bool expandOptions = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          hasFill: true,
          hintText: widget.hintText,
          controller: widget.fieldController,
          readOnly: true,
          suffixWidget: Padding(
            padding: const EdgeInsets.only(right: Dimens.paddingDefaultSmall),
            child: Icon(
              expandOptions == true
                  ? FlutterRemix.arrow_up_s_line
                  : FlutterRemix.arrow_down_s_line,
              color: HubtelColors.neutral.shade900,
            ),
          ),
          onTap: () {
            setState(() {
              expandOptions = !expandOptions;
            });
          },
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(Dimens.inputBorderRadius),
          ),
          // contentPadding: symmetricPad(
          //   horizontal: AppDimens.paddingDefault,
          // ),
        ),
        Visibility(
          visible: expandOptions && widget.cards?.isNotEmpty == true,
          child: Card(
            elevation: 7,
            shadowColor: HubtelColors.neutral.shade300,
            margin: onlySidePad(
              top: Dimens.paddingMicro,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Dimens.defaultBorderRadius,
              ),
            ),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(
                // horizontal: AppDimens.paddingDefault,
                // vertical: AppDimens.paddingDefault,
              ),
              child: Column(
                children:
                widget.cards != null || (widget.cards ?? []).isNotEmpty
                    ? [
                  ...(widget.cards ?? []).map((e) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          widget.fieldController.text =
                              BankCardHelper.formatCardNumber(
                                  e.cardNumber ?? "");
                        });
                        expandOptions = false;
                        widget.onCardSelected(e);
                      },
                      title: Text(BankCardHelper.formatCardNumber(
                          e.cardNumber ?? "")),
                      subtitle: AppRichText(
                        text: BankCardHelper.getCardType(
                            e.cardNumber ?? ""),
                        fontSize: Dimens.caption,
                        color: HubtelColors.neutral.shade200,
                      ),
                    );
                  }),
                ]
                    : [
                  ListTile(
                    onTap: () {
                      setState(() {
                        expandOptions = false;
                      });
                      // Navigation.openAddMomoWalletPage(
                      //   context: context,
                      // );
                    },
                    title: const Text(
                      CheckoutStrings.youHaveNoSavedCards,
                      style: TextStyle(
                        color: HubtelColors.teal, // TODO: check color
                        fontSize: Dimens.caption,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
