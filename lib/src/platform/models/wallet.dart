import '../../network_manager/network_manager.dart';

class Wallet implements Serializable {
  final int? id;
  final int? clientId;
  final String? externalId;
  final int? customerId;
  final String? accountNo;
  final String? accountName;
  final String? providerId;
  final String? provider;
  final String? type;

  Wallet({
    this.id,
    this.clientId,
    required this.externalId,
    this.customerId,
    required this.accountNo,
    required this.accountName,
    required this.providerId,
    required this.provider,
    required this.type,
  });

  factory Wallet.fromJson(Map<String, dynamic>? json) {
    return Wallet(
      id: json?['id'],
      clientId: json?['clientId'],
      externalId: json?['externalId'],
      customerId: json?['customerId'],
      accountNo: json?['accountNo'],
      accountName: json?['accountName'],
      providerId: json?['providerId'],
      provider: json?['provider'],
      type: json?['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'externalId': externalId,
      'customerId': customerId,
      'accountNo': accountNo,
      'accountName': accountName,
      'providerId': providerId,
      'provider': provider,
      'type': type,
    };
  }
}
