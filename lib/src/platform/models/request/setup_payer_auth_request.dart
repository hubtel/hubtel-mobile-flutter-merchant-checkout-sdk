import '../../../network_manager/network_manager.dart';

class SetupPayerAuthRequest implements Serializable{
  final double amount;
  final String cardHolderName;
  final String cardNumber;
  final String cvv;
  final String expiryMonth;
  final String expiryYear;
  final String customerMsisdn;
  final String description;
  final String clientReference;
  final String callbackUrl;

  SetupPayerAuthRequest({
    required this.amount,
    required this.cardHolderName,
    required this.cardNumber,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
    required this.customerMsisdn,
    required this.description,
    required this.clientReference,
    required this.callbackUrl,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'customerMsisdn': customerMsisdn,
      'description': description,
      'clientReference': clientReference,
      'callbackUrl': callbackUrl,
    };
  }

  factory SetupPayerAuthRequest.fromJson(Map<String, dynamic> json) {
    return SetupPayerAuthRequest(
      amount: json['amount'],
      cardHolderName: json['cardHolderName'],
      cardNumber: json['cardNumber'],
      cvv: json['cvv'],
      expiryMonth: json['expiryMonth'],
      expiryYear: json['expiryYear'],
      customerMsisdn: json['customerMsisdn'],
      description: json['description'],
      clientReference: json['clientReference'],
      callbackUrl: json['callbackUrl'],
    );
  }
}
