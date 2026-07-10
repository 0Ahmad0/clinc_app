enum AppointmentStatus { accepted, pending, rejected }

extension AppointmentStatusX on AppointmentStatus {
  static AppointmentStatus fromValue(String? value) {
    switch (value) {
      case 'accepted':
        return AppointmentStatus.accepted;
      case 'pending':
        return AppointmentStatus.pending;
      case 'rejected':
      default:
        return AppointmentStatus.rejected;
    }
  }
}
