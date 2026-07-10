import '../../../app/data/base_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import 'models/property_model.dart';
import 'search_data_source.dart';

class SearchMockDataSource implements SearchDataSource {
  final List<Hospital> _hospitals = Hospital.mockHospitals;

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
    final query = filters['query']?.toString().trim().toLowerCase();
    final region = filters['region']?.toString();
    final insurance = filters['insurance']?.toString();
    final specialty = filters['specialty']?.toString();
    final sort = filters['sort']?.toString() ?? 'priceAsc';

    if (query != null && query.isNotEmpty) {
      results = results
          .where((hospital) => hospital.name.toLowerCase().contains(query))
          .toList();
    }
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

    results = [...results];
    results.sort((a, b) {
      switch (sort) {
        case 'priceDesc':
          return b.consultationFee.compareTo(a.consultationFee);
        case 'distanceAsc':
          return a.distanceKm.compareTo(b.distanceKm);
        case 'priceAsc':
        default:
          return a.consultationFee.compareTo(b.consultationFee);
      }
    });

    return results;
  }
}
