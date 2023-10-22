import '../../network_manager/network_manager.dart';

class AddMobileWalletBody implements Serializable {
  String accountNo;
  String provider;
  String customerMobileNumber;

  AddMobileWalletBody({
    required this.accountNo,
    required this.provider,
    required this.customerMobileNumber,
  });

  factory AddMobileWalletBody.fromJson(Map<String, dynamic> json) {
    return AddMobileWalletBody(
      accountNo: json['accountNo'] as String,
      provider: json['provider'] as String,
      customerMobileNumber: json['CustomerMobileNumber'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountNo': accountNo,
      'provider': provider,
      'CustomerMobileNumber': customerMobileNumber,
    };
  }
}
