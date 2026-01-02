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
}
