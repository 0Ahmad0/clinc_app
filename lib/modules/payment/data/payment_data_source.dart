import '../../../app/data/base_model.dart';
import 'models/card_model.dart';
import 'models/checkout_payment_request_model.dart';
import 'models/payment_coupon_model.dart';

abstract class PaymentDataSource {
  Future<BaseModel<List<CardModel>>> getSavedCards();

  Future<BaseModel<Map<String, dynamic>>> addCard(CardModel card);

  Future<BaseModel<Map<String, dynamic>>> deleteCard(String cardId);

  Future<BaseModel<PaymentCouponModel>> applyCoupon(
    String code, {
    double? subtotal,
  });

  Future<BaseModel<List<PaymentCouponModel>>> getCoupons();

  Future<BaseModel<Map<String, dynamic>>> checkout(
    CheckoutPaymentRequestModel request,
  );
}
