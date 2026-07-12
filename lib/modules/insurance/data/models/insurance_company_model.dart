class InsuranceCompanyModel {
  const InsuranceCompanyModel({
    this.id = '',
    required this.name,
    required this.logo,
    required this.key,
  });

  final String id;
  final String name;
  final String logo;
  final String key;

  factory InsuranceCompanyModel.fromJson(Map<String, dynamic> json) {
    final key = (json['key'] ?? json['code'])?.toString() ?? '';
    return InsuranceCompanyModel(
      id: (json['id'] ?? json['insurance_id'] ?? key).toString(),
      name: json['name']?.toString() ?? '',
      logo: (json['logo'] ?? json['logo_url'])?.toString() ?? '',
      key: key,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'logo': logo,
    'key': key,
  };
}
