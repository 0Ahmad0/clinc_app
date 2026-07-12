class FilterOptionModel {
  const FilterOptionModel({
    required this.id,
    required this.name,
    this.parentId,
    this.children = const <FilterOptionModel>[],
  });

  final String id;
  final String name;
  final String? parentId;
  final List<FilterOptionModel> children;

  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    final childrenJson =
        (json['children'] ?? json['areas'] ?? json['services']) as List?;
    return FilterOptionModel(
      id: (json['id'] ?? json['value'] ?? json['key'])?.toString() ?? '',
      name:
          (json['name'] ??
                  json['name_ar'] ??
                  json['title'] ??
                  json['label'] ??
                  json['name_en'])
              ?.toString() ??
          '',
      parentId: (json['parent_id'] ?? json['region_id'] ?? json['category_id'])
          ?.toString(),
      children:
          childrenJson
              ?.whereType<Map>()
              .map((item) => FilterOptionModel.fromJson(Map.from(item)))
              .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
              .toList() ??
          const <FilterOptionModel>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (parentId != null) 'parent_id': parentId,
    if (children.isNotEmpty)
      'children': children.map((item) => item.toJson()).toList(),
  };
}

class FiltersModel {
  const FiltersModel({
    this.regions = const <FilterOptionModel>[],
    this.areas = const <FilterOptionModel>[],
    this.specializations = const <FilterOptionModel>[],
    this.insurances = const <FilterOptionModel>[],
    this.categories = const <FilterOptionModel>[],
    this.services = const <FilterOptionModel>[],
    this.genders = const <FilterOptionModel>[],
    this.ratings = const <FilterOptionModel>[],
  });

  final List<FilterOptionModel> regions;
  final List<FilterOptionModel> areas;
  final List<FilterOptionModel> specializations;
  final List<FilterOptionModel> insurances;
  final List<FilterOptionModel> categories;
  final List<FilterOptionModel> services;
  final List<FilterOptionModel> genders;
  final List<FilterOptionModel> ratings;

  factory FiltersModel.fromJson(Map<String, dynamic> json) {
    return FiltersModel(
      regions: _options(json, const ['regions']),
      areas: _options(json, const ['areas']),
      specializations: _options(json, const [
        'specializations',
        'specialties',
        'specialties_list',
      ]),
      insurances: _options(json, const ['insurances', 'insurance_companies']),
      categories: _options(json, const ['categories']),
      services: _options(json, const ['services']),
      genders: _options(json, const ['genders', 'gender']),
      ratings: _options(json, const ['ratings', 'rating']),
    );
  }

  static List<FilterOptionModel> _options(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is List) {
        return value
            .map(_optionFromDynamic)
            .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
            .toList();
      }
    }
    return const <FilterOptionModel>[];
  }

  static FilterOptionModel _optionFromDynamic(dynamic value) {
    if (value is Map) {
      return FilterOptionModel.fromJson(Map<String, dynamic>.from(value));
    }
    final text = value?.toString() ?? '';
    return FilterOptionModel(id: text, name: text);
  }
}
