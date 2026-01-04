import 'package:flutter/material.dart';

import '../../../../app/core/constants/app_assets.dart';

enum CardType { mada, visa, mastercard, unknown }

class CardUtils {
  static CardType getCardTypeFromNumber(String input) {
    String cleanInput = input.replaceAll(' ', '');
    if (cleanInput.startsWith('4')) {
      return CardType.visa;
    } else if (cleanInput.startsWith('5')) {
      return CardType.mastercard;
    } else if (cleanInput.startsWith('5888') ||
        cleanInput.startsWith('4847') ||
        cleanInput.startsWith('9682')) {
      return CardType.mada;
    }
    return CardType.unknown;
  }

  static Color getCardColor(CardType type) {
    switch (type) {
      case CardType.visa:
        return const Color(0xFF1A1F71); // أزرق غامق
      case CardType.mastercard:
        return const Color(0xFF222222); // أسود
      case CardType.mada:
        return const Color(0xFF005E67); // تركوازي غامق
      default:
        return const Color(0xFF3B434E); // رمادي
    }
  }

  // شعار البطاقة
  static String getCardIcon(CardType type) {
    switch (type) {
      case CardType.visa:
        return AppAssets.visaIcon;
      case CardType.mastercard:
        return AppAssets.mastercardIcon;
      case CardType.mada:
        return AppAssets.madaIcon;
      default:
        return '';
    }
  }
}
