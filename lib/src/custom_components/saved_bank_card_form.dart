
import 'package:flutter/material.dart';
import '../platform/models/models.dart';
import '../resources/checkout_strings.dart';
import 'bank_tile.dart';

class SavedBankCardForm extends StatefulWidget {
  const SavedBankCardForm({
    super.key,
    required this.cardNumberFieldController,
    required this.cards,
    required this.onCardSelected,
    required this.onCvvChanged,
    required this.formKey,
  });

  final TextEditingController cardNumberFieldController;
  final void Function(CardData) onCardSelected;
  final List<CardData> cards;
  final void Function(String)? onCvvChanged;
  final GlobalKey<FormState> formKey;

  @override
  State<SavedBankCardForm> createState() => _SavedBankCardFormState();
}

class _SavedBankCardFormState extends State<SavedBankCardForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          BankTileDropdown(
            fieldController: widget.cardNumberFieldController,
            cards: widget.cards,
            hintText: CheckoutStrings.bankCard,
            onCardSelected: widget.onCardSelected,
          ),

        ],
      ),
    );
  }
}
