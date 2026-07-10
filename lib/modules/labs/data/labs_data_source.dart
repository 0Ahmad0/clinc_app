import '../../../app/data/base_model.dart';
import 'models/lab_model.dart';
import 'models/lab_test_model.dart';

abstract class LabsDataSource {
  Future<BaseModel<List<LabModel>>> getLabs();

  Future<BaseModel<BaseModels<LabTest>>> getLabTests({String? labId});

  Future<BaseModel<BaseModels<LabTest>>> getLabCart();

  Future<BaseModel<BaseModels<LabTest>>> addLabTestToCart(String testId);

  Future<BaseModel<BaseModels<LabTest>>> removeLabTestFromCart(String testId);

  Future<BaseModel<BaseModels<LabTest>>> clearLabCart();
}
