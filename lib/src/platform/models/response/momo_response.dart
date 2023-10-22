import '../../../network_manager/network_manager.dart';

class MomoResponse implements Serializable {
  String? transactionId;
  double? charges;
  double? amount;
  double? amountAfterCharges;
  double? amountCharged;
  double? deliveryFee;
  String? description;
  String? clientReference;
  String? hubtelPreapprovalId;
  String? otpPrefix;
  String? customerMsisdn;
  bool? skipOtp;
  String? verificationType;
  String? customerName;
  String? invoiceNumber;
  String? email;

  MomoResponse({
    this.transactionId,
    this.charges,
    this.amount,
    this.amountAfterCharges,
    this.amountCharged,
    this.deliveryFee,
    this.description,
    this.clientReference,
    this.hubtelPreapprovalId,
    this.otpPrefix,
    this.customerMsisdn,
    this.skipOtp,
    this.verificationType,
    this.customerName,
    this.invoiceNumber,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'charges': charges,
      'amount': amount,
      'amountAfterCharges': amountAfterCharges,
      'amountCharged': amountCharged,
      'deliveryFee': deliveryFee,
      'description': description,
      'clientReference': clientReference,
      'hubtelPreapprovalId': hubtelPreapprovalId,
      'otpPrefix': otpPrefix,
      'customerMsisdn': customerMsisdn,
      'skipOtp': skipOtp,
      'verificationType': verificationType,
      'customerName': customerName,
      'invoiceNumber': invoiceNumber,
      'email': email,
    };
  }

  factory MomoResponse.fromJson(Map<String, dynamic>? json) {
    return MomoResponse(
      transactionId: json?['transactionId'],
      amount: json?['amount']?.toDouble(),
      charges: json?['charges']?.toDouble(),
      amountAfterCharges: json?['amountAfterCharges']?.toDouble(),
      amountCharged: json?['amountCharged']?.toDouble(),
      deliveryFee: json?['deliveryFee']?.toDouble(),
      description: json?['description'],
      clientReference: json?['clientReference'],
      hubtelPreapprovalId: json?['hubtelPreapprovalId'],
      otpPrefix: json?['otpPrefix'],
      customerMsisdn: json?['customerMsisdn'],
      skipOtp: json?['skipOtp'],
      verificationType: json?['verificationType'],
      customerName: json?['customerName'],
      invoiceNumber: json?['invoiceNumber'],
      email: json?['email'],
    );
  }

  @override
  String toString() {
    return 'MomoResponse{'
        'transactionId: $transactionId, '
        'charges: $charges, '
        'amount: $amount, '
        'amountAfterCharges: $amountAfterCharges, '
        'amountCharged: $amountCharged, '
        'deliveryFee: $deliveryFee, '
        'description: $description, '
        'clientReference: $clientReference, '
        'hubtelPreapprovalId: $hubtelPreapprovalId, '
        'otpPrefix: $otpPrefix, '
        'customerMsisdn: $customerMsisdn, '
        'skipOtp: $skipOtp, '
        'verificationType: $verificationType, '
        'customerName: $customerName, '
        'invoiceNumber: $invoiceNumber, '
        'email: $email'
        '}';
  }
}
