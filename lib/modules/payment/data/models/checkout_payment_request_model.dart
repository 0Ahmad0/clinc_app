class CheckoutPaymentRequestModel {
  const CheckoutPaymentRequestModel({
    required this.paymentType,
    required this.subMethod,
    required this.consultationPrice,
    required this.vatAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.couponCode,
  });

  final String paymentType;
  final String subMethod;
  final double consultationPrice;
  final double vatAmount;
  final double discountAmount;
  final double totalAmount;
  final String? couponCode;

  Map<String, dynamic> toJson() => {
    'payment_type': paymentType,
    'sub_method': subMethod,
    'consultation_price': consultationPrice,
    'vat_amount': vatAmount,
    'discount_amount': discountAmount,
    'total_amount': totalAmount,
    'coupon_code': couponCode,
  };
}
