// lib/models/hospital_model.dart
class Hospital {
  final String id;
  final String name;
  final String region; // المنطقة (مثل الرياض، جدة)
  final double consultationFee; // سعر الاستشارة
  final double distanceKm; // القرب بالكيلومتر

  Hospital({
    required this.id,
    required this.name,
    required this.region,
    required this.consultationFee,
    required this.distanceKm,
  });

  // بيانات وهمية (Mock Data) للاختبار
  static List<Hospital> mockHospitals = [
    Hospital(id: '1', name: 'مستشفى الأمل', region: 'الرياض', consultationFee: 150.0, distanceKm: 5.2),
    Hospital(id: '2', name: 'مركز الشفاء', region: 'جدة', consultationFee: 200.0, distanceKm: 1.5),
    Hospital(id: '3', name: 'عيادة النور', region: 'الرياض', consultationFee: 80.0, distanceKm: 12.0),
    Hospital(id: '4', name: 'المستشفى التخصصي', region: 'الدمام', consultationFee: 350.0, distanceKm: 3.1),
    Hospital(id: '5', name: 'مركز صحة العائلة', region: 'جدة', consultationFee: 120.0, distanceKm: 8.5),
    Hospital(id: '6', name: 'مستشفى الحياة', region: 'مكة المكرمة', consultationFee: 180.0, distanceKm: 4.9),
  ];

  // قائمة المناطق المتاحة (مناطق السعودية)
  static List<String> availableRegions = ['الكل', 'الرياض', 'جدة', 'الدمام', 'مكة المكرمة'];
}