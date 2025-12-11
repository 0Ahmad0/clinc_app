import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/property_model.dart';
import '../controllers/search_controller.dart';

class SearchScreen extends GetView<SearchAndFilterController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: 'البحث',

      ),
      body: Column(
        children: <Widget>[
          // 1. حقل البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'ابحث عن مستشفى أو عيادة...',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // 2. أدوات التصفية والفرز
          _buildFilterControls(),

          // 3. قائمة النتائج المفلترة
          Expanded(
            // Obx يستمع للتغيرات في controller.filteredHospitals
            child: Obx(() {
              if (controller.filteredHospitals.isEmpty) {
                return Center(child: Text('لا توجد نتائج مطابقة لمرشحات البحث.'));
              }
              return ListView.builder(
                itemCount: controller.filteredHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = controller.filteredHospitals[index];
                  return HospitalCard(hospital: hospital);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // مرشح المنطقة
          Obx(() => DropdownButton<String>(
            value: controller.selectedRegion.value,
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.updateRegionFilter(newValue);
              }
            },
            items: Hospital.availableRegions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.blueGrey)),
              );
            }).toList(),
          )),

          // الفرز حسب السعر أو القرب
          Obx(() => DropdownButton<String>(
            value: controller.sortCriteria.value,
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.updateSortCriteria(newValue);
              }
            },
            items: const [
              DropdownMenuItem(value: 'priceAsc', child: Text('الأرخص سعراً 💰')),
              DropdownMenuItem(value: 'distanceAsc', child: Text('الأقرب إليك 📍')),
            ],
          )),
        ],
      ),
    );
  }
}

// بطاقة عرض المستشفى
class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(Icons.local_hospital, color: Colors.teal),
        title: Text(hospital.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'المنطقة: ${hospital.region}\n'
              'القرب: ${hospital.distanceKm.toStringAsFixed(1)} كم',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SAR ${hospital.consultationFee.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('استشارة', style: TextStyle(fontSize: 10)),
          ],
        ),
        onTap: () {
          // يمكن إضافة منطق الانتقال لصفحة تفاصيل المستشفى هنا
          Get.snackbar('تفاصيل المستشفى', 'جارٍ الانتقال إلى صفحة ${hospital.name}');
        },
      ),
    );
  }
}
