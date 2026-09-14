import 'package:clinc_app_t1/app/data/review_eligibility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only explicit backend permission allows reviewing', () {
    for (final value in [null, false, 'true', 1]) {
      expect(
        ReviewEligibility.fromJson({'can_review': value}).canReview,
        isFalse,
      );
    }
    expect(ReviewEligibility.fromJson({'can_review': true}).canReview, isTrue);
    expect(ReviewEligibility.fromJson({}).canReview, isFalse);
  });

  test('preserves backend denial reason and localized message', () {
    for (final reason in [
      'unauthenticated',
      'no_eligible_booking',
      'review_forbidden',
    ]) {
      final eligibility = ReviewEligibility.fromJson({
        'can_review': false,
        'review_ineligibility_reason': reason,
        'review_ineligibility_message': 'يمكنك تقييم الطبيب فقط بعد موعد مكتمل',
      });
      expect(eligibility.reason, reason);
      expect(eligibility.message, 'يمكنك تقييم الطبيب فقط بعد موعد مكتمل');
    }
  });

  test('allowed eligibility clears denial information', () {
    final eligibility = ReviewEligibility.fromJson({
      'can_review': true,
      'review_ineligibility_reason': null,
      'review_ineligibility_message': null,
    });
    expect(eligibility.reason, isNull);
    expect(eligibility.message, isNull);
  });
}
