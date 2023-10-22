import '../../../network_manager/network_manager.dart';

class MobileMoneyPaymentRequest implements Serializable {
  String? customerName;
  String? customerMsisdn;
  String? channel;
  String? amount;
  String? primaryCallbackUrl;
  String? description;
  String? clientReference;
  String? mandateId;

  MobileMoneyPaymentRequest({
    this.customerName,
    this.customerMsisdn,
    this.channel,
    this.amount,
    this.primaryCallbackUrl,
    this.description,
    this.clientReference,
    this.mandateId,
  });

  factory MobileMoneyPaymentRequest.fromJson(Map<String, dynamic> json) {
    return MobileMoneyPaymentRequest(
      customerName: json['customerName'],
      customerMsisdn: json['customerMsisdn'],
      channel: json['channel'],
      amount: json['amount'],
      primaryCallbackUrl: json['primaryCallbackUrl'],
      description: json['description'],
      clientReference: json['clientReference'],
      mandateId: json['mandateId'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerMsisdn': customerMsisdn,
      'channel': channel,
      'amount': amount,
      'primaryCallbackUrl': primaryCallbackUrl,
      'description': description,
      'clientReference': clientReference,
      'mandateId': mandateId,
    };
  }



}
