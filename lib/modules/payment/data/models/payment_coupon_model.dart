import 'checkout_model.dart';

class PaymentCouponModel {
  const PaymentCouponModel({
    required this.code,
    required this.title,
    required this.discountAmount,
    this.checkoutSummary,
  });

  final String code;
  final String title;
  final double discountAmount;
  final CheckoutSummaryModel? checkoutSummary;

  factory PaymentCouponModel.fromJson(Map<String, dynamic> json) {
    return PaymentCouponModel(
      code: json['code']?.toString() ?? '',
      title: (json['title'] ?? json['name'])?.toString() ?? '',
      discountAmount:
          double.tryParse(
            (json['discount_amount'] ??
                        json['discountAmount'] ??
                        json['amount'])
                    ?.toString() ??
                '',
          ) ??
          0,
      checkoutSummary: json['summary'] is Map
          ? CheckoutSummaryModel.fromJson(
              Map<String, dynamic>.from(json['summary'] as Map),
            )
          : json['checkout_summary'] is Map
          ? CheckoutSummaryModel.fromJson(
              Map<String, dynamic>.from(json['checkout_summary'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'discount_amount': discountAmount,
    'summary': checkoutSummary?.toJson(),
  };
}
