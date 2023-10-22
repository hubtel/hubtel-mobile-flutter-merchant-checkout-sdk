import '../../../network_manager/network_manager.dart';
import '../request/customer_verification_body.dart';

enum VerificationStatus {
  verified,
  unverified;
}

class VerificationResponse implements Serializable {
  final String? status;
  final String? fullName;
  final String? surName;
  final String? otherNames;
  final String? birthday;
  final String? gender;
  final String? motherName;
  final String? fatherName;
  final String? region;
  final String? phone;
  final String? email;
  final String? nationalID;

  VerificationStatus getVerificationStatus() {
    switch ((status ?? "").toLowerCase()) {
      case "verified":
        return VerificationStatus.verified;
      default:
        return VerificationStatus.unverified;
    }
  }

  VerificationResponse({
    this.status,
    this.fullName,
    this.surName,
    this.otherNames,
    this.birthday,
    this.gender,
    this.motherName,
    this.fatherName,
    this.region,
    this.phone,
    this.email,
    this.nationalID,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic>? json) {
    return VerificationResponse(
      status: json?['status'],
      fullName: json?['fullname'],
      surName: json?['surname'],
      otherNames: json?['othernames'],
      birthday: json?['birthday'],
      gender: json?['gender'],
      motherName: json?['motherName'],
      fatherName: json?['fatherName'],
      region: json?['region'],
      phone: json?['phone'],
      email: json?['email'],
      nationalID: json?['nationalId'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'fullname': fullName,
      'surname': surName,
      'othernames': otherNames,
      'birthday': birthday,
      'gender': gender,
      'motherName': motherName,
      'fatherName': fatherName,
      'region': region,
      'phone': phone,
      'email': email,
      'nationalId': nationalID,
    };
  }

  CustomerVerificationBody toVerificationBody(String customerMsisdn) {
    return CustomerVerificationBody(
      customerMobileNumber: customerMsisdn,
      verifyIdType: "NationalId",
      nationalId: nationalID,
      fullName: fullName,
      dateOfBirth: birthday,
      gender: gender,
      email: email,
    );
  }
}
