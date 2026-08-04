import '../../../app/core/constants/app_assets.dart';
import '../../../app/data/base_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../generated/locale_keys.g.dart';
import 'home_data_source.dart';
import 'models/ad_model.dart';
import 'models/home_model.dart';
import 'models/main_home_item_model.dart';

class HomeMockDataSource implements HomeDataSource {
  static const List<MainHomeItemModel> defaultMainServices = [
    MainHomeItemModel(
      name: LocaleKeys.home_services_clinics,
      icon: AppAssets.clinicMedicalIcon,
      route: AppRoutes.search,
    ),
    MainHomeItemModel(
      name: LocaleKeys.home_services_labs,
      icon: AppAssets.labsIcon,
      route: AppRoutes.labs,
    ),
    MainHomeItemModel(
      name: LocaleKeys.home_services_insurance,
      icon: AppAssets.insuranceCardIcon,
      route: AppRoutes.insurance,
    ),
    MainHomeItemModel(
      name: LocaleKeys.home_services_chatbot,
      icon: AppAssets.chatBotIcon,
      route: AppRoutes.chatbot,
    ),
  ];

  static const HomeModel _home = HomeModel(
    user: HomeUserModel(
      fullName: 'أحلام الحرير',
      avatar:
          'https://tse1.mm.bing.net/th/id/OIP.lj2NFJ7HSEsDqn7er7BuDAHaHa?cb=ucfimg2&ucfimg=1&w=626&h=626&rs=1&pid=ImgDetMain&o=7&rm=3',
    ),
    unreadNotificationsCount: 3,
    mainServices: defaultMainServices,
    ads: [
      AdModel(
        id: '1',
        title: 'خصم الأطباء في مشفى المملكة',
        titleAr: 'خصم الأطباء في مشفى المملكة',
        titleEn: 'Doctors discount at Kingdom Hospital',
        description: '',
        descriptionAr: '',
        descriptionEn: '',
        cover:
            'https://tse3.mm.bing.net/th/id/OIP.L4RloIj6B9smazJN3cKxSwHaE-?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        linkUrl: '',
        startsAt: '',
        endsAt: '',
        publishedAt: '',
      ),
      AdModel(
        id: '2',
        title: 'عيادة العيون في مشفى الملك فيصل',
        titleAr: 'عيادة العيون في مشفى الملك فيصل',
        titleEn: 'Eye clinic at King Faisal Hospital',
        description: 'خصم 50%',
        descriptionAr: 'خصم 50%',
        descriptionEn: '50% discount',
        cover:
            'https://tse2.mm.bing.net/th/id/OIP.G0Eqr0TT1PO5OvKZ60_OUAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        linkUrl: '',
        startsAt: '',
        endsAt: '',
        publishedAt: '',
      ),
      AdModel(
        id: '3',
        title: 'مشفى الحبيب سلمان - جدة',
        titleAr: 'مشفى الحبيب سلمان - جدة',
        titleEn: 'Al Habib Salman Hospital - Jeddah',
        description: 'خصم 10% عمليات جلدية',
        descriptionAr: 'خصم 10% عمليات جلدية',
        descriptionEn: '10% discount on dermatology procedures',
        cover:
            'https://tse1.mm.bing.net/th/id/OIP.t81S5sabzIEU7hDvOZ1M4gHaEo?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        linkUrl: '',
        startsAt: '',
        endsAt: '',
        publishedAt: '',
      ),
    ],
    activeAppointment: HomeAppointmentModel(
      doctorName: 'د. سارة العلي',
      specialty: 'أخصائية أنف وأذن وحنجرة',
      clinicName: 'مشفى الأميرة نورة',
      imageUrl:
          'https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg',
      date: 'الأربعاء، 10 يناير 2024',
      time: '11:00 AM',
    ),
  );

  @override
  Future<BaseModel<HomeModel>> getHome() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Home retrieved successfully',
      'data': _home.toJson(),
      'meta': <String, dynamic>{},
    }, (json) => HomeModel.fromJson(Map<String, dynamic>.from(json as Map)));
  }
}
