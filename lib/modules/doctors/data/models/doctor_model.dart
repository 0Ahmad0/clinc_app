class DoctorModel {
  final String id;
  final String name;
  final String specialty; // التخصص
  final String region; // المنطقة
  final String gender; // الجنس: 'ذكر' أو 'أنثى'
  final double rating; // التقييم
  final double price; // سعر الكشفية
  final String imageUrl;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.region,
    required this.gender,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'region': region,
    'gender': gender,
    'rating': rating,
    'price': price,
    'image_url': imageUrl,
  };

  // بيانات وهمية للتجربة
  static List<DoctorModel> get mockDoctors => [
    const DoctorModel(
      id: '1',
      name: 'د. محمد علي',
      specialty: 'قلب',
      region: 'الرياض',
      gender: 'ذكر',
      rating: 4.8,
      price: 300,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '2',
      name: 'د. سارة أحمد',
      specialty: 'جلدية',
      region: 'جدة',
      gender: 'أنثى',
      rating: 4.9,
      price: 250,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '3',
      name: 'د. خالد عمر',
      specialty: 'أسنان',
      region: 'الدمام',
      gender: 'ذكر',
      rating: 3.5,
      price: 150,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '4',
      name: 'د. نورة سالم',
      specialty: 'عيون',
      region: 'الرياض',
      gender: 'أنثى',
      rating: 4.2,
      price: 200,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '5',
      name: 'د. فهد الدوسري',
      specialty: 'قلب',
      region: 'أبها',
      gender: 'ذكر',
      rating: 4.0,
      price: 280,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '6',
      name: 'د. ريم القحطاني',
      specialty: 'باطنية',
      region: 'القصيم',
      gender: 'أنثى',
      rating: 4.7,
      price: 220,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '7',
      name: 'د. مازن الحربي',
      specialty: 'أسنان',
      region: 'المدينة المنورة',
      gender: 'ذكر',
      rating: 4.4,
      price: 180,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '8',
      name: 'د. ليان منصور',
      specialty: 'عيون',
      region: 'تبوك',
      gender: 'أنثى',
      rating: 4.6,
      price: 240,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '9',
      name: 'د. عبدالعزيز المالكي',
      specialty: 'قلب',
      region: 'مكة المكرمة',
      gender: 'ذكر',
      rating: 4.9,
      price: 320,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '10',
      name: 'د. هبة الجهني',
      specialty: 'جلدية',
      region: 'حائل',
      gender: 'أنثى',
      rating: 3.9,
      price: 190,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '11',
      name: 'د. سامي الشمري',
      specialty: 'باطنية',
      region: 'المنطقة الشرقية',
      gender: 'ذكر',
      rating: 4.1,
      price: 210,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
    const DoctorModel(
      id: '12',
      name: 'د. مها عسيري',
      specialty: 'جلدية',
      region: 'عسير',
      gender: 'أنثى',
      rating: 4.3,
      price: 205,
      imageUrl:
          "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
    ),
  ];
}
