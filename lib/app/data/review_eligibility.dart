class ReviewEligibility {
  const ReviewEligibility({required this.canReview, this.reason, this.message});

  final bool canReview;
  final String? reason;
  final String? message;

  factory ReviewEligibility.fromJson(Map<dynamic, dynamic> json) {
    final allowed = json['can_review'] == true;
    return ReviewEligibility(
      canReview: allowed,
      reason: allowed ? null : json['review_ineligibility_reason']?.toString(),
      message: allowed
          ? null
          : json['review_ineligibility_message']?.toString().trim(),
    );
  }
}
