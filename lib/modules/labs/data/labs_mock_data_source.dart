import '../../../app/data/base_model.dart';
import '../../../app/data/offer_model.dart';
import '../../../app/data/review_model.dart';
import 'labs_data_source.dart';
import 'models/lab_model.dart';
import 'models/lab_test_model.dart';

class LabsMockDataSource implements LabsDataSource {
  static final Set<String> _cartIds = <String>{};

  static final List<LabModel> _labs = <LabModel>[
    LabModel(
      id: '1',
      name: 'مختبرات البرج الطبية',
      imageUrl:
          'https://img.freepik.com/free-photo/laboratory-interior_1098-13411.jpg',
      address: 'شارع الملك فهد، الرياض',
      rating: 4.8,
      isOpen: true,
      category: 'تحاليل شاملة',
      description:
          'مختبرات رائدة تقدم كافة أنواع التحاليل الطبية بأحدث الأجهزة ودقة عالية في النتائج.',
      services: ['فحص شامل', 'فيتامينات', 'هرمونات', 'فحص زواج'],
      phoneNumber: '920000000',
      latitude: 24.7136,
      longitude: 46.6753,
      offers: [
        LabOfferModel(
          title: 'باقة الفحص الشامل',
          code: 'BORJ2024',
          discount: '20%',
        ),
        LabOfferModel(title: 'فحص فيتامين د', code: 'VITD50', discount: '50%'),
      ],
      reviews: [
        ReviewModel(
          userName: 'محمد علي',
          userImage: 'https://i.pravatar.cc/150?img=11',
          rating: 5.0,
          comment: 'خدمة سريعة وممتازة، النتائج وصلتني عالجوال.',
          date: 'منذ يومين',
        ),
        ReviewModel(
          userName: 'سارة أحمد',
          userImage: 'https://i.pravatar.cc/150?img=5',
          rating: 4.5,
          comment: 'المكان نظيف جداً والموظفين محترمين.',
          date: 'منذ أسبوع',
        ),
      ],
    ),
    LabModel(
      id: '2',
      name: 'مركز الأشعة المتطور',
      imageUrl:
          'https://img.freepik.com/free-photo/ct-scan-room-hospital_1170-2228.jpg',
      address: 'حي الورود، جدة',
      rating: 4.5,
      isOpen: false,
      category: 'أشعة',
      description:
          'مركز متخصص في جميع أنواع الأشعة التشخيصية (MRI, CT) بإشراف استشاريين.',
      services: ['MRI', 'CT Scan', 'X-Ray', 'Ultrasound'],
      phoneNumber: '012345678',
      latitude: 21.5433,
      longitude: 39.1728,
      offers: [],
      reviews: [
        ReviewModel(
          userName: 'خالد عمر',
          userImage: 'https://i.pravatar.cc/150?img=60',
          rating: 4.0,
          comment: 'جهاز الرنين المغناطيسي حديث، لكن الانتظار طويل قليلاً.',
          date: 'منذ شهر',
        ),
      ],
    ),
  ];

  static final List<LabTest> _labTests = <LabTest>[
    LabTest(
      id: 'offer_1',
      title: 'عرض الفحص الشامل',
      category: 'عروض خاصة',
      description: 'باقة دموعات، شاملة تشمل جميع الفحوصات الأساسية',
      price: 1050.0,
      isSpecialOffer: true,
      expiryDate: '2026-02-28',
      includedTests: [
        'صورة الدم الكاملة',
        'وظائف الكلى',
        'وظائف الكبد',
        'فحص السكري',
        'فحص الغدة الدرقية',
        'فيتامين د',
      ],
      originalPrice: 1500.0,
      discountPercentage: 30,
    ),
    LabTest(
      id: 'offer_2',
      title: 'عرض فحوصات الزواج',
      category: 'عروض خاصة',
      description: 'باقة دموعات، شاملة لفحوصات ما قبل الزواج',
      price: 600.0,
      isSpecialOffer: true,
      expiryDate: '2026-03-15',
      includedTests: [
        'فحص الدم',
        'فصيلة الدم',
        'فحص الأمراض المعدية',
        'فحص الخصوبة',
      ],
      originalPrice: 850.0,
      discountPercentage: 29,
    ),
    LabTest(
      id: 'package_1',
      title: 'الباقة الذهبية',
      category: 'باقات',
      description: 'فحوصات شاملة للكشف عن الأمراض الشائعة',
      price: 750.0,
      isPackage: true,
      numberOfTests: 15,
      includedTests: [
        'CBC صورة دم كاملة',
        'وظائف الكلى',
        'وظائف الكبد',
        'الدهون الثلاثية',
        'فيتامين د',
        'فيتامين ب12',
      ],
      discountPercentage: 20,
    ),
    LabTest(
      id: 'package_2',
      title: 'باقة صحة المرأة',
      category: 'باقات',
      description: 'فحوصات مخصصة للكشف عن أمراض النساء',
      price: 899.0,
      isPackage: true,
      numberOfTests: 12,
      discountPercentage: 25,
    ),
    LabTest(
      id: 'package_3',
      title: 'باقة الرياضيين',
      category: 'باقات',
      description: 'فحوصات مكثفة للرياضيين والمتدربين',
      price: 1200.0,
      isPackage: true,
      numberOfTests: 18,
      discountPercentage: 15,
    ),
    LabTest(
      id: 'vit_d',
      title: 'فيتامين D',
      category: 'فيتامينات',
      description: 'فحص مستوى فيتامين د في الدم',
      price: 150.0,
      sampleType: 'عينة دم',
      labName: 'مختبر الميدان',
    ),
    LabTest(
      id: 'vit_b12',
      title: 'فيتامين B12',
      category: 'فيتامينات',
      description: 'فحص مستوى فيتامين ب12 في الدم',
      price: 120.0,
      sampleType: 'عينة دم',
      labName: 'مختبر الميدان',
    ),
    LabTest(
      id: 'vit_b6',
      title: 'فيتامين B6',
      category: 'فيتامينات',
      description: 'فحص مستوى فيتامين ب6 في الدم',
      price: 110.0,
      sampleType: 'عينة دم',
      labName: 'مختبر الميدان',
    ),
    LabTest(
      id: 'cbc',
      title: 'صورة الدم الكاملة (CBC)',
      category: 'وظائف حيوية',
      description: 'الكشف عن فقر الدم والالتهابات',
      price: 80.0,
      sampleType: 'عينة دم',
      labName: 'مختبر الميدان',
    ),
    LabTest(
      id: 'kidney',
      title: 'وظائف الكلى الشاملة',
      category: 'وظائف حيوية',
      description: 'يوريا، كرياتينين، أملاح الدم',
      price: 120.0,
      isFastingRequired: true,
      sampleType: 'عينة دم',
      labName: 'مختبر الميدان',
    ),
    LabTest(
      id: 'glucose',
      title: 'فحص السكري التراكمي (HbA1c)',
      category: 'سكري',
      description: 'قياس مستوى السكر في الدم خلال 3 أشهر',
      price: 90.0,
      sampleType: 'عينة دم',
      labName: 'مختبر الميدان',
    ),
    LabTest(
      id: 'thyroid',
      title: 'وظائف الغدة الدرقية',
      category: 'غدد',
      description: 'TSH, T3, T4',
      price: 180.0,
      sampleType: 'عينة دم',
      labName: 'مختبر الميدان',
    ),
  ];

  @override
  Future<BaseModel<List<LabModel>>> getLabs() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Labs retrieved successfully',
      'data': _labs.map((item) => item.toJson()).toList(),
      'meta': <String, dynamic>{},
    }, _labsFromJson);
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> getLabTests({String? labId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _testsResponse(
      tests: _labTests,
      message: 'Lab tests retrieved successfully',
    );
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> getLabCart() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _testsResponse(
      tests: _cartTests,
      message: 'Lab cart retrieved successfully',
    );
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> addLabTestToCart(String testId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _cartIds.add(testId);
    return _testsResponse(
      tests: _cartTests,
      message: 'Lab test added to cart successfully',
    );
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> removeLabTestFromCart(
    String testId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _cartIds.remove(testId);
    return _testsResponse(
      tests: _cartTests,
      message: 'Lab test removed from cart successfully',
    );
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> clearLabCart() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _cartIds.clear();
    return _testsResponse(
      tests: _cartTests,
      message: 'Lab cart cleared successfully',
    );
  }

  List<LabModel> _labsFromJson(dynamic json) {
    if (json is! List) return <LabModel>[];
    return json
        .whereType<Map>()
        .map((item) => LabModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  List<LabTest> get _cartTests {
    return _labTests.where((test) => _cartIds.contains(test.id)).toList();
  }

  BaseModel<BaseModels<LabTest>> _testsResponse({
    required List<LabTest> tests,
    required String message,
  }) {
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': message,
        'data': tests.map((test) => test.toJson()).toList(),
        'meta': {
          'current_page': 1,
          'from': tests.isEmpty ? 0 : 1,
          'to': tests.length,
          'per_page': tests.length,
          'total': tests.length,
        },
      },
      (json) => BaseModels<LabTest>.fromJson(
        json,
        (itemJson) =>
            LabTest.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }
}
