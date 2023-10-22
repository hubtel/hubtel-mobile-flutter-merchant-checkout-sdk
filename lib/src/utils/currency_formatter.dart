import 'package:intl/intl.dart';
import 'package:unified_checkout_sdk/src/utils/string_extensions.dart';

import 'helpers/ttriple.dart';

extension NumberCurrencyFormatter on double? {
  String formatWithDelimiters() {
    if (this != null) {
      final formatted = NumberFormat("#,###,##0.00").format(this);
      return formatted;
    }
    return 0.0.formatWithDelimiters();
  }

  String formatMoney({
    String? displayCurrency,
    bool includeDecimals = true,
  }) {
    final formatted = (this ?? 0.0).formatWithDelimiters();
    final integerDecimalParts = formatted.split(".");

    final decimalPart = integerDecimalParts.elementAtOrNull(1) ?? "00";
    if (decimalPart == "00" && !includeDecimals) {
      return "${displayCurrency ?? "GHS"} ${integerDecimalParts[0]}";
    }

    return "${displayCurrency ?? "GHS"} ${integerDecimalParts[0]}.$decimalPart";
  }

  String formatDoubleToString({
    bool includeDecimals = true,
  }){
    final formatted = (this ?? 0.0).formatWithDelimiters();
    final integerDecimalParts = formatted.split(".");

    final decimalPart = integerDecimalParts.elementAtOrNull(1) ?? "00";
    if (decimalPart == "00" && !includeDecimals) {
      return integerDecimalParts[0];
    }

    return "${integerDecimalParts[0]}.$decimalPart";
  }

  Triple<String, String, String> formatMoneyParts({
    String? currency,
    bool includeDecimals = false,
  }) {
    final numberParts = formatWithDelimiters().split(".");
    final decimalPart = numberParts.elementAtOrNull(1) ?? "00";

    if (decimalPart == "00" && !includeDecimals) {
      return Triple(currency ?? "GHS ", numberParts[0], "");
    }

    return Triple(currency ?? "GHS ", numberParts[0], ".$decimalPart");
  }
}

extension StringCurrencyFormatter on String? {
  String formatMoney({
    String? displayCurrency,
    bool includeDecimals = false,
  }) {
    if (this != null) {
      final stringAsDouble = this!.toDouble();
      return stringAsDouble.formatMoney(
        displayCurrency: displayCurrency,
        includeDecimals: includeDecimals,
      );
    }
    return (0.0).formatMoney(
      displayCurrency: displayCurrency,
      includeDecimals: includeDecimals,
    );
  }
}
extension CurrencyFormatter on double {
  String formatDoubleToString({
    bool includeDecimals = true,
  }){
    final formatted = (this).formatWithDelimiters();
    final integerDecimalParts = formatted.split(".");

    final decimalPart = integerDecimalParts.elementAtOrNull(1) ?? "00";
    if (decimalPart == "00" && !includeDecimals) {
      return integerDecimalParts[0];
    }

    return "${integerDecimalParts[0]}.$decimalPart";
  }
}
