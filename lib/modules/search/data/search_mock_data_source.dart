import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import 'models/property_model.dart';
import 'search_data_source.dart';

class SearchMockDataSource implements SearchDataSource {
  final List<Hospital> _hospitals = Hospital.mockHospitals;

  @override
  Future<BaseModel<FiltersModel>> getFilters() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final regions = _uniqueOptions(
      _hospitals.map((hospital) => hospital.region),
    );
    final specializations = _uniqueOptions(
      _hospitals.expand((hospital) => hospital.specialties),
    );
    final insurances = _uniqueOptions(
      _hospitals.expand((hospital) => hospital.supportedInsurances),
    );
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Clinic filters retrieved successfully',
      'data': {
        'regions': regions.map((item) => item.toJson()).toList(),
        'areas': regions.map((item) => item.toJson()).toList(),
        'specializations': specializations
            .map((item) => item.toJson())
            .toList(),
        'insurances': insurances.map((item) => item.toJson()).toList(),
      },
      'meta': <String, dynamic>{},
    }, (json) => FiltersModel.fromJson(Map<String, dynamic>.from(json as Map)));
  }

  @override
  Future<BaseModel<BaseModels<Hospital>>> searchClinics(
    PaginationParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final filtered = _applyFilters(_hospitals, params.filters);
    final start = (params.page - 1) * params.perPage;
    final end = (start + params.perPage).clamp(0, filtered.length);
    final pageItems = start >= filtered.length
        ? <Hospital>[]
        : filtered.sublist(start, end);

    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Clinics retrieved successfully',
        'data': pageItems.map((hospital) => hospital.toJson()).toList(),
        'meta': {
          'current_page': params.page,
          'from': filtered.isEmpty ? 0 : start + 1,
          'path': '/api/user/clinics',
          'per_page': params.perPage,
          'to': end,
          'total': filtered.length,
        },
      },
      (json) => BaseModels<Hospital>.fromJson(
        json,
        (itemJson) =>
            Hospital.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }

  List<Hospital> _applyFilters(
    List<Hospital> hospitals,
    Map<String, dynamic> filters,
  ) {
    var results = hospitals;
    final region = filters['region_id']?.toString();
    final insurance = filters['insurance_id']?.toString();
    final specialty = filters['specialization_id']?.toString();
    final rating = double.tryParse(filters['rating']?.toString() ?? '') ?? 0;

    if (region != null && region.isNotEmpty) {
      results = results.where((hospital) => hospital.region == region).toList();
    }
    if (specialty != null && specialty.isNotEmpty) {
      results = results
          .where((hospital) => hospital.specialties.contains(specialty))
          .toList();
    }
    if (insurance != null && insurance.isNotEmpty) {
      results = results
          .where((hospital) => hospital.supportedInsurances.contains(insurance))
          .toList();
    }
    if (rating > 0) {
      results = results.where((hospital) => hospital.rating >= rating).toList();
    }

    return results;
  }

  List<FilterOptionModel> _uniqueOptions(Iterable<String> values) {
    final seen = <String>{};
    return values
        .where((value) => value.trim().isNotEmpty)
        .where(seen.add)
        .map((value) => FilterOptionModel(id: value, name: value))
        .toList();
  }
}
