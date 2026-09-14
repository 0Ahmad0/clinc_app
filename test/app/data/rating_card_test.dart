import 'package:clinc_app_t1/app/core/widgets/action_rating_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('disabled review shows reason and cannot submit in $brightness', (tester) async {
      var taps = 0;
      await tester.pumpWidget(ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, child) => MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: Scaffold(body: ActionRatingCardWidget(
            title: 'Review', subtitle: 'Add a review', enabled: false,
            disabledMessage: 'Complete an appointment first',
            onTap: () => taps++,
          )),
        ),
      ));
      expect(find.text('Complete an appointment first'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      await tester.tap(find.text('Review'));
      expect(taps, 0);
    });
  }
}
