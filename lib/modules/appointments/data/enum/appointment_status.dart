enum AppointmentStatus { accepted, pending, completed, rejected }

extension AppointmentStatusX on AppointmentStatus {
  static AppointmentStatus fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();
    switch (normalized) {
      case 'accepted':
      case 'confirmed':
        return AppointmentStatus.accepted;
      case 'pending':
      case 'scheduled':
        return AppointmentStatus.pending;
      case 'completed':
      case 'finished':
      case 'done':
        return AppointmentStatus.completed;
      case 'rejected':
      case 'cancelled':
      case 'canceled':
      case 'declined':
        return AppointmentStatus.rejected;
      default:
        // Unknown backend values should not be shown as rejected.
        return AppointmentStatus.pending;
    }
  }
}
