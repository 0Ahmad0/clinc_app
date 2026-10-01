import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../data/models/insurance_company_model.dart';
import '../../domain/insurance_repository.dart';

class InsuranceController extends GetxController {
  final Rxn<NetworkExceptions> loadError = Rxn<NetworkExceptions>();
  late final InsuranceRepository _repository;
  final RxBool isLoading = false.obs;
  final RxList<InsuranceCompanyModel> insurances =
      <InsuranceCompanyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<InsuranceRepository>();
    loadInsurances();
  }

  Future<void> loadInsurances() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getInsurances();
    isLoading(false);
    result.when(
      success: _handleInsurancesResponse,
      failure: (exception) {
        loadError.value = exception;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  void _handleInsurancesResponse(
    BaseModel<BaseModels<InsuranceCompanyModel>> response,
  ) {
    if (!response.isSuccess || response.result == null) {
      loadError.value = NetworkExceptions.defaultError(response.message ?? '');
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    loadError.value = null;
    insurances.assignAll(response.result!.list);
  }
}
