
enum WalletType {
  Card("card"),
  Momo("momo"),
  Gratis("hubtel"),
  GMoney("GMoney"),
  Zeepay("Zeepay"),
  Hubtel("hubtel"),
  BankPay("BankPay"),
  PayIn4("PayIn4");

  const WalletType(this.optionValue);

  final String optionValue;
}
