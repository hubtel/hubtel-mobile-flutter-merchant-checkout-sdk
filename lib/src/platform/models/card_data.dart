import 'dart:convert';

import '../../network_manager/network_manager.dart';

class CardData implements Serializable {
  String? cardNumber;
  String? cardExpiryDate;
  String? cvv;

  CardData({this.cardNumber, this.cardExpiryDate, this.cvv});

  factory CardData.fromJson(Map<String, dynamic>? json) {
    return CardData(
      cardNumber: json?["cardNumber"],
      cardExpiryDate: json?["cardExpiryDate"],
      cvv: json?["cvv"],
    );
  }

  static CardData fromString(String? string) {
    return CardData.fromJson(jsonDecode(string ?? ""));
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      "cardNumber": cardNumber,
      "cardExpiryDate": cardExpiryDate,
      "cvv": cvv,
    };
  }
}