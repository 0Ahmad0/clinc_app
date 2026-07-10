import 'main_home_item_model.dart';
import 'offer_model.dart';

class HomeModel {
  const HomeModel({
    required this.user,
    required this.mainServices,
    required this.offers,
    required this.unreadNotificationsCount,
    this.activeAppointment,
  });

  final HomeUserModel user;
  final List<MainHomeItemModel> mainServices;
  final List<OfferModel> offers;
  final HomeAppointmentModel? activeAppointment;
  final int unreadNotificationsCount;

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      user: HomeUserModel.fromJson(
        Map<String, dynamic>.from((json['user'] as Map?) ?? const {}),
      ),
      mainServices: _listFromJson(
        json['main_services'],
        (item) => MainHomeItemModel.fromJson(item),
      ),
      offers: _listFromJson(
        json['offers'],
        (item) => OfferModel.fromJson(item),
      ),
      activeAppointment: json['active_appointment'] is Map
          ? HomeAppointmentModel.fromJson(
              Map<String, dynamic>.from(json['active_appointment'] as Map),
            )
          : null,
      unreadNotificationsCount:
          int.tryParse(json['unread_notifications_count']?.toString() ?? '') ??
          0,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'main_services': mainServices.map((item) => item.toJson()).toList(),
    'offers': offers.map((item) => item.toJson()).toList(),
    'active_appointment': activeAppointment?.toJson(),
    'unread_notifications_count': unreadNotificationsCount,
  };

  static List<T> _listFromJson<T>(
    dynamic value,
    T Function(Map<String, dynamic> item) mapper,
  ) {
    if (value is! List) return <T>[];
    return value
        .whereType<Map>()
        .map((item) => mapper(Map<String, dynamic>.from(item)))
        .toList();
  }
}

class HomeUserModel {
  const HomeUserModel({required this.fullName, this.avatar});

  final String fullName;
  final String? avatar;

  factory HomeUserModel.fromJson(Map<String, dynamic> json) {
    return HomeUserModel(
      fullName: json['full_name']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'full_name': fullName, 'avatar': avatar};
}

class HomeAppointmentModel {
  const HomeAppointmentModel({
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.imageUrl,
    required this.date,
    required this.time,
  });

  final String doctorName;
  final String specialty;
  final String clinicName;
  final String imageUrl;
  final String date;
  final String time;

  factory HomeAppointmentModel.fromJson(Map<String, dynamic> json) {
    return HomeAppointmentModel(
      doctorName: json['doctor_name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      clinicName: json['clinic_name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'doctor_name': doctorName,
    'specialty': specialty,
    'clinic_name': clinicName,
    'image_url': imageUrl,
    'date': date,
    'time': time,
  };
}
