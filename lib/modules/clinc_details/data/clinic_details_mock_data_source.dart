import '../../../app/data/base_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../doctors/data/models/doctor_model.dart';
import 'clinic_details_data_source.dart';
import 'models/clinic_details_model.dart';
import 'models/clinic_review_model.dart';

class ClinicDetailsMockDataSource implements ClinicDetailsDataSource {
  final List<ClinicReviewModel> _reviews = <ClinicReviewModel>[
    const ClinicReviewModel(
      name: 'أحمد محمد',
      rating: 5.0,
      comment: 'دكتور محترم جداً وتشخيصه دقيق للغاية.',
      dateLabel: 'منذ يومين',
    ),
    const ClinicReviewModel(
      name: 'سارة علي',
      rating: 4.5,
      comment: 'التعامل راقي جداً والعيادة نظيفة ومنظمة.',
      dateLabel: 'منذ أسبوع',
    ),
    const ClinicReviewModel(
      name: 'ياسين كمال',
      rating: 5.0,
      comment: 'من أفضل الدكاترة في هذا التخصص بلا منازع.',
      dateLabel: 'منذ شهر',
    ),
    const ClinicReviewModel(
      name: 'نور الهدى',
      rating: 4.0,
      comment: 'شرح لي الحالة بالتفصيل، شكراً دكتور.',
      dateLabel: 'منذ شهرين',
    ),
  ];

  @override
  Future<BaseModel<ClinicDetailsModel>> getClinicDetails(
    String clinicId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final details = ClinicDetailsModel(
      doctors: BaseModel<BaseModels<DoctorModel>>.fromJson(
        _paginatedResponse(
          DoctorModel.mockDoctors.take(6).map((doctor) => doctor.toJson()),
        ),
        (json) => BaseModels<DoctorModel>.fromJson(
          json,
          (itemJson) =>
              DoctorModel.fromJson(Map<String, dynamic>.from(itemJson as Map)),
        ),
      ),
      reviews: BaseModel<BaseModels<ClinicReviewModel>>.fromJson(
        _paginatedResponse(_reviews.map((review) => review.toJson())),
        (json) => BaseModels<ClinicReviewModel>.fromJson(
          json,
          (itemJson) => ClinicReviewModel.fromJson(
            Map<String, dynamic>.from(itemJson as Map),
          ),
        ),
      ),
    );

    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Clinic details retrieved successfully',
        'data': details.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) =>
          ClinicDetailsModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<BaseModels<ClinicReviewModel>>> getClinicReviews(
    String clinicId,
    PaginationParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final start = (params.page - 1) * params.perPage;
    final pageItems = _reviews.skip(start).take(params.perPage).toList();
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Clinic reviews retrieved successfully',
        'data': pageItems.map((review) => review.toJson()).toList(),
        'meta': _meta(pageItems.length, params, _reviews.length),
      },
      (json) => BaseModels<ClinicReviewModel>.fromJson(
        json,
        (itemJson) => ClinicReviewModel.fromJson(
          Map<String, dynamic>.from(itemJson as Map),
        ),
      ),
    );
  }

  @override
  Future<BaseModel<ClinicReviewModel>> addClinicReview({
    required String clinicId,
    required double rating,
    required String comment,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final review = ClinicReviewModel(
      name: 'مستخدم حالي',
      rating: rating,
      comment: comment,
      dateLabel: 'الآن',
    );
    _reviews.insert(0, review);
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Clinic review submitted successfully',
        'data': review.toJson(),
      },
      (json) =>
          ClinicReviewModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  Map<String, dynamic> _paginatedResponse(Iterable<Map<String, dynamic>> data) {
    final list = data.toList();

    return {
      'status': 'success',
      'data': list,
      'meta': {
        'current_page': 1,
        'from': list.isEmpty ? 0 : 1,
        'to': list.length,
        'per_page': list.length,
        'total': list.length,
      },
    };
  }

  Map<String, dynamic> _meta(int count, PaginationParams params, int total) {
    final from = total == 0 ? 0 : ((params.page - 1) * params.perPage) + 1;
    return {
      'current_page': params.page,
      'from': count == 0 ? 0 : from,
      'to': count == 0 ? 0 : from + count - 1,
      'per_page': params.perPage,
      'total': total,
    };
  }
}
