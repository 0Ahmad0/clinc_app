import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/models/card_model.dart';
import '../data/models/checkout_payment_request_model.dart';
import '../data/models/payment_coupon_model.dart';
import '../data/payment_data_source.dart';

class PaymentRepository {
  PaymentRepository(this._dataSource);

  final PaymentDataSource _dataSource;

  Future<ApiResponse<BaseModel<List<CardModel>>>> getSavedCards() {
    return _execute(_dataSource.getSavedCards);
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> addCard(CardModel card) {
    return _execute(() => _dataSource.addCard(card));
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> deleteCard(
    String cardId,
  ) {
    return _execute(() => _dataSource.deleteCard(cardId));
  }

  Future<ApiResponse<BaseModel<PaymentCouponModel>>> applyCoupon(
    String code, {
    double? subtotal,
  }) {
    return _execute(() => _dataSource.applyCoupon(code, subtotal: subtotal));
  }

  Future<ApiResponse<BaseModel<List<PaymentCouponModel>>>> getCoupons() {
    return _execute(_dataSource.getCoupons);
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> checkout(
    CheckoutPaymentRequestModel request,
  ) {
    return _execute(() => _dataSource.checkout(request));
  }

  Future<ApiResponse<BaseModel<T>>> _execute<T>(
    Future<BaseModel<T>> Function() action,
  ) async {
    try {
      return ApiResponse.success(await action());
    } catch (error) {
      return ApiResponse.failure(NetworkExceptions.getException(error));
    }
  }
}
