class InsuranceCompanyModel {
  const InsuranceCompanyModel({
    required this.name,
    required this.logo,
    required this.key,
  });

  final String name;
  final String logo;
  final String key;

  factory InsuranceCompanyModel.fromJson(Map<String, dynamic> json) {
    return InsuranceCompanyModel(
      name: json['name']?.toString() ?? '',
      logo: (json['logo'] ?? json['logo_url'])?.toString() ?? '',
      key: (json['key'] ?? json['code'])?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'logo': logo, 'key': key};
}
