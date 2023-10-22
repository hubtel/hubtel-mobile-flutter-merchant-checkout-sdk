
import '../../network_manager/network_manager.dart';

class MomoProvider implements Serializable {
  String? name;
  String? logoUrl;
  String? alias;
  String? receiveMoneyPromptValue;
  String? directDebitValue;
  String? preapprovalConfirmValue;

  MomoProvider({
    this.name,
    this.logoUrl,
    this.alias,
    this.receiveMoneyPromptValue,
    this.directDebitValue,
    this.preapprovalConfirmValue
  });

  factory MomoProvider.fromJson(Map<String, dynamic>? json) => MomoProvider(
    name: json?["name"],
    logoUrl: json?["logoUrl"],
    receiveMoneyPromptValue: json?["alias"],
  );

  @override
  Map<String, dynamic> toMap() => {
    "name": name,
    "logoUrl": logoUrl,
    "alias": receiveMoneyPromptValue,
  };
}