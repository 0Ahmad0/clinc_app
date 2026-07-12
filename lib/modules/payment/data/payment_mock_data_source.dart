import '../../../app/data/base_model.dart';
import 'models/card_model.dart';
import 'models/checkout_model.dart';
import 'models/checkout_payment_request_model.dart';
import 'models/payment_coupon_model.dart';
import 'payment_data_source.dart';

class PaymentMockDataSource implements PaymentDataSource {
  final List<CardModel> _cards = <CardModel>[
    CardModel(
      id: 'card-1',
      provider: 'stripe',
      brand: 'visa',
      last4: '1111',
      cardHolderName: 'AHMAD SALEH',
      expiryMonth: '12',
      expiryYear: '2028',
      isDefault: true,
      createdAt: '2026-07-12T00:00:00Z',
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
      'data': {'items': _cards.map((item) => item.toJson()).toList()},
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
      'data': {...card.toJson(), ...card.toCreateJson()},
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
  Future<BaseModel<CheckoutModel>> labCartCheckout(
    CheckoutPaymentRequestModel request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Payment processed successfully',
        'data': {
          'payment_id': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
          'summary': {
            'subtotal': request.consultationPrice,
            'vat_amount': request.vatAmount,
            'discount_amount': request.discountAmount,
            'total_amount': request.totalAmount,
          },
          ...request.toJson(),
        },
        'meta': <String, dynamic>{},
      },
      (json) => CheckoutModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  List<CardModel> _cardListFromJson(dynamic json) {
    final items = json is Map<String, dynamic> ? json['items'] : json;
    if (items is! List) return <CardModel>[];
    return items
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
