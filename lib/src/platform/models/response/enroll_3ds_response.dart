import '../../../network_manager/network_manager.dart';

class Enroll3dsResponse implements Serializable {
  String? transactionId;
  String? description;
  String? clientReference;
  double? amount;
  double? charges;
  String? customData;
  String? jwt;

  // Map<String, dynamic>? customCardData;
  String? cardStatus;

  Enroll3dsResponse({
    this.transactionId,
    this.description,
    this.clientReference,
    this.amount,
    this.charges,
    this.customData,
    this.jwt,
    this.cardStatus,
  });

  Enroll3dsResponse.fromJson(Map<String, dynamic>? json) {
    transactionId = json?['transactionId'];
    description = json?['description'];
    clientReference = json?['clientReference'];
    amount = json?['amount']?.toDouble();
    charges = json?['charges']?.toDouble();
    customData = json?['customData'];
    jwt = json?['jwt'];
    // customCardData = json?['customCardData'];
    cardStatus = json?['cardStatus'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionId'] = transactionId;
    data['description'] = description;
    data['clientReference'] = clientReference;
    data['amount'] = amount;
    data['charges'] = charges;
    data['customData'] = customData;
    data['jwt'] = jwt;
    // data['customCardData'] = customCardData;
    data['cardStatus'] = cardStatus;
    return data;
  }
}
