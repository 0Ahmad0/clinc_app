import '../../../app/data/base_model.dart';
import '../../doctors/data/models/doctor_model.dart';
import 'clinic_details_data_source.dart';
import 'models/clinic_details_model.dart';
import 'models/clinic_review_model.dart';

class ClinicDetailsMockDataSource implements ClinicDetailsDataSource {
  @override
  Future<BaseModel<ClinicDetailsModel>> getClinicDetails(
    String clinicId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final details = ClinicDetailsModel(
      doctors: DoctorModel.mockDoctors.take(6).toList(),
      reviews: const [
        ClinicReviewModel(
          name: 'أحمد محمد',
          rating: 5.0,
          comment: 'دكتور محترم جداً وتشخيصه دقيق للغاية.',
          dateLabel: 'منذ يومين',
        ),
        ClinicReviewModel(
          name: 'سارة علي',
          rating: 4.5,
          comment: 'التعامل راقي جداً والعيادة نظيفة ومنظمة.',
          dateLabel: 'منذ أسبوع',
        ),
        ClinicReviewModel(
          name: 'ياسين كمال',
          rating: 5.0,
          comment: 'من أفضل الدكاترة في هذا التخصص بلا منازع.',
          dateLabel: 'منذ شهر',
        ),
        ClinicReviewModel(
          name: 'نور الهدى',
          rating: 4.0,
          comment: 'شرح لي الحالة بالتفصيل، شكراً دكتور.',
          dateLabel: 'منذ شهرين',
        ),
      ],
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
}
