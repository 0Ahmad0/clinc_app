import 'package:flutter/material.dart';

class PrivacySectionLabel extends StatelessWidget {
  final String title;
  const PrivacySectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

