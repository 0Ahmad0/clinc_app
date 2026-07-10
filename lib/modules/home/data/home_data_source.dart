import '../../../app/data/base_model.dart';
import 'models/home_model.dart';

abstract class HomeDataSource {
  Future<BaseModel<HomeModel>> getHome();
}
