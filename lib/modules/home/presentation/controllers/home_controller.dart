import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/modules/home/data/models/home_model.dart';
import 'package:clinc_app_t1/modules/home/data/models/main_home_item_model.dart';
import 'package:clinc_app_t1/modules/home/data/models/offer_model.dart';
import 'package:clinc_app_t1/modules/home/domain/home_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late final HomeRepository _repository;

  final RxBool isLoading = false.obs;
  final Rxn<HomeModel> home = Rxn<HomeModel>();
  final RxList<MainHomeItemModel> mainSectionList = <MainHomeItemModel>[].obs;
  final RxList<OfferModel> offersList = <OfferModel>[].obs;

  bool get hasHomeData => home.value != null;

  String get userName => home.value?.user.fullName ?? '';

  String get userAvatar =>
      home.value?.user.avatar ??
      'https://tse1.mm.bing.net/th/id/OIP.lj2NFJ7HSEsDqn7er7BuDAHaHa?cb=ucfimg2&ucfimg=1&w=626&h=626&rs=1&pid=ImgDetMain&o=7&rm=3';

  int get unreadNotificationsCount => home.value?.unreadNotificationsCount ?? 0;

  HomeAppointmentModel? get activeAppointment => home.value?.activeAppointment;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<HomeRepository>();
    loadHome();
  }

  Future<void> loadHome() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getHome();
    isLoading(false);
    result.when(
      success: _handleHomeResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleHomeResponse(BaseModel<HomeModel> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    home.value = response.result;
    mainSectionList.assignAll(response.result!.mainServices);
    offersList.assignAll(response.result!.offers);
  }
}
