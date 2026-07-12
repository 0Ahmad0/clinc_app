class CheckoutPaymentRequestModel {
  const CheckoutPaymentRequestModel({
    required this.paymentType,
    required this.subMethod,
    required this.consultationPrice,
    required this.vatAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.couponCode,
    this.appointmentId,
    this.labId,
    this.itemIds = const <String>[],
  });

  final String paymentType;
  final String subMethod;
  final double consultationPrice;
  final double vatAmount;
  final double discountAmount;
  final double totalAmount;
  final String? couponCode;
  final String? appointmentId;
  final String? labId;
  final List<String> itemIds;

  Map<String, dynamic> toJson() => {
    'payment_type': paymentType,
    'sub_method': subMethod,
    'consultation_price': consultationPrice,
    'vat_amount': vatAmount,
    'discount_amount': discountAmount,
    'total_amount': totalAmount,
    if (couponCode != null && couponCode!.isNotEmpty) 'coupon_code': couponCode,
    if (appointmentId != null && appointmentId!.isNotEmpty)
      'appointment_id': appointmentId,
    if (labId != null && labId!.isNotEmpty) 'lab_id': labId,
    if (itemIds.isNotEmpty) 'item_ids': itemIds,
  };
}
