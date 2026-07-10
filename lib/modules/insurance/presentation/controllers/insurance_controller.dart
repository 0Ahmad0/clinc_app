import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../data/models/insurance_company_model.dart';
import '../../domain/insurance_repository.dart';

class InsuranceController extends GetxController {
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
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleInsurancesResponse(
    BaseModel<List<InsuranceCompanyModel>> response,
  ) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    insurances.assignAll(response.result!);
  }
}
