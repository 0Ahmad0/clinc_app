import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/home/data/models/main_home_item_model.dart';
import 'package:clinc_app_t1/modules/home/data/models/offer_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import '../../../../app/core/constants/app_assets.dart';

class HomeController extends GetxController {
  final List<MainHomeItemModel> mainSectionList = [
    MainHomeItemModel(name: LocaleKeys.home_doctors, icon: AppAssets.doctorIcon),
    MainHomeItemModel(name: LocaleKeys.home_clinics, icon: AppAssets.clinicMedicalIcon),
    MainHomeItemModel(name: LocaleKeys.home_labs, icon: AppAssets.labsIcon),
    // MainHomeItemModel(name: LocaleKeys.home_consultations, icon: AppAssets.consultationsIcon),
    MainHomeItemModel(name: LocaleKeys.home_insurance, icon: AppAssets.insuranceCardIcon),
    MainHomeItemModel(name: LocaleKeys.home_emergency, icon: AppAssets.emergencyIcon),
  ];

  final List<OfferModel> offersList = [
    OfferModel(
      image: 'https://tse3.mm.bing.net/th/id/OIP.L4RloIj6B9smazJN3cKxSwHaE-?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      title: 'خصم الأطياء في مشفى المملكة',
    ),
    OfferModel(
      image: 'https://tse2.mm.bing.net/th/id/OIP.G0Eqr0TT1PO5OvKZ60_OUAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      title: 'عيادة العيون في مشفى الملك فيصل',
      subTitle: 'خصم 50%'
    ),
    OfferModel(
        image: 'https://tse1.mm.bing.net/th/id/OIP.t81S5sabzIEU7hDvOZ1M4gHaEo?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        title: 'مشفى الحبيب سلمان - جده',
        subTitle: 'خصم 10% عمليات جلدية'
    )
  ];
}
