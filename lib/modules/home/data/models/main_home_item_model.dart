class MainHomeItemModel {
  final String name;
  final String icon;
  final String route;

  const MainHomeItemModel({
    required this.name,
    required this.icon,
    required this.route,
  });

  factory MainHomeItemModel.fromJson(Map<String, dynamic> json) {
    return MainHomeItemModel(
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      route: json['route']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'icon': icon, 'route': route};
}
