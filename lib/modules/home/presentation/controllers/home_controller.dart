import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/home/data/models/offer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<String> mainSectionList = [
    tr(LocaleKeys.home_doctors),
    tr(LocaleKeys.home_clinics),
    tr(LocaleKeys.home_specialities),
    tr(LocaleKeys.home_labs),
    tr(LocaleKeys.home_insurance),
    tr(LocaleKeys.home_emergency),
  ];

  final List<Offer> offersList = [
    Offer(
      image: 'https://tse3.mm.bing.net/th/id/OIP.L4RloIj6B9smazJN3cKxSwHaE-?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      title: 'خصم الأطياء في مشفى المملكة',
    ),
    Offer(
      image: 'https://tse2.mm.bing.net/th/id/OIP.G0Eqr0TT1PO5OvKZ60_OUAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      title: 'عيادة العيون في مشفى الملك فيصل',
      subTitle: 'خصم 50%'
    ),
    Offer(
        image: 'https://tse1.mm.bing.net/th/id/OIP.t81S5sabzIEU7hDvOZ1M4gHaEo?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3',
        title: 'مشفى الحبيب سلمان - جده',
        subTitle: 'خصم 10% عمليات جلدية'
    )
  ];
}
