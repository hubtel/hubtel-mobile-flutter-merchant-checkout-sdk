import '../platform/models/models.dart';
import '../resources/checkout_strings.dart';

class CheckoutUtils {
  static String mapApiWalletProviderNameToKnowName(
      {required String providerName}) {
    switch (providerName) {
      case CheckoutStrings.mtn:
        return CheckoutStrings.mtnMobileMoney;
      case CheckoutStrings.vodafone:
        return CheckoutStrings.vodafoneCash;
      case CheckoutStrings.airtelTigo: case CheckoutStrings.atMoney: case CheckoutStrings.airtel:
      return CheckoutStrings.airtelTigoMoney;
      default:
        return "";
    }

  }

  static MomoProvider getProvider({required String providerString}){
      if (providerString.contains("mtn")){
        return MomoProvider(name: "MTN", logoUrl: "", alias: "mtn-gh", receiveMoneyPromptValue: "mtn-gh", preapprovalConfirmValue: "", directDebitValue:"mtn-gh-direct-debit" );
      }

      if (providerString.contains("airtel")){
       return MomoProvider(name: "Airtel Tigo", logoUrl: "", alias: "airtelTigo", receiveMoneyPromptValue: "tigo-gh", preapprovalConfirmValue: "", directDebitValue:"tigo-gh-direct-debit");
      }

      if (providerString.contains("voda")){
        return MomoProvider(name: "Vodafone", logoUrl: "", alias: "vodafone", receiveMoneyPromptValue: "vodafone-gh", preapprovalConfirmValue: "", directDebitValue:"vodafone-gh-direct-debit");
      }


      return MomoProvider();
  }

  static String mapProviderNameToShortName({required String providerName}) {
    switch (providerName) {
      case CheckoutStrings.mtnMobileMoney:
        return CheckoutStrings.mtn;
      case CheckoutStrings.vodafoneCash:
        return CheckoutStrings.vodafone;
      case CheckoutStrings.airtelTigoMoney:
        return CheckoutStrings.airtelTigo;
      default:
        return "";
    }
  }

}