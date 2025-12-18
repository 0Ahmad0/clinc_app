import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:get/get.dart';

import '../../data/enum/appointment_status.dart';
import '../../data/models/filter_model.dart';
import '../../data/models/order_model.dart';


class AppointmentsController extends GetxController {
  final  List<FilterModel> quotationsFilterList = [
    FilterModel(
      name: 'الكل',
    ),
    FilterModel(
      name: 'المقبولة',
      icon: AppAssets.checkCircleIcon,
    ),
    FilterModel(
      name: 'الجارية',
      icon: AppAssets.waitingIcon,
    ),
    FilterModel(
      name: 'المرفوضة',
      icon: AppAssets.rejectedCircleIcon,
    ),
  ];

  RxInt currentFilterIndex = 0.obs;

  final RxList<AppointmentModel> allOrders = <AppointmentModel>[

    AppointmentModel(id: 'QQ1122Z', price: 850, status: AppointmentStatus.accepted),
    AppointmentModel(id: 'AF1250H', price: 1000, status: AppointmentStatus.rejected),
    AppointmentModel(id: 'XY4231J', price: 750, status: AppointmentStatus.accepted),
    AppointmentModel(id: 'GH7723L', price: 500, status: AppointmentStatus.pending),
    AppointmentModel(id: 'XY4231J', price: 750, status: AppointmentStatus.accepted),
    AppointmentModel(id: 'XY4231J', price: 750, status: AppointmentStatus.accepted),
    AppointmentModel(id: 'AF1250H', price: 1000, status: AppointmentStatus.rejected),
    AppointmentModel(id: 'GH7723L', price: 500, status: AppointmentStatus.pending),
    AppointmentModel(id: 'QQ1122Z', price: 850, status: AppointmentStatus.accepted),
    AppointmentModel(id: 'QQ1122Z', price: 850, status: AppointmentStatus.accepted),
    AppointmentModel(id: 'GH7723L', price: 500, status: AppointmentStatus.pending),
    AppointmentModel(id: 'AF1250H', price: 1000, status: AppointmentStatus.rejected),
  ].obs;

  List<AppointmentModel> get filteredOrders {
    switch (currentFilterIndex.value) {
      case 1:
        return allOrders.where((e) => e.status == AppointmentStatus.accepted).toList();
      case 2:
        return allOrders.where((e) => e.status == AppointmentStatus.pending).toList();
      case 3:
        return allOrders.where((e) => e.status == AppointmentStatus.rejected).toList();
      default:
        return allOrders;
    }
  }

  int getCountByFilterIndex(int index) {
    switch (index) {
      case 1:
        return allOrders.where((e) => e.status == AppointmentStatus.accepted).length;
      case 2:
        return allOrders.where((e) => e.status == AppointmentStatus.pending).length;
      case 3:
        return allOrders.where((e) => e.status == AppointmentStatus.rejected).length;
      default:
        return allOrders.length;
    }
  }


  void changeFilter(int index) {
    currentFilterIndex.value = index;
  }
}
