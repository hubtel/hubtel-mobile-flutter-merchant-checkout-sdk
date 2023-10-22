

import '../resources/checkout_strings.dart';

class BankCardHelper {
  static String formatCardNumber(String number) {
    return number.replaceAllMapped(RegExp(r'(\w{4})(\w{4})(\w{4})(\w{4})'),
            (Match match) {
          return '${match[1]} ${match[2]?.substring(0, 2)}** **** ${match[4]}';
        });
  }

  static String getCardType(String cardNumber) {
    if (cardNumber.startsWith("4")) {
      return CheckoutStrings.visa;
    } else if (cardNumber.startsWith("5")) {
      return CheckoutStrings.masterCard;
    } else {
      return "";
    }
  }
}