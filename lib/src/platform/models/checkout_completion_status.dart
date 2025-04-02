
enum UnifiedCheckoutPaymentStatus {
  paymentFailed,
  paymentSuccess,
  pending,
  unknown,
  userCancelledPayment
}

class CheckoutCompletionStatus {
  UnifiedCheckoutPaymentStatus status;
  String? paymentType;
  String? paymentChannel;
  String transactionId;

  CheckoutCompletionStatus({required this.status, required this.transactionId, this.paymentChannel, this.paymentType});
}
