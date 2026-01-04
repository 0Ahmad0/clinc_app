import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/home/data/models/main_home_item_model.dart';
import 'package:clinc_app_t1/modules/home/data/models/offer_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<MainHomeItemModel> mainSectionList = [
    MainHomeItemModel(
      name: LocaleKeys.home_services_clinics, // مفتاح جديد
      icon: AppAssets.clinicMedicalIcon,
      route: AppRoutes.search,
    ),
    MainHomeItemModel(
      name: LocaleKeys.home_services_labs, // مفتاح جديد
      icon: AppAssets.labsIcon,
      route: AppRoutes.labs,
    ),
    MainHomeItemModel(
      name: LocaleKeys.home_services_insurance, // مفتاح جديد
      icon: AppAssets.insuranceCardIcon,
      route: AppRoutes.insurance,
    ),
    MainHomeItemModel(
      name: LocaleKeys.home_services_chatbot, // مفتاح جديد
      icon: AppAssets.chatBotIcon,
      route: AppRoutes.chatbot,
    ),
  ];

  final List<OfferModel> offersList = [
    OfferModel(
      image: 'https://tse3.mm.bing.net/th/id/OIP.L4RloIj6B9smazJN3cKxSwHaE-?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      title: 'خصم الأطباء في مشفى المملكة',
    ),
    OfferModel(
      image: 'https://tse2.mm.bing.net/th/id/OIP.G0Eqr0TT1PO5OvKZ60_OUAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      title: 'عيادة العيون في مشفى الملك فيصل',
      subTitle: 'خصم 50%',
    ),
    OfferModel(
      image: 'https://tse1.mm.bing.net/th/id/OIP.t81S5sabzIEU7hDvOZ1M4gHaEo?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      title: 'مشفى الحبيب سلمان - جدة',
      subTitle: 'خصم 10% عمليات جلدية',
    ),
  ];
}