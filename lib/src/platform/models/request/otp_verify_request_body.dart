import '../../../network_manager/network_manager.dart';

class OtpBodyRequest implements Serializable {
  String? customerMsisdn;
  String? hubtelPreApprovalId;
  String? clientReferenceId;
  String? otpCode;

  OtpBodyRequest({
    this.customerMsisdn,
    this.hubtelPreApprovalId,
    this.clientReferenceId,
    this.otpCode,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'customerMsisdn': customerMsisdn,
      'hubtelPreApprovalId': hubtelPreApprovalId,
      'clientReferenceId': clientReferenceId,
      'otpCode': otpCode,
    };
  }
}





