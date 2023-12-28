enum UnifiedCheckoutPaymentStatus {
  paymentFailed,
  paymentSuccess,
  pending,
  unknown,
  userCancelledPayment
}

class CheckoutCompletionStatus {
  UnifiedCheckoutPaymentStatus status;
  String transactionId;
  String? channel;
  String? clientReference;
  String? customerMobileNumber;
  double? amountPaid;
  String? paymentType;

  CheckoutCompletionStatus(
      {required this.status,
      required this.transactionId,
       this.channel,
       this.clientReference,
       this.amountPaid,
       this.paymentType,
       this.customerMobileNumber});
}

enum PaymentType{
  card,
  bankPay,
  mobileMoney
}
