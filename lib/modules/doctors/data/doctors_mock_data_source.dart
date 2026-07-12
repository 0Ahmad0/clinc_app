import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import 'doctors_data_source.dart';
import 'models/doctor_details_model.dart';
import 'models/doctor_model.dart';
import 'models/doctor_review_model.dart';

class DoctorsMockDataSource implements DoctorsDataSource {
  final List<DoctorModel> _doctors = DoctorModel.mockDoctors;
  final Set<String> _favoriteDoctorIds = <String>{'1'};
  final Map<String, List<DoctorReviewModel>> _reviewsByDoctorId = {
    '1': const [
      DoctorReviewModel(
        id: '1',
        userName: 'أحمد محمد',
        userImage: 'https://i.pravatar.cc/150?img=12',
        rating: 5.0,
        comment: 'دكتور محترم جداً وتشخيصه دقيق للغاية.',
        date: 'منذ يومين',
      ),
      DoctorReviewModel(
        id: '2',
        userName: 'سارة علي',
        userImage: 'https://i.pravatar.cc/150?img=5',
        rating: 4.5,
        comment: 'التعامل راقي جداً والعيادة نظيفة ومنظمة.',
        date: 'منذ أسبوع',
      ),
    ],
  };

  @override
  Future<BaseModel<FiltersModel>> getFilters() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final regions = _uniqueOptions(_doctors.map((doctor) => doctor.region));
    final specializations = _uniqueOptions(
      _doctors.map((doctor) => doctor.specialty),
    );
    final genders = _uniqueOptions(_doctors.map((doctor) => doctor.gender));
    final ratings = _uniqueOptions(
      _doctors.map((doctor) => doctor.rating.toString()),
    );
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Doctor filters retrieved successfully',
      'data': {
        'regions': regions.map((item) => item.toJson()).toList(),
        'areas': regions.map((item) => item.toJson()).toList(),
        'specializations': specializations
            .map((item) => item.toJson())
            .toList(),
        'genders': genders.map((item) => item.toJson()).toList(),
        'ratings': ratings.map((item) => item.toJson()).toList(),
      },
      'meta': <String, dynamic>{},
    }, (json) => FiltersModel.fromJson(Map<String, dynamic>.from(json as Map)));
  }

  @override
  Future<BaseModel<BaseModels<DoctorModel>>> getDoctors(
    PaginationParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final filtered = _applyFilters(_doctors, params.filters);
    final start = (params.page - 1) * params.perPage;
    final end = (start + params.perPage).clamp(0, filtered.length);
    final pageItems = start >= filtered.length
        ? <DoctorModel>[]
        : filtered.sublist(start, end);

    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Doctors retrieved successfully',
        'data': pageItems.map((doctor) => doctor.toJson()).toList(),
        'meta': {
          'current_page': params.page,
          'from': filtered.isEmpty ? 0 : start + 1,
          'path': '/api/user/doctors',
          'per_page': params.perPage,
          'to': end,
          'total': filtered.length,
        },
      },
      (json) => BaseModels<DoctorModel>.fromJson(
        json,
        (itemJson) =>
            DoctorModel.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }

  @override
  Future<BaseModel<DoctorDetailsModel>> getDoctorDetails(
    String doctorId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final doctor = _findDoctor(doctorId);
    final reviews = _reviewsFor(doctorId);
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Doctor details retrieved successfully',
        'data': {
          'doctor': doctor.toJson(),
          'reviews': reviews.map((review) => review.toJson()).toList(),
          'is_favorite': _favoriteDoctorIds.contains(doctorId),
          'patient_count': 7500,
          'years_experience': 10,
          'about':
              'الدكتور ${doctor.name} متخصص في ${doctor.specialty}. يتمتع بخبرة واسعة في تشخيص وعلاج أدق الحالات الطبية باستخدام أحدث التقنيات المتاحة عالمياً.',
        },
        'meta': <String, dynamic>{},
      },
      (json) =>
          DoctorDetailsModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<BaseModels<DoctorReviewModel>>> getDoctorReviews(
    String doctorId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Doctor reviews retrieved successfully',
        'data': _reviewsFor(doctorId).map((review) => review.toJson()).toList(),
        'meta': {
          'current_page': 1,
          'from': _reviewsFor(doctorId).isEmpty ? 0 : 1,
          'to': _reviewsFor(doctorId).length,
          'per_page': _reviewsFor(doctorId).length,
          'total': _reviewsFor(doctorId).length,
        },
      },
      (json) => BaseModels<DoctorReviewModel>.fromJson(
        json,
        (itemJson) => DoctorReviewModel.fromJson(
          Map<String, dynamic>.from(itemJson as Map),
        ),
      ),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> toggleDoctorFavorite(
    String doctorId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (_favoriteDoctorIds.contains(doctorId)) {
      _favoriteDoctorIds.remove(doctorId);
    } else {
      _favoriteDoctorIds.add(doctorId);
    }
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Favorite status updated successfully',
      'data': {
        'doctor_id': doctorId,
        'is_favorite': _favoriteDoctorIds.contains(doctorId),
      },
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }

  @override
  Future<BaseModel<DoctorReviewModel>> addDoctorReview({
    required String doctorId,
    required double rating,
    required String comment,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final review = DoctorReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'مستخدم حالي',
      userImage: 'https://i.pravatar.cc/150?img=3',
      rating: rating,
      comment: comment,
      date: 'الآن',
    );
    _reviewsFor(doctorId).insert(0, review);
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Review submitted successfully',
        'data': review.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) =>
          DoctorReviewModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  List<DoctorModel> _applyFilters(
    List<DoctorModel> doctors,
    Map<String, dynamic> filters,
  ) {
    var results = doctors;
    final region = filters['region_id']?.toString();
    final specialty = filters['specialization_id']?.toString();
    final rating = double.tryParse(filters['rating']?.toString() ?? '') ?? 0;

    if (region != null && region.isNotEmpty) {
      results = results.where((doctor) => doctor.region == region).toList();
    }
    if (specialty != null && specialty.isNotEmpty) {
      results = results
          .where((doctor) => doctor.specialty == specialty)
          .toList();
    }
    if (rating > 0) {
      results = results.where((doctor) => doctor.rating >= rating).toList();
    }

    return results;
  }

  DoctorModel _findDoctor(String doctorId) {
    return _doctors.firstWhere(
      (doctor) => doctor.id == doctorId,
      orElse: () => _doctors.first,
    );
  }

  List<DoctorReviewModel> _reviewsFor(String doctorId) {
    return _reviewsByDoctorId.putIfAbsent(
      doctorId,
      () => [
        const DoctorReviewModel(
          id: 'default_1',
          userName: 'ياسين كمال',
          userImage: 'https://i.pravatar.cc/150?img=14',
          rating: 5.0,
          comment: 'من أفضل الدكاترة في هذا التخصص بلا منازع.',
          date: 'منذ شهر',
        ),
        const DoctorReviewModel(
          id: 'default_2',
          userName: 'نور الهدى',
          userImage: 'https://i.pravatar.cc/150?img=9',
          rating: 4.0,
          comment: 'شرح لي الحالة بالتفصيل، شكراً دكتور.',
          date: 'منذ شهرين',
        ),
      ],
    );
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
