import 'package:get/get.dart';

import '../modules/appointment_payment/bindings/appointment_payment_binding.dart';
import '../modules/appointment_payment/views/appointment_payment_view.dart';
import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
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
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';
import '../modules/intro_screen/bindings/intro_screen_binding.dart';
import '../modules/intro_screen/views/intro_screen_view.dart';
import '../modules/invoice/bindings/invoice_binding.dart';
import '../modules/invoice/views/invoice_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
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
  ];
}
