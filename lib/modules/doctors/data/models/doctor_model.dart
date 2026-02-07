class DoctorModel {
  final String id;
  final String name;
  final String specialty; // التخصص
  final String region; // المنطقة
  final String gender; // الجنس: 'ذكر' أو 'أنثى'
  final double rating; // التقييم
  final double price; // سعر الكشفية
  final String imageUrl;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.region,
    required this.gender,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });

  // بيانات وهمية للتجربة
  static List<DoctorModel> get mockDoctors => [
    DoctorModel(
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
    DoctorModel(
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
    DoctorModel(
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
    DoctorModel(
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
    DoctorModel(
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
  ];
}
