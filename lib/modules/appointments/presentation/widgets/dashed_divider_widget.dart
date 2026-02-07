import 'package:flutter/material.dart';
class DashedDividerWidget extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpacing;
  final Color color;

  const DashedDividerWidget({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpacing = 3,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpacing)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: ColoredBox(color: color.withValues(alpha: 0.3)),
            );
          }),
        );
      },
    );
  }
}
