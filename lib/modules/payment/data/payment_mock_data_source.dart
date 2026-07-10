import '../../../app/data/base_model.dart';
import 'models/card_model.dart';
import 'models/card_utils.dart';
import 'models/checkout_payment_request_model.dart';
import 'models/payment_coupon_model.dart';
import 'payment_data_source.dart';

class PaymentMockDataSource implements PaymentDataSource {
  final List<CardModel> _cards = <CardModel>[
    CardModel(
      id: 'card-1',
      holderName: 'AHMAD SALEH',
      cardNumber: '4111 1111 1111 1111',
      expiryDate: '12/28',
      cvv: '123',
      type: CardType.visa,
    ),
  ];

  final List<PaymentCouponModel> _coupons = const [
    PaymentCouponModel(
      code: 'FIRST20',
      title: 'خصم الزيارة الأولى',
      discountAmount: 20,
    ),
    PaymentCouponModel(
      code: 'FOLLOW10',
      title: 'خصم المتابعة الدورية',
      discountAmount: 10,
    ),
  ];

  @override
  Future<BaseModel<List<CardModel>>> getSavedCards() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Cards retrieved successfully',
      'data': _cards.map((item) => item.toJson()).toList(),
      'meta': <String, dynamic>{},
    }, _cardListFromJson);
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> addCard(CardModel card) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _cards.add(card);
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Card added successfully',
      'data': card.toJson(),
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> deleteCard(String cardId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _cards.removeWhere((item) => item.id == cardId);
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Card removed successfully',
      'data': {'card_id': cardId},
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }

  @override
  Future<BaseModel<PaymentCouponModel>> applyCoupon(
    String code, {
    double? subtotal,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final coupon = _coupons.firstWhere(
      (item) => item.code.toLowerCase() == code.toLowerCase(),
      orElse: () => const PaymentCouponModel(
        code: '',
        title: 'Invalid coupon',
        discountAmount: 0,
      ),
    );
    if (coupon.code.isEmpty) {
      return BaseModel.fromJson(
        {
          'status': 'error',
          'message': 'Coupon is invalid',
          'data': <String, dynamic>{},
          'meta': <String, dynamic>{},
        },
        (json) =>
            PaymentCouponModel.fromJson(Map<String, dynamic>.from(json as Map)),
      );
    }
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Coupon applied successfully',
        'data': coupon.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) =>
          PaymentCouponModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<List<PaymentCouponModel>>> getCoupons() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Coupons retrieved successfully',
      'data': _coupons.map((item) => item.toJson()).toList(),
      'meta': <String, dynamic>{},
    }, _couponListFromJson);
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> checkout(
    CheckoutPaymentRequestModel request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Payment processed successfully',
      'data': {
        'payment_id': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
        ...request.toJson(),
      },
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }

  List<CardModel> _cardListFromJson(dynamic json) {
    if (json is! List) return <CardModel>[];
    return json
        .whereType<Map>()
        .map((item) => CardModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  List<PaymentCouponModel> _couponListFromJson(dynamic json) {
    if (json is! List) return <PaymentCouponModel>[];
    return json
        .whereType<Map>()
        .map(
          (item) =>
              PaymentCouponModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
