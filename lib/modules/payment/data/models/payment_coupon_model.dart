class PaymentCouponModel {
  const PaymentCouponModel({
    required this.code,
    required this.title,
    required this.discountAmount,
  });

  final String code;
  final String title;
  final double discountAmount;

  factory PaymentCouponModel.fromJson(Map<String, dynamic> json) {
    return PaymentCouponModel(
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      discountAmount:
          double.tryParse(json['discount_amount']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'discount_amount': discountAmount,
  };
}
