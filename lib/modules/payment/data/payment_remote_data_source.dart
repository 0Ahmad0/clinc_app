import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'models/card_model.dart';
import 'models/checkout_model.dart';
import 'models/checkout_payment_request_model.dart';
import 'models/payment_coupon_model.dart';
import 'payment_data_source.dart';

class PaymentRemoteDataSource implements PaymentDataSource {
  PaymentRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<List<CardModel>>> getSavedCards() async {
    final response = await _apiServices.get(
      AppUrl.userPaymentCards,
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      _cardListFromJson,
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> addCard(CardModel card) async {
    final response = await _apiServices.post(
      AppUrl.userPaymentCards,
      hasToken: true,
      body: card.toCreateJson(),
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> deleteCard(String cardId) async {
    final response = await _apiServices.delete(
      AppUrl.userPaymentCard(cardId),
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  @override
  Future<BaseModel<PaymentCouponModel>> applyCoupon(
    String code, {
    double? subtotal,
  }) async {
    final response = await _apiServices.post(
      AppUrl.userPaymentApplyCoupon,
      hasToken: true,
      body: {'coupon_code': code, if (subtotal != null) 'amount': subtotal},
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) =>
          PaymentCouponModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<List<PaymentCouponModel>>> getCoupons() async {
    final response = await _apiServices.get(
      AppUrl.userPaymentCoupons,
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      _couponListFromJson,
    );
  }

  @override
  Future<BaseModel<CheckoutModel>> labCartCheckout(
    CheckoutPaymentRequestModel request,
  ) async {
    final response = await _apiServices.post(
      AppUrl.userLabCartCheckout,
      hasToken: true,
      body: request.toJson(),
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => CheckoutModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  List<CardModel> _cardListFromJson(dynamic json) {
    List<dynamic> items = [];

    if (json is Map<String, dynamic>) {
      items = json['items'] ?? [];
    } else if (json is List) {
      items = json;
    }

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
