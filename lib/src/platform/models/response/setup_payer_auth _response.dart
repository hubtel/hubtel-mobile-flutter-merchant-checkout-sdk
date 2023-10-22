import '../../../network_manager/network_manager.dart';

class Setup3dsResponse implements Serializable {
  final String? id;
  final String? status;
  final String? accessToken;
  final String? referenceId;
  final String? deviceDataCollectionUrl;
  final String? clientReference;
  final String? transactionId;

  Setup3dsResponse({
    this.id,
    this.status,
    this.accessToken,
    this.referenceId,
    this.deviceDataCollectionUrl,
    this.clientReference,
    this.transactionId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'accessToken': accessToken,
      'referenceId': referenceId,
      'deviceDataCollectionUrl': deviceDataCollectionUrl,
      'clientReference': clientReference,
      'transactionId': transactionId,
    };
  }

  factory Setup3dsResponse.fromJson(Map<String, dynamic>? json) {
    return Setup3dsResponse(
      id: json?['id'],
      status: json?['status'],
      accessToken: json?['accessToken'],
      referenceId: json?['referenceId'],
      deviceDataCollectionUrl: json?['deviceDataCollectionUrl'],
      clientReference: json?['clientReference'],
      transactionId: json?['transactionId'],
    );
  }
}
