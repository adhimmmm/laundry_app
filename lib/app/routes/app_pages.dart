import 'package:get/get.dart';

import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/laundry_map/bindings/laundry_map_binding.dart';
import '../modules/laundry_map/views/laundry_map_view.dart';
import '../modules/main_view/bindings/main_view_binding.dart';
import '../modules/main_view/views/main_view_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/popular_services_detail/bindings/popular_services_detail_binding.dart';
import '../modules/popular_services_detail/views/popular_services_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_VIEW,
      page: () => const MainView(),
      binding: MainViewBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LAUNDRY_MAP,
      page: () => const LaundryMapView(),
      binding: LaundryMapBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBORAD,
      page: () => const AdminDashboradView(),
      binding: AdminDashboradBinding(),
    ),
    GetPage(
      name: _Paths.POPULAR_SERVICES_DETAIL,
      page: () => const PopularServicesDetailView(),
      binding: PopularServicesDetailBinding(),
    ),
  ];
}
