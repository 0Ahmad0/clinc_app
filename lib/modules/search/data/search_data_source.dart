import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import 'models/property_model.dart';

abstract class SearchDataSource {
  Future<BaseModel<FiltersModel>> getFilters();

  Future<BaseModel<BaseModels<Hospital>>> searchClinics(
    PaginationParams params,
  );
}
