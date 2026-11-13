import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/appointment_payment/bindings/appointment_payment_binding.dart';
import '../modules/appointment_payment/views/appointment_payment_view.dart';
import '../modules/barber_detail/bindings/barber_detail_binding.dart';
import '../modules/barber_detail/views/barber_detail_view.dart';
import '../modules/book_appointment/bindings/book_appointment_binding.dart';
import '../modules/book_appointment/views/book_appointment_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chat_room/bindings/chat_room_binding.dart';
import '../modules/chat_room/views/chat_room_view.dart';
import '../modules/explore_barbers/bindings/explore_barbers_binding.dart';
import '../modules/explore_barbers/views/explore_barbers_view.dart';
import '../modules/find_barber/bindings/find_barber_binding.dart';
import '../modules/find_barber/views/find_barber_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/intro_screen/bindings/intro_screen_binding.dart';
import '../modules/intro_screen/views/intro_screen_view.dart';
import '../modules/invoice/bindings/invoice_binding.dart';
import '../modules/invoice/views/invoice_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/mitra_chat/bindings/mitra_chat_binding.dart';
import '../modules/mitra_chat/views/mitra_chat_view.dart';
import '../modules/mitra_chat_room/bindings/mitra_chat_room_binding.dart';
import '../modules/mitra_chat_room/views/mitra_chat_room_view.dart';
import '../modules/mitra_dashboard/bindings/mitra_dashboard_binding.dart';
import '../modules/mitra_dashboard/views/mitra_dashboard_view.dart';
import '../modules/mitra_earnings/bindings/mitra_earnings_binding.dart';
import '../modules/mitra_earnings/views/mitra_earnings_view.dart';
import '../modules/mitra_login/bindings/mitra_login_binding.dart';
import '../modules/mitra_login/views/mitra_login_view.dart';
import '../modules/mitra_main/bindings/mitra_main_binding.dart';
import '../modules/mitra_main/views/mitra_main_view.dart';
import '../modules/mitra_order_detail/bindings/mitra_order_detail_binding.dart';
import '../modules/mitra_order_detail/views/mitra_order_detail_view.dart';
import '../modules/mitra_orders/bindings/mitra_orders_binding.dart';
import '../modules/mitra_orders/views/mitra_orders_view.dart';
import '../modules/mitra_profile/bindings/mitra_profile_binding.dart';
import '../modules/mitra_profile/views/mitra_profile_view.dart';
import '../modules/mitra_register/bindings/mitra_register_binding.dart';
import '../modules/mitra_register/views/mitra_register_view.dart';
import '../modules/mitra_reviews/bindings/mitra_reviews_binding.dart';
import '../modules/mitra_reviews/views/mitra_reviews_view.dart';
import '../modules/mitra_schedule/bindings/mitra_schedule_binding.dart';
import '../modules/mitra_schedule/views/mitra_schedule_view.dart';
import '../modules/mitra_service_form/bindings/mitra_service_form_binding.dart';
import '../modules/mitra_service_form/views/mitra_service_form_view.dart';
import '../modules/mitra_services/bindings/mitra_services_binding.dart';
import '../modules/mitra_services/views/mitra_services_view.dart';
import '../modules/mitra_settings/bindings/mitra_settings_binding.dart';
import '../modules/mitra_settings/views/mitra_settings_view.dart';
import '../modules/mitra_shop_profile/bindings/mitra_shop_profile_binding.dart';
import '../modules/mitra_shop_profile/views/mitra_shop_profile_view.dart';
import '../modules/mitra_team/bindings/mitra_team_binding.dart';
import '../modules/mitra_team/views/mitra_team_view.dart';
import '../modules/mitra_team_form/bindings/mitra_team_form_binding.dart';
import '../modules/mitra_team_form/views/mitra_team_form_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/otp_screen/bindings/otp_screen_binding.dart';
import '../modules/otp_screen/views/otp_screen_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/rating_review/bindings/rating_review_binding.dart';
import '../modules/rating_review/views/rating_review_view.dart';
import '../modules/register_screen/bindings/register_screen_binding.dart';
import '../modules/register_screen/views/register_screen_view.dart';
import '../modules/security/bindings/security_binding.dart';
import '../modules/security/views/security_view.dart';
import '../modules/splash_scree/bindings/splash_scree_binding.dart';
import '../modules/splash_scree/views/splash_scree_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 220),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.HELP,
      page: () => const HelpView(),
      binding: HelpBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREE,
      page: () => const SplashScreeView(),
      binding: SplashScreeBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREEN,
      page: () => const IntroScreenView(),
      binding: IntroScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => const LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_SCREEN,
      page: () => const OtpScreenView(),
      binding: OtpScreenBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_SCREEN,
      page: () => const RegisterScreenView(),
      binding: RegisterScreenBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE_BARBERS,
      page: () => const ExploreBarbersView(),
      binding: ExploreBarbersBinding(),
    ),
    GetPage(
      name: _Paths.FIND_BARBER,
      page: () => const FindBarberView(),
      binding: FindBarberBinding(),
    ),
    GetPage(
      name: _Paths.BARBER_DETAIL,
      page: () => const BarberDetailView(),
      binding: BarberDetailBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_APPOINTMENT,
      page: () => const BookAppointmentView(),
      binding: BookAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.APPOINTMENT_PAYMENT,
      page: () => const AppointmentPaymentView(),
      binding: AppointmentPaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE,
      page: () => const InvoiceView(),
      binding: InvoiceBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 220),
    ),
    GetPage(
      name: _Paths.RATING_REVIEW,
      page: () => const RatingReviewView(),
      binding: RatingReviewBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 220),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 220),
    ),
    GetPage(
      name: _Paths.SECURITY,
      page: () => const SecurityView(),
      binding: SecurityBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_LOGIN,
      page: () => const MitraLoginView(),
      binding: MitraLoginBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_REGISTER,
      page: () => const MitraRegisterView(),
      binding: MitraRegisterBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_MAIN,
      page: () => const MitraMainView(),
      binding: MitraMainBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_DASHBOARD,
      page: () => const MitraDashboardView(),
      binding: MitraDashboardBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_ORDERS,
      page: () => const MitraOrdersView(),
      binding: MitraOrdersBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_ORDER_DETAIL,
      page: () => const MitraOrderDetailView(),
      binding: MitraOrderDetailBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_SCHEDULE,
      page: () => const MitraScheduleView(),
      binding: MitraScheduleBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_SERVICES,
      page: () => const MitraServicesView(),
      binding: MitraServicesBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_SERVICE_FORM,
      page: () => const MitraServiceFormView(),
      binding: MitraServiceFormBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_TEAM,
      page: () => const MitraTeamView(),
      binding: MitraTeamBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_TEAM_FORM,
      page: () => const MitraTeamFormView(),
      binding: MitraTeamFormBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_REVIEWS,
      page: () => const MitraReviewsView(),
      binding: MitraReviewsBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_EARNINGS,
      page: () => const MitraEarningsView(),
      binding: MitraEarningsBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_SHOP_PROFILE,
      page: () => const MitraShopProfileView(),
      binding: MitraShopProfileBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_CHAT,
      page: () => const MitraChatView(),
      binding: MitraChatBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_CHAT_ROOM,
      page: () => const MitraChatRoomView(),
      binding: MitraChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_SETTINGS,
      page: () => const MitraSettingsView(),
      binding: MitraSettingsBinding(),
    ),
    GetPage(
      name: _Paths.MITRA_PROFILE,
      page: () => const MitraProfileView(),
      binding: MitraProfileBinding(),
    ),
  ];
}
