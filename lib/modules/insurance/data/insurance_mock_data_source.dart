import '../../../app/data/base_model.dart';
import 'insurance_data_source.dart';
import 'models/insurance_company_model.dart';

class InsuranceMockDataSource implements InsuranceDataSource {
  static const List<InsuranceCompanyModel> _insurances = [
    InsuranceCompanyModel(
      name: 'بوبا العربية',
      logo: 'https://iconape.com/wp-content/files/qz/366430/png/366430.png',
      key: 'Bupa Arabia',
    ),
    InsuranceCompanyModel(
      name: 'التعاونية',
      logo:
          'https://iconape.com/wp-content/png_logo_vector/%D8%B4%D8%B9%D8%A7%D8%B1-%D8%A7%D9%84%D8%AA%D8%B9%D8%A7%D9%88%D9%86%D9%8A%D8%A9.png',
      key: 'Tawuniya',
    ),
    InsuranceCompanyModel(
      name: 'ميدغلف',
      logo:
          'https://www.almowaten.net/wp-content/uploads/%D8%B4%D8%B1%D9%83%D8%A9-%D9%85%D9%8A%D8%AF%D8%BA%D9%84%D9%81-%D9%84%D9%84%D8%AA%D8%A3%D9%85%D9%8A%D9%86.png',
      key: 'Medgulf',
    ),
    InsuranceCompanyModel(
      name: 'تكافل الراجحي',
      logo:
          'https://www.wzufa.com/wp-content/uploads/2022/06/alrajhi-takaful.png',
      key: 'Al Rajhi Takaful',
    ),
    InsuranceCompanyModel(
      name: 'ولاء',
      logo:
          'https://www.aleqt.com/sites/default/files/rbitem/2020/07/12/1428706-1752376691.png',
      key: 'Walaa',
    ),
    InsuranceCompanyModel(
      name: 'ملاذ',
      logo: 'https://iconape.com/wp-content/files/xn/20409/png/Malath-01.png',
      key: 'Malath',
    ),
  ];

  @override
  Future<BaseModel<BaseModels<InsuranceCompanyModel>>> getInsurances() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Insurances retrieved successfully',
        'data': _insurances.map((item) => item.toJson()).toList(),
        'meta': {
          'current_page': 1,
          'from': _insurances.isEmpty ? 0 : 1,
          'to': _insurances.length,
          'per_page': _insurances.length,
          'total': _insurances.length,
        },
      },
      (json) => BaseModels<InsuranceCompanyModel>.fromJson(
        json,
        (itemJson) => InsuranceCompanyModel.fromJson(
          Map<String, dynamic>.from(itemJson as Map),
        ),
      ),
    );
  }
}
