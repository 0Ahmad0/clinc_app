class Hospital {
  final String id;
  final String name;
  final String region;
  final double consultationFee;
  final double distanceKm;
  final String imageUrl;
  final double rating;
  final List<String> specialties;      // قائمة التخصصات للفلترة
  final List<String> supportedInsurances; // قائمة شركات التأمين
  final String workTime;              // صباحي، مسائي، أو كلاهما
  final bool isOpen;                  // هل العيادة مفتوحة الآن؟

  Hospital({
    required this.id,
    required this.name,
    required this.region,
    required this.consultationFee,
    required this.distanceKm,
    required this.imageUrl,
    required this.rating,
    required this.specialties,
    required this.supportedInsurances,
    required this.workTime,
    required this.isOpen,
  });

  // خاصية مساعدة للـ UI: هل يقبل أي تأمين؟
  bool get isInsuranceAccepted => supportedInsurances.isNotEmpty;

  // --- بيانات وهمية للتجربة (Mock Data) ---
  static List<Hospital> mockHospitals = [
    Hospital(
      id: '1',
      name: 'مجمع عيادات النخبة',
      region: 'الرياض',
      consultationFee: 150,
      distanceKm: 2.5,
      imageUrl: 'https://img.saudigerman.com/wp-content/uploads/2023/07/18105443/VML_1038-1536x1024.jpeg',
      rating: 4.8,
      specialties: ['أسنان', 'جلدية', 'ليزر'],
      supportedInsurances: ['بوبا العربية (Bupa Arabia)', 'التعاونية (Tawuniya)'],
      workTime: 'صباحي',
      isOpen: true,
    ),
    Hospital(
      id: '2',
      name: 'مستشفى د. سليمان الحبيب',
      region: 'جدة',
      consultationFee: 300,
      distanceKm: 12.0,
      imageUrl: 'https://hmg.com/en/MediaCenter/News/PublishingImages/2021/November/HMG-News-2021-11-21-1.jpg',
      rating: 4.9,
      specialties: ['باطنية', 'عيون', 'أذن وحنجرة'],
      supportedInsurances: ['ميدغلف (MEDGULF)'],
      workTime: 'مسائي',
      isOpen: false,
    ),
    Hospital(
      id: '3',
      name: 'عيادات السمو الطبية',
      region: 'الدمام',
      consultationFee: 100,
      distanceKm: 5.5,
      imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      rating: 4.2,
      specialties: ['أسنان', 'عيون'],
      supportedInsurances: [], // لا يقبل التأمين
      workTime: 'صباحي',
      isOpen: true,
    ),
    Hospital(
      id: '4',
      name: 'مجمع العناية المتكاملة',
      region: 'الرياض',
      consultationFee: 200,
      distanceKm: 8.0,
      imageUrl: 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      rating: 4.5,
      specialties: ['باطنية', 'جلدية'],
      supportedInsurances: ['الراجحي التكافلي (Al Rajhi Takaful)', 'ولاء للتأمين (Walaa)'],
      workTime: 'مسائي',
      isOpen: true,
    ),
  ];
}