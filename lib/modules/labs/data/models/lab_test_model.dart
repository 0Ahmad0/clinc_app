class LabTest {
  final String title;
  final String category; // مثلاً: فيتامينات، وظائف حيوية
  final String description; // شرح بسيط (للكشف عن..)
  final double price;
  final bool isPackage; // هل هو باقة أم تحليل مفرد؟
  final int? numberOfTests; // لو باقة، كم تحليل فيها؟

  LabTest({
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    this.isPackage = false,
    this.numberOfTests,
  });
}