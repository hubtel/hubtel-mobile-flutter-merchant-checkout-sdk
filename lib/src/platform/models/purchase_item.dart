import 'package:unified_checkout_sdk/src/extensions/extensions.dart';

class PurchaseInfo {
  double amount;
  String customerPhoneNumber;
  String purchaseDescription;
  String clientReference;

  String get customerMsisdn{
    return customerPhoneNumber.generateFormattedPhoneNumber();
  }

  PurchaseInfo({
    required this.amount,
    required this.customerPhoneNumber,
    required this.purchaseDescription,
    required this.clientReference,
  });
}