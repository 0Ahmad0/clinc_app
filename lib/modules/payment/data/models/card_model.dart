import 'card_utils.dart';

class CardModel {
  final String id;
  final String holderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final CardType type;

  CardModel({
    required this.id,
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.type,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id']?.toString() ?? '',
      holderName: (json['holder_name'] ?? json['holderName'])?.toString() ?? '',
      cardNumber: (json['card_number'] ?? json['cardNumber'])?.toString() ?? '',
      expiryDate: (json['expiry_date'] ?? json['expiryDate'])?.toString() ?? '',
      cvv: json['cvv']?.toString() ?? '',
      type: CardUtils.getCardTypeFromNumber(
        (json['card_number'] ?? json['cardNumber'])?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'holder_name': holderName,
    'card_number': cardNumber,
    'expiry_date': expiryDate,
    'cvv': cvv,
    'card_type': type.name,
  };
}
