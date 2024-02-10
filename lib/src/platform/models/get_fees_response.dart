import '../../network_manager/network_manager.dart';
import 'checkout_type.dart';




class FeesObj{
  final String? name;
  final num?  value;
  FeesObj({
    this.name,
    this.value
  });

  factory FeesObj.fromJson(Map<String, dynamic>? json){
    return FeesObj(
        name: json?['name'],
        value: json?['value']
    );
  }
}

class NewGetFeesResponse implements Serializable {
  final List<FeesObj?>? fees;
  final double? amountPayable;
  final String? checkoutType;

  NewGetFeesResponse({
    this.fees,
    this.amountPayable,
    this.checkoutType,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'fees': fees,
      'amountPayable': amountPayable,
      'checkoutType': checkoutType,
    };
  }

  factory NewGetFeesResponse.fromJson(Map<String, dynamic>? json) {
    return NewGetFeesResponse(
      fees: (json?['fees'] as List<dynamic>?)
          ?.map((e) => FeesObj.fromJson(e as Map<String, dynamic>))
          .toList(),
      amountPayable: json?['amountPayable'],
      checkoutType: json?['checkoutType'],
    );
  }

  CheckoutType getCheckoutType() {
    switch (checkoutType?.toLowerCase()) {
      case "receivemoneyprompt":
        return CheckoutType.receivemoneyprompt;
      case "preapprovalconfirm":
        return CheckoutType.preapprovalconfirm;
      case "directdebit":
        return CheckoutType.directdebit;
      default:
        return CheckoutType.directdebit;
    }
  }
}
