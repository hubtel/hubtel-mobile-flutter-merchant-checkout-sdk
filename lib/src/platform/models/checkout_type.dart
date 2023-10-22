

enum CheckoutType{
  receivemoneyprompt("receivemoneyprompt"),
  directdebit("directdebit"),
  preapprovalconfirm("directdebit");

  final String rawValue;

  const CheckoutType(this.rawValue);
}
