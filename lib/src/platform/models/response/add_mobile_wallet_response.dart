//
// import 'package:unified_checkout_sdk/network_manager/serializable.dart';
//
// class Wallet implements Serializable {
//   int? id;
//   int? clientId;
//   String? externalId;
//   int? customerId;
//   String? accountNo;
//   String? accountName;
//   String? providerId;
//   String? provider;
//   String? type;
//
//   Wallet({
//     this.id,
//     this.clientId,
//     this.externalId,
//     this.customerId,
//     this.accountNo,
//     this.accountName,
//     this.providerId,
//     this.provider,
//     this.type,
//   });
//
//   factory Wallet.fromJson(Map<String, dynamic>? json) {
//     return Wallet(
//       id: json?['id'] as int?,
//       clientId: json?['clientId'] as int?,
//       externalId: json?['externalId'] as String?,
//       customerId: json?['customerId'] as int?,
//       accountNo: json?['accountNo'] as String?,
//       accountName: json?['accountName'] as String?,
//       providerId: json?['providerId'] as String?,
//       provider: json?['provider'] as String?,
//       type: json?['type'] as String?,
//     );
//   }
//
//   @override
//   Map<String, dynamic> toMap() {
//     // TODO: implement toMap
//     throw UnimplementedError();
//   }
// }
