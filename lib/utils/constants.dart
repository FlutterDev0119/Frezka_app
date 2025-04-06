//region App Theme Mode
class ThemeModeConstants {
  static const systemThemeMode = 0;
  static const lightThemeMode = 1;
  static const darkThemeMode = 2;
}
//endregion

//region Enums

enum MethodType { get, post, delete, put, multipart }

enum LoginType { google, apple, otp, email }

enum UserType { collector, vendor, user }

enum AuthType { signIn, signUp, otpLogin, otpVerification }

enum SearchType { location, lab, test, package, category, none }

enum LabStatus { open, closed }

enum BookingStatus { pending, confirmed, cancelled }

enum Gender { male, female, other }

enum CommonStatus { active, inactive }

enum FilterType { status, category, price, date }

enum AppointmentFilterType {
  testCase,
  package,
  dateRange,
  vendor,
  collector,
  user,
  appointmentStatus,
  paymentStatus,
}

enum CashHistoryFilterType {
  all,
  sendToVendor,
  sendToAdmin,
  sendToCollector,
  approvedByVendor,
  approvedByCollector,
  approvedByAdmin,
}

//endregion

class DefaultConstants {
  static const perPageItem = 20;
  static const int labelTextSize = 18;
  static const double shimmerTextSize = 12;
  static const double iconSize = 18;
  static const double commonRadius = 18;
  static const int maxUploadSize = 5 * 1024 * 1024;

  static const double commonSectionSpaceSmall = 8;
  static const double commonSectionSpaceMedium = 12;
  static const double commonSectionSpaceRegular = 16;
  static const double commonSectionSpaceLarge = 24;
  static var googleMapPrefix = 'https://www.google.com/maps/search/?api=1&query=';
  static const decimalPoint = 2;

  static const defaultEmail = 'collector@gmail.com';
  static const defaultPassword = '12345678';

  static const String demoOTP = '123456';
  static const String defaultNumber = '+919876543210';

  static const String demoNumber = '9876543210';

  static List<String> rtlLanguage = [
    'ar', // Arabic
    'he', // Hebrew
    'fa', // Persian (Farsi)
    'ur', // Urdu
    'yi', // Yiddish
    'dv', // Divehi (Maldivian)
    'ps', // Pashto
    'syr', // Syriac
  ];
}

//region Currency position
class CurrencyPosition {
  static const CURRENCY_POSITION_LEFT = 'left';
  static const CURRENCY_POSITION_RIGHT = 'right';
  static const CURRENCY_POSITION_LEFT_WITH_SPACE = 'left_with_space';
  static const CURRENCY_POSITION_RIGHT_WITH_SPACE = 'right_with_space';
}
//endregion

class AppointmentStatusConstants {
  static const waiting = 'waiting';
  static const pendingApproval = 'pending-approval';
  static const pending = 'pending';
  static const accepted = 'accept';
  static const onGoing = 'on_going';
  static const inProgress = 'in_progress';
  static const onHold = 'on_hold';
  static const rejected = 'rejected';
  static const failed = 'failed';
  static const cancelled = 'cancelled';
  static const completed = 'completed';
  static const reschedule = 'reschedule';
}

class LabStatusTitle {
  static const open = 'Open';
  static const close = 'Close';
}

class ConstantKeys {
  static const pageKey = 'page';
  static const perPageKey = 'per_page';
  static const searchKey = 'search';
  static const isAuthenticatedKey = 'is_authenticated';
  static const idKey = 'id';
  static const statusKey = 'status';
  static const typeKey = 'type';
  static const isDefaultKey = 'is_default';
  static const loginTypeKey = 'login_type';
  static const emailKey = 'email';
  static const passwordKey = 'password';
  static const oldPasswordKey = 'old_password';
  static const newPasswordKey = 'new_password';
  static const mobileNumberKey = 'mobile_number';
  static const userTypeKey = 'user_type';
  static const appointmentStatusKey = 'status';
  static const firstNameKey = 'first_name';
  static const lastNameKey = 'last_name';
  static const profileImageKey = 'profile_image';
  static const relationKey = 'relation';
  static const userIdKey = 'user_id';
  static const userNameKey = 'user_name';
  static const genderKey = 'gender';
  static const dobKey = 'dob';
  static const otpKey = 'otp';
  static const socialImageKey = 'social_image';

  //region Appointment
  static const paymentStatusKey = 'payment_status';
  static const customerIdKey = 'customer_id';

  static const collectorIdKey = 'collector_id';
  static const labIdKey = 'lab_id';
  static const vendorIdKey = 'vendor_id';
  static const testTypeKey = 'test_type';
  static const testIdKey = 'test_id';
  static const appointmentId = 'appointment_id';
  static const appointmentDateKey = 'appointment_date';
  static const appointmentTimeKey = 'appointment_time';

  static const rescheduleReasonTimeKey = 'reschedule_reason';
  static const collectionTypeKey = 'collection_type';
  static const paymentTypeKey = 'payment_type';
  static const paymentMethodKey = 'payment_method';
  static const paymentGatewayKey = 'payment_mode';
  static const couponIdKey = 'coupon_id';
  static const medicalReportKey = 'medical_report';

  static const amountKey = 'medical_report';

  //endregion

  //region Location
  static const countryIdKey = 'country_id';
  static const stateIdKey = 'state_id';
  static const cityIdKey = 'city_id';

  //endregion

  //region Help Desk Keys
  static const subjectKey = 'subject';
  static const descriptionKey = 'description';
  static const messageKey = 'message';
  static const priorityKey = 'priority';
  static const categoryKey = 'category';
  static const attachmentCountKey = 'attachment_count';
  static const helpDeskAttachmentKey = 'helpdesk_attachment';
  static const modeKey = 'mode';
  static const contactNumberKey = 'contact_number';

  //endregion

  //region Address
  static const addressKey = 'address';
  static const addressTypeKey = 'type';
  static const searchTypeKey = 'type';

//endregion

  //region Wallet and bank
  static String bankName = 'bank_name';
  static String branchName = 'branch_name';
  static String accountNo = 'account_no';
  static String ifscCodeKey = 'ifsc_code';
  static String aadharNo = 'aadhar_no';
  static String panNo = 'pan_no';
  static String bankAttachment = 'bank_attachment';
  static String mobileKey = 'mobile';

  static String phoneNumberKey = 'phone_number';

//endregion
}

enum bankStatus {
  active,
  inactive,
  pending;

  // Add fromString if needed
  static CommonStatus fromString(String status) {
    return CommonStatus.values.firstWhere((e) => e.name == status, orElse: () => CommonStatus.active);
  }
}

//region DateFormats
class DateFormatConstants {
  static const M_D_YYYY = "M/d/yyyy";
  static const D_MMM_YYYY = "d MMM, yyyy";
  static const DD_MM_YY = "dd/MM/yy";
  static const MMMM_D_yyyy = "MMMM d, y";
  static const D_MMMM_yyyy = "d MMMM, y";
  static const MMMM_D_yyyy_At_HH_mm_a = "MMMM d, y @ hh:mm a";
  static const EEEE_D_MMMM_At_HH_mm_a = "EEEE d MMMM @ hh:mm a";
  static const dd_MMM_yyyy_HH_mm_a = "dd MMM y, hh:mm a";
  static const yyyy_MM_dd_HH_mm = 'yyyy-MM-dd HH:mm';
  static const yyyy_MM_dd = 'yyyy-MM-dd';
  static const yyyy = 'yyyy';
  static const HH_mm12Hour = 'hh:mm a';

  static const HH_mm_ss = 'HH:mm:ss';
  static const HH_mm24Hour = 'HH:mm';
  static const displayDateFormat = 'MMMM d, y';
  static const displayTimeFormat = 'h:mm a';
}
//endregion

//region Tax
class TaxType {
  static const percentage = 'percentage';
  static const fixed = 'fixed';
}
//endregion

//region Collection Type
class CollectionType {
  static const home = 'home';
  static const lab = 'lab';
}
//endregion

class AppPages {
  static const termsAndCondition = 'terms-conditions';
  static const privacyPolicy = 'privacy-policy';
  static const helpAndSupport = 'help-and-support';
  static const refundAndCancellation = 'refund-and-cancellation-policy';
  static const dataDeletion = 'data-deletation-request';
  static const faq = 'faq';
  static const aboutUs = 'about-us';
}

class PaymentMethods {
  static const razorPay = 'razorpay';
  static const stripe = 'stripe';
  static const flutterWave = 'flutterWave';
  static const payStack = 'payStack';
  static const payPal = 'paypal';
  static const pending = 'pending';
  static const cash = 'cash';
  static const wallet = 'wallet';
}

class PaymentStatusConstants {
  static const pending = 'pending';
  static const paid = 'paid';
  static const failed = 'failed';
}

class PaymentTypeConstants {
  static const cash = 'cash';
  static const online = 'online';
}

class PaymentStatus {
  static const String paid = 'paid';
  static const String pending = 'pending';
}

class PaymentMode {
  static const String manaul = 'manual';
  static const String online = 'online';
}

Map<String, String> paymentModeMap = {
  PaymentMode.manaul: 'cash',
  PaymentMode.online: 'online',
};

class AccreditationType {
  static const String nabl = 'nabl';
  static const iso = 'iso';

  static const none = 'none';
}

class HeroTagKeys {
  static const appointment = 'appointment';
  static const appointmentDetails = 'appointmentDetails';

  static const test = 'test';

  static const testDetails = 'testDetails';

  static const package = 'package';
  static const packageDetails = 'packageDetails';
  static const lab = 'lab';

  static const labDetails = 'labDetails';
  static const vendor = 'vendor';
  static const vendorDetails = 'vendorDetails';

  static const category = 'category';
  static const categoryDetails = 'categoryDetails';

  static const location = 'location';
  static const locationDetails = 'locationDetails';

  static const profile = 'profile';
  static const profileDetails = 'profileDetails';
}

//region Actions
class CashPaymentActionConstants {
  static const String collectorApprovedCash = "collector_approved_cash";
  static const String collectorSendVendor = "collector_send_vendor";
  static const String vendorApprovedCash = "vendor_approved_cash";
  static const String vendorSendAdmin = "vendor_send_admin";
  static const String adminApprovedCash = "admin_approved_cash";
  static const String approvedByCollector = "approved_by_collector"; // Collector approved the request
  static const String pendingByCollector = "pending_by_collector"; // Collector approved the request
  static const String sendToVendor = "send_to_vendor"; // Request sent to the vendor
  static const String sendToAdmin = "send_to_admin"; // Request sent to the admin
  static const String pendingByVendor = "pending_by_vendor"; // Request pending with the vendor
  static const String approvedByVendor = "approved_by_vendor"; // Vendor approved the request
  static const String pendingByAdmin = "pending_by_admin"; // Request pending with the admin
  static const String approvedByAdmin = "approved_by_admin"; // Admin approved the request
  static const String paid = "paid"; // Admin approved the request
  static const String cash = "cash"; // Admin approved the request
}
//endregion

//region Status
class CashPaymentStatusConstants {
  static const String approvedByCollector = "approved_by_collector"; // Collector approved the request

  static const String pendingByCollector = "pending_by_collector"; // Collector approved the request
  static const String sendToVendor = "send_to_vendor"; // Request sent to the vendor
  static const String sendToAdmin = "send_to_admin"; // Request sent to the admin
  static const String pendingByVendor = "pending_by_vendor"; // Request pending with the vendor
  static const String approvedByVendor = "approved_by_vendor"; // Vendor approved the request
  static const String pendingByAdmin = "pending_by_admin"; // Request pending with the admin
  static const String approvedByAdmin = "approved_by_admin"; // Admin approved the request
}
//endregion

class CashPaymentStatusActionConstants {
  static const String collectorApprovedCash = "collector_approved_cash";
  static const String collectorSendVendor = "collector_send_vendor";
  static const String collectorSendAdmin = "collector_send_admin";
  static const String vendorApprovedCash = "vendor_approved_cash";
  static const String vendorSendAdmin = "vendor_send_admin";
  static const String adminApprovedCash = "admin_approved_cash";
  static const String approvedByCollector = "approved_by_collector"; // Collector approved the request
  static const String pendingByCollector = "pending_by_collector"; // Collector approved the request
  static const String sendToVendor = "send_to_vendor"; // Request sent to the vendor
  static const String sendToAdmin = "send_to_admin"; // Request sent to the admin
  static const String pendingByVendor = "pending_by_vendor"; // Request pending with the vendor
  static const String approvedByVendor = "approved_by_vendor"; // Vendor approved the request
  static const String pendingByAdmin = "pending_by_admin"; // Request pending with the admin
  static const String approvedByAdmin = "approved_by_admin"; // Admin approved the request
  static const String paid = "paid"; // Admin approved the request
}

//region Date Filters
class CashFilterConstants {
  static const String today = "today";
  static const String yesterday = "yesterday";
  static const String custom = "custom";
  static const String thisWeek = "this_week";
  static const String thisMonth = "this_month";
  static const String thisYear = "this_year";
}
//endregion

//region Payment Methods
class CashPaymentMethodConstants {
  static const String cash = "cash";
  static const String bank = "bank";
}
//endregion

//region WalletHistoryStatus
class WalletHistoryStatus {
  static const String credit = 'wallet_credit';
  static const String debit = 'wallet_debit';
  static const String topUp = 'wallet_top_up';
}
//endregion

//region Firebase Topic keys
class FirebaseMsgConst {
  //Other Consts
  static const topicSubscribed = 'topic-----subscribed---->';
  static const topicUnSubscribed = 'topic-----UnSubscribed---->';
  static const userWithUnderscoreKey = 'user_';

  static const additionalDataKey = 'additional_data';
  static const notificationGroupKey = 'notification_group';
  static const idKey = 'id';
  static const notificationDataKey = 'Notification Data';
  static const fcmNotificationTokenKey = 'FCM Notification Token';
  static const apnsNotificationTokenKey = 'APNS Notification Token';
  static const notificationErrorKey = 'Notification Error';
  static const notificationTitleKey = 'Notification Title';

  static const notificationKey = 'Notification';

  static const onClickListener = "Error On Notification Click Listener";
  static const onMessageListen = "Error On Message Listen";
  static const onMessageOpened = "Error On Message Opened App";
  static const onGetInitialMessage = 'Error On Get Initial Message';

  static const messageDataCollapseKey = 'MessageData Collapse Key';

  static const messageDataMessageIdKey = 'MessageData Message Id';

  static const messageDataMessageTypeKey = 'MessageData Type';
  static const notificationBodyKey = 'Notification Body';
  static const backgroundChannelIdKey = 'background_channel';
  static const backgroundChannelNameKey = 'background_channel';

  static const notificationChannelIdKey = 'notification';
  static const notificationChannelNameKey = 'Notification';

  static const notificationMarkAsReadType = 'mark_as_read';

  static const newContentType = 'new-content';
}
//endregion
//endregion

enum GalleryFileTypes { CANCEL, CAMERA, GALLERY }

enum HelpDeskCategoryStatus { all, open, closed }

class StatusTitle {
  static const open = 'Open';
  static const close = 'Close';
}

class HelpDeskStatus {
  static const open = 'open';
  static const closed = 'closed';
  static const addHelpDesk = 'add_helpdesk';
  static const repliedHelpDesk = 'replied_helpdesk';
  static const closedHelpDesk = 'closed_helpdesk';
}

class HelpDeskKey {
  static String helpDeskId = 'id';
  static String subject = 'subject';
  static String description = 'description';
  static String mode = 'mode';
  static String helpdeskAttachment = 'helpdesk_attachment_';
  static String helpdeskActivityAttachment = 'helpdesk_activity_attachment_';
  static String attachmentCount = 'attachment_count';
}

const PERMISSION_STATUS = 'permissionStatus';
const GET_LOCATION_API_TIMEOUT_SECOND = 15;

class AppointmentActivity {
  static const addAppointment = 'add_appointment';
  static const assignedAppointment = 'collector_assigned';
}

//region GenderConstant
class GenderConstant {
  static const female = 'female';
  static const male = 'male';
  static const other = 'other';
}
//endregion

//region Notification
class NotificationType {
  static const appointment = 'appointment';
}
//endregion

class TestType {
  static const testCase = 'test_case';
  static const testPackage = 'test_package';
}