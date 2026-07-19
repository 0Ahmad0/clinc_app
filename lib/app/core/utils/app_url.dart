// const baseServ = "http://192.168.1.114/";

const baseServ = "https://clinic.hivetech.space/";
const baseServSlashLess = "https://clinic.hivetech.space/";
// const baseServ = "http://192.168.1.101:8000/";
// const baseServSlashLess = "http://192.168.1.101:8000/";

const baseUrl = "${baseServSlashLess}api/";
const storageUrl = "${baseServSlashLess}storage/";

const user = "user/";
const children = "children/";
const public = "public/";
const guardian = "guardian/";
const sheikh = "sheikh/";
const psychologist = "psychologist/";
const app = "app/";

class AppUrl {
  static const appSettings = "${baseUrl}app/settings";

  static const clinicRegister = "${baseUrl}clinic/register";
  static const clinicForgotPassword = "${baseUrl}clinic/forgot-password";
  static const clinicVerifyOtp = "${baseUrl}clinic/verify-otp";
  static const clinicResendOtp = "${baseUrl}clinic/resend-otp";
  static const completeClinicProfile = "${baseUrl}clinic/complete-profile";
  static const insurances = "${baseUrl}insurances";
  static const clinicDashboard = "${baseUrl}clinic/dashboard";
  static const clinicDoctors = "${baseUrl}clinic/doctors";
  static const clinicAppointments = "${baseUrl}clinic/appointments";
  static const clinicNotifications = "${baseUrl}clinic/notifications";
  static const clinicRegistrationStatus =
      "${baseUrl}clinic/registration-status";
  static const clinicReports = "${baseUrl}clinic/reports";
  static const clinicServices = "${baseUrl}clinic/services";

  /// User
  ///*******************************************************************************
  ///<------------------------------------------------------------------------------

  static const login = "${baseUrl}login";
  static const loginWithGoogle = "${baseUrl}auth/google";
  static const userSocialLogin = "${baseUrl}user/social-login";
  static const userGuestLogin = "${baseUrl}user/guest-login";
  static const signup = "${baseUrl}register";

  static const logout = "${baseUrl}logout";

  static const getProfile = '${baseUrl}profile';
  static const userProfile = '${baseUrl}user/profile';
  static const userHome = '${baseUrl}user/home';
  static const userDoctors = '${baseUrl}user/doctors';
  static const userDoctorFilters = '${baseUrl}user/doctors/filters';
  static const userClinics = '${baseUrl}user/clinics';
  static const userClinicFilters = '${baseUrl}user/clinics/filters';
  static const userLabs = '${baseUrl}user/labs';
  static const userLabFilters = '${baseUrl}user/labs/filters';
  static const userSalons = '${baseUrl}user/salons';
  static const userSalonFilters = '${baseUrl}user/salons/filters';
  static const userInsurances = '${baseUrl}user/insurances';
  static const userLabCart = '${baseUrl}user/lab-cart';
  static const userAppointments = '${baseUrl}user/appointments';
  static const userPaymentCards = '${baseUrl}user/payment/cards';
  static const userPaymentCoupons = '${baseUrl}user/payment/coupons';
  static const userPaymentApplyCoupon = '${baseUrl}user/payment/apply-coupon';
  static const userLabCartCheckout = '${baseUrl}user/lab-cart/checkout';
  static const userChatbotMessage = '${baseUrl}user/chatbot/message';
  static const userAppointmentAvailableTimes =
      '${baseUrl}user/appointments/available-times';
  static const userResetPassword = '${baseUrl}user/reset-password';
  static const userNotificationSettings =
      '${baseUrl}user/notification-settings';
  static const userAccount = '${baseUrl}user/account';
  static const forgotPassword = '${baseUrl}forgot-password';
  static const restoreAccount = '${baseUrl}restore-account';
  static const appForgotPassword = '$baseUrl${app}forgot-password';
  static const verifyOtp = '${baseUrl}verify-otp';
  static const resendOtp = '${baseUrl}resend-otp';
  static const appResetPassword = '$baseUrl${app}reset-password';
  static const clinicResetPassword = '${baseUrl}clinic/reset-password';
  static const clinicSocialLogin = '${baseUrl}clinic/social-login';
  static const changePassword = '${baseUrl}change-password';
  static const changeEmail = '$baseUrl${user}change_email/';
  static const changeUsername = '$baseUrl${user}change_username/';
  static const resetPassword = '$baseUrl${user}reset_password/';
  static const resendEmailOtp = '${baseUrl}resend-email-otp';
  static const notifications = '${baseUrl}notifications';
  static const notificationsMarkAllRead =
      '${baseUrl}notifications/mark-all-read';
  static const notificationsUnreadCount =
      '${baseUrl}notifications/unread-count';

  static String userLabTests([String? labId]) {
    if (labId == null || labId.isEmpty) return '${baseUrl}user/lab-tests';
    return '${baseUrl}user/labs/$labId/tests';
  }

  static String userLabCartItem(String testId) => '$userLabCart/$testId';

  static String userClinicDetails(String clinicId) => '$userClinics/$clinicId';

  static String userClinicReviews(String clinicId) =>
      '${baseUrl}user/clinics/$clinicId/reviews';

  static String userLabReviews(String labId) =>
      '${baseUrl}user/labs/$labId/reviews';

  static String userLabFavorite(String labId) =>
      '${baseUrl}user/labs/$labId/favorite';

  static String userAppointmentDetails(String appointmentId) =>
      '$userAppointments/$appointmentId';

  static String userAppointmentCancel(String appointmentId) =>
      '${userAppointmentDetails(appointmentId)}/cancel';

  static String userPaymentCard(String cardId) => '$userPaymentCards/$cardId';

  static String userDoctorDetails(String doctorId) =>
      '${baseUrl}user/doctors/$doctorId';

  static String userDoctorReviews(String doctorId) =>
      '${baseUrl}user/doctors/$doctorId/reviews';

  static String userDoctorFavorite(String doctorId) =>
      '${baseUrl}user/doctors/$doctorId/favorite';

  static const sendVerificationCode = '$baseUrl${user}send_verification_code/';
  static const verifyUserName = '$baseUrl${user}verify/';
  static const verifyEmail = '$baseUrl${user}verify-email/';
  static const verifyOtpWhileRigister = '${baseUrl}verify-email';
  static const getAllUser = '$baseUrl${user}all_user/';
  static const refreshToken = '$baseUrl${user}refresh_token/';
  static const myTransactions = '$baseUrl${user}my_transactions/';
  static const withdrawRequest = '$baseUrl${user}withdraw-request/';

  ///------------------------------------------------------------------------------>

  /// Children
  ///*******************************************************************************
  ///<------------------------------------------------------------------------------
  static const getPartners = '$baseUrl${children}home-users';
  static const childrenConversationRequests =
      '$baseUrl${children}conversation-requests';
  static const getPartnersById = '$baseUrl${children}show-info/';
  static const getFavorites = '$baseUrl${children}favorite';
  static const toggleFavorite = '$baseUrl${children}favorite/';

  /// Interests
  static const getInterests = '$baseUrl${children}interests/get';
  static const updateInterests = '$baseUrl${children}interests/update';

  /// Personality
  static const getPersonality = '$baseUrl${children}personality';
  static const updatePersonality = '$baseUrl${children}personality/update';
  static const String getSheikhs = "$baseUrl${children}sheikhs";
  static const String getPsychologists = "$baseUrl${children}psychologists";
  static const updateProfile = '$baseUrl${children}update';
  static const String getChildProfile = "$baseUrl${children}get";
  static const getChildInfo = '$baseUrl${children}info/get';
  static const getChildPreferences = '$baseUrl${children}preferences/get';

  static const updateChildInfo = '$baseUrl${children}info/update';
  static const String guardianLink = 'children/guardian-link';
  static const String childrenGuardianLinkStatus =
      'children/guardian-link/status';
  static const String childrenMyGuardian = 'children/my-guardian';
  static const updateChildPreferences = '$baseUrl${children}preferences/update';
  static const blockedUsers = '${baseUrl}ban';
  static const reportsType = '$baseUrl${public}report_type';
  static const reportUser = '${baseUrl}users/report';

  ///-------------------------------------------------------------------------------

  /// Public Dropdown
  ///*******************************************************************************
  ///<------------------------------------------------------------------------------
  static const getCountries = '$baseUrl${public}countries';
  static const getCities = '$baseUrl${public}cities';
  static const getCitiesByCountry = '$baseUrl${public}cities/countries/';
  static const publicContact = '$baseUrl${public}contact';
  static const publicContactLinks = '$baseUrl${public}contact-links';

  ///------------------------------------------------------------------------------>

  /// guardian
  static const guardianMyProfile = '$baseUrl${guardian}my-profile';
  static const guardianUpdateMyProfile = '$baseUrl${guardian}my-profile/update';
  static const guardianMyChildren = '$baseUrl${guardian}my-children';
  static const guardianChildLinkRequests =
      '$baseUrl${guardian}child-link-requests';
  static const guardianMyChildrenConversationRequestsStatistics =
      '$baseUrl${guardian}my-children/conversation-requests/statistics';
  static const guardianConversationRequestsIndex =
      '$baseUrl${guardian}my-children/conversation-requests/index';

  static String guardianConversationRequestRespond(String id) =>
      '$baseUrl${guardian}my-children/conversation-requests/$id/respond';

  static String guardianChildLinkRequestApprove(String id) =>
      '$guardianChildLinkRequests/$id/approve';

  static String guardianChildLinkRequestReject(String id) =>
      '$guardianChildLinkRequests/$id/reject';

  static String guardianMyChild(String id) =>
      '$baseUrl${guardian}my-children/$id';

  static String guardianMyChildDetails(String id) => guardianMyChild(id);

  /// Sheikh
  static const sheikhMyProfile = '${baseUrl}sheikh';
  static const sheikhUpdateProfile = '${baseUrl}sheikh/update';
  static const sheikhOverview = '$baseUrl${sheikh}overview';

  /// Psychologist
  static const psychologistMyProfile = '${baseUrl}psychologist';
  static const psychologistUpdateProfile = '${baseUrl}psychologist/update';
  static const psychologistOverview = '$baseUrl${psychologist}overview';
}
