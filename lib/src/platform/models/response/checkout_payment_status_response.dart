import '../../../network_manager/network_manager.dart';
import '../payment_status.dart';

class CheckoutOrderStatus implements Serializable {
  String? transactionID;
  String? externalTransactionID;
  String? paymentMethod;
  String? clientReference;
  String? currencyCode;
  double? amount;
  double? charges;
  double? amountAfterCharges;
  String? providerDescription;
  String? status;

  CheckoutOrderStatus({
    this.transactionID,
    this.externalTransactionID,
    this.paymentMethod,
    this.clientReference,
    this.currencyCode,
    this.amount,
    this.charges,
    this.amountAfterCharges,
    this.providerDescription,
    this.status,
  });

  PaymentStatus get paymentStatus {
    switch (status?.toLowerCase()) {
      case "paid":
        return PaymentStatus.paid;
      case "unpaid":
        return PaymentStatus.pending;
      case "expired":
        return PaymentStatus.failed;
      case "failed":
        return PaymentStatus.failed;
      default:
        return PaymentStatus.pending;
    }
  }

  factory CheckoutOrderStatus.fromJson(Map<String, dynamic>? json) {
    return CheckoutOrderStatus(
      transactionID: json?['transactionID'],
      externalTransactionID: json?['externalTransactionID'],
      paymentMethod: json?['paymentMethod'],
      clientReference: json?['clientReference'],
      currencyCode: json?['currencyCode'],
      amount: json?['amount']?.toDouble(),
      charges: json?['charges']?.toDouble(),
      amountAfterCharges: json?['amountAfterCharges']?.toDouble(),
      providerDescription: json?['providerDescription'],
      status: json?['status'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'transactionID': transactionID,
      'externalTransactionID': externalTransactionID,
      'paymentMethod': paymentMethod,
      'clientReference': clientReference,
      'currencyCode': currencyCode,
      'amount': amount,
      'charges': charges,
      'amountAfterCharges': amountAfterCharges,
      'providerDescription': providerDescription,
      'status': status,
    };
  }
}
