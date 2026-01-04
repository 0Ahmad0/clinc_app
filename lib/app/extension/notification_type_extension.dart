import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../modules/notifications/data/models/notification_model.dart';



extension NotificationTypeExtension on NotificationType {

  Color get iconColor {
    switch (this) {
      case NotificationType.appointment:
        return const Color(0xFF2196F3); // أزرق
      case NotificationType.offer:
        return const Color(0xFFFF9800); // برتقالي
      case NotificationType.system:
        return const Color(0xFF4CAF50); // أخضر
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NotificationType.appointment:
        return const Color(0xFFE3F2FD);
      case NotificationType.offer:
        return const Color(0xFFFFF3E0);
      case NotificationType.system:
        return const Color(0xFFE8F5E9);
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.appointment:
        return Iconsax.calendar;
      case NotificationType.offer:
        return Iconsax.discount_shape;
      case NotificationType.system:
        return Iconsax.notification;
    }
  }
}