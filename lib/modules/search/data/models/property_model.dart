class Hospital {
  final String id;
  final String name;
  final String region;
  final double consultationFee;
  final double distanceKm;
  final String imageUrl;
  final String? phone;
  final double rating;
  final List<String> specialties; // قائمة التخصصات للفلترة
  final List<String> supportedInsurances; // قائمة شركات التأمين
  final String workTime; // صباحي، مسائي، أو كلاهما
  final bool isOpen; // هل العيادة مفتوحة الآن؟
  final double latitude;
  final double longitude;

  const Hospital({
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
    this.phone,
    this.latitude = 0,
    this.longitude = 0,
  });

  // خاصية مساعدة للـ UI: هل يقبل أي تأمين؟
  bool get isInsuranceAccepted => supportedInsurances.isNotEmpty;

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      consultationFee:
          double.tryParse(json['consultation_fee']?.toString() ?? '') ?? 0,
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '') ?? 0,
      imageUrl: json['image_url']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      specialties: _stringList(json['specialties']),
      supportedInsurances: _stringList(json['supported_insurances']),
      workTime: json['work_time']?.toString() ?? '',
      phone: json['phone'],
      latitude: _double(
        json['latitude'] ?? json['lat'] ?? json['clinic_latitude'],
      ),
      longitude: _double(
        json['longitude'] ??
            json['lng'] ??
            json['long'] ??
            json['clinic_longitude'],
      ),
      isOpen: json['is_open'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'region': region,
    'consultation_fee': consultationFee,
    'distance_km': distanceKm,
    'image_url': imageUrl,
    'rating': rating,
    'specialties': specialties,
    'supported_insurances': supportedInsurances,
    'work_time': workTime,
    'is_open': isOpen,
    'phone': phone,
    'latitude': latitude,
    'longitude': longitude,
  };

  static List<String> _stringList(dynamic value) {
    if (value is! List) return <String>[];
    return value.map((item) => item.toString()).toList();
  }

  static double _double(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  // --- بيانات وهمية للتجربة (Mock Data) ---
  static List<Hospital> mockHospitals = [
    const Hospital(
      id: '1',
      name: 'مجمع عيادات النخبة',
      region: 'الرياض',
      consultationFee: 150,
      distanceKm: 2.5,
      imageUrl:
          'https://img.saudigerman.com/wp-content/uploads/2023/07/18105443/VML_1038-1536x1024.jpeg',
      rating: 4.8,
      specialties: ['أسنان', 'جلدية', 'ليزر'],
      supportedInsurances: [
        'بوبا العربية (Bupa Arabia)',
        'التعاونية (Tawuniya)',
      ],
      workTime: 'صباحي',
      isOpen: true,
    ),
    const Hospital(
      id: '2',
      name: 'مستشفى د. سليمان الحبيب',
      region: 'جدة',
      consultationFee: 300,
      distanceKm: 12.0,
      imageUrl:
          'https://hmg.com/en/MediaCenter/News/PublishingImages/2021/November/HMG-News-2021-11-21-1.jpg',
      rating: 4.9,
      specialties: ['باطنية', 'عيون', 'أذن وحنجرة'],
      supportedInsurances: ['ميدغلف (MEDGULF)'],
      workTime: 'مسائي',
      isOpen: false,
    ),
    const Hospital(
      id: '3',
      name: 'عيادات السمو الطبية',
      region: 'الدمام',
      consultationFee: 100,
      distanceKm: 5.5,
      imageUrl:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      rating: 4.2,
      specialties: ['أسنان', 'عيون'],
      supportedInsurances: [], // لا يقبل التأمين
      workTime: 'صباحي',
      isOpen: true,
    ),
    const Hospital(
      id: '4',
      name: 'مجمع العناية المتكاملة',
      region: 'الرياض',
      consultationFee: 200,
      distanceKm: 8.0,
      imageUrl:
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      rating: 4.5,
      specialties: ['باطنية', 'جلدية'],
      supportedInsurances: [
        'الراجحي التكافلي (Al Rajhi Takaful)',
        'ولاء للتأمين (Walaa)',
      ],
      workTime: 'مسائي',
      isOpen: true,
    ),
    const Hospital(
      id: '5',
      name: 'مركز إشراق الطبي',
      region: 'القصيم',
      consultationFee: 180,
      distanceKm: 6.2,
      imageUrl:
          'https://images.unsplash.com/photo-1504439468489-c8920d796a29?auto=format&fit=crop&w=1000&q=80',
      rating: 4.4,
      specialties: ['جلدية', 'ليزر'],
      supportedInsurances: ['سلامة للتأمين (Salama)'],
      workTime: 'صباحي',
      isOpen: true,
    ),
    const Hospital(
      id: '6',
      name: 'عيادات الرؤية الحديثة',
      region: 'تبوك',
      consultationFee: 220,
      distanceKm: 10.4,
      imageUrl:
          'https://images.unsplash.com/photo-1512678080530-7760d81faba6?auto=format&fit=crop&w=1000&q=80',
      rating: 4.6,
      specialties: ['عيون', 'باطنية'],
      supportedInsurances: ['التعاونية (Tawuniya)'],
      workTime: 'مسائي',
      isOpen: false,
    ),
    const Hospital(
      id: '7',
      name: 'مجمع السلامة الصحي',
      region: 'أبها',
      consultationFee: 130,
      distanceKm: 3.8,
      imageUrl:
          'https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=1000&q=80',
      rating: 4.1,
      specialties: ['أسنان', 'أذن وحنجرة'],
      supportedInsurances: ['ولاء للتأمين (Walaa)'],
      workTime: 'صباحي',
      isOpen: true,
    ),
    const Hospital(
      id: '8',
      name: 'مستشفى المدينة التخصصي',
      region: 'المدينة المنورة',
      consultationFee: 260,
      distanceKm: 14.1,
      imageUrl:
          'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?auto=format&fit=crop&w=1000&q=80',
      rating: 4.7,
      specialties: ['باطنية', 'عيون', 'جلدية'],
      supportedInsurances: ['ميدغلف (MEDGULF)', 'بوبا العربية (Bupa Arabia)'],
      workTime: 'مسائي',
      isOpen: true,
    ),
    const Hospital(
      id: '9',
      name: 'عيادات مكة الطبية',
      region: 'مكة المكرمة',
      consultationFee: 170,
      distanceKm: 7.0,
      imageUrl:
          'https://images.unsplash.com/photo-1551190822-a9333d879b1f?auto=format&fit=crop&w=1000&q=80',
      rating: 4.3,
      specialties: ['أسنان', 'باطنية'],
      supportedInsurances: [],
      workTime: 'صباحي',
      isOpen: false,
    ),
    const Hospital(
      id: '10',
      name: 'مجمع الشرق الطبي',
      region: 'المنطقة الشرقية',
      consultationFee: 210,
      distanceKm: 9.5,
      imageUrl:
          'https://images.unsplash.com/photo-1519494080410-f9aa8f52f1e4?auto=format&fit=crop&w=1000&q=80',
      rating: 4.5,
      specialties: ['ليزر', 'جلدية'],
      supportedInsurances: ['الراجحي التكافلي (Al Rajhi Takaful)'],
      workTime: 'مسائي',
      isOpen: true,
    ),
  ];
}
