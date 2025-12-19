import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final SupabaseService _supabase = SupabaseService();

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    user.value = _supabase.currentUser;

    /// AUTO LOGIN CHECK
    if (user.value != null) {
      Get.offAllNamed(Routes.MAIN_VIEW);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      await _supabase.signIn(email, password);
      user.value = _supabase.currentUser;

      Get.offAllNamed(Routes.MAIN_VIEW);
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;

      await _supabase.signUp(email, password);

      Get.snackbar(
        'Success',
        'Account created, please login',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back(); // balik ke login
    } catch (e) {
      Get.snackbar(
        'Register Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _supabase.logout();
    user.value = null;
    Get.offAllNamed(Routes.AUTH);
  }
}
