
class CustomerVerificationBody {
  String? customerMobileNumber;
  String? verifyIdType;
  String? nationalId;
  String? fullName;
  String? dateOfBirth;
  String? gender;
  String? email;

  CustomerVerificationBody({
    this.customerMobileNumber,
    this.verifyIdType,
    this.nationalId,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.email,
  });
}