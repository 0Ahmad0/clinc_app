class LabModel {
  final String id;
  final String name;
  final String imageUrl;
  final String address;
  final double rating;
  final bool isOpen;
  final String category;
  final String description;
  final List<String> services;
  final String phoneNumber;

  LabModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.isOpen,
    required this.category,
    required this.description,
    required this.services,
    required this.phoneNumber,
  });

  // --- إضافة دالة التحويل من Map ---
  factory LabModel.fromMap(Map<String, dynamic> map) {
    return LabModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      address: map['address'] ?? '',
      rating: double.tryParse(map['rating'].toString()) ?? 0.0,
      isOpen: map['isOpen'] == true || map['isOpen'].toString() == 'true',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      // التعامل مع الليست بذكاء لتجنب الكراش
      services: map['services'] != null
          ? List<String>.from(map['services'])
          : [],
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}