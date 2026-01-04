class LabTest {
  final String title;
  final String category;
  final String description;
  final double price;
  final bool isPackage;
  final int numberOfTests;
  final String sampleType; // دم، بول، مسحة
  final bool isFastingRequired; // هل يحتاج صيام

  LabTest({
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    this.isPackage = false,
    this.numberOfTests = 1,
    this.sampleType = "عينة دم",
    this.isFastingRequired = false,
  });
}