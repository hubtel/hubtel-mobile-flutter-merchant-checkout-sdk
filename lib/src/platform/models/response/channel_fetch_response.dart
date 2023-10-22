import '../../../network_manager/network_manager.dart';
import '../business_info.dart';

class ChannelFetchResponse extends Serializable {
  List<String>? channels;
  String? businessId;
  String? businessName;
  String? businessLogoUrl;
  bool? requireNationalID;
  bool? isHubtelInternalMerchant;

  // Computed property (getter) equivalent
  bool get merchantRequiresKyc => true;

  ChannelFetchResponse({
    this.channels,
    this.businessId,
    this.businessName,
    this.businessLogoUrl,
    this.requireNationalID,
    this.isHubtelInternalMerchant,
  });

  factory ChannelFetchResponse.fromJson(Map<String, dynamic>? json) {
    return ChannelFetchResponse(
      channels: (json?['channels'] as List<dynamic>?)?.cast<String>(),
      businessId: json?['businessId'] as String?,
      businessName: json?['businessName'] as String?,
      businessLogoUrl: json?['businessLogoUrl'] as String?,
      requireNationalID: json?['requireNationalID'] as bool?,
      isHubtelInternalMerchant: json?['isHubtelInternalMerchant'] as bool?,
    );
  }

  BusinessInfo getBusinessInfo() {
    return BusinessInfo(
        businessName: businessName ?? "",
        businessImageUrl: businessLogoUrl ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'channels': channels,
      'businessId': businessId,
      'businessName': businessName,
      'businessLogoUrl': businessLogoUrl,
      'requireNationalID': requireNationalID,
      'isHubtelInternalMerchant': isHubtelInternalMerchant,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'channels': channels,
      'businessId': businessId,
      'businessName': businessName,
      'businessLogoUrl': businessLogoUrl,
      'requireNationalID': requireNationalID,
      'isHubtelInternalMerchant': isHubtelInternalMerchant,
    };
  }
}
