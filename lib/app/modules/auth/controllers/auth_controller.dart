import 'package:flutter/material.dart';
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
  }

  @override
  void onReady() {
    super.onReady();
    if (user.value != null) {
      if (Get.currentRoute != Routes.MAIN_VIEW) {
        Get.offAllNamed(Routes.MAIN_VIEW);
      }
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Login Failed',
        'Email and password cannot be empty',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _supabase.signIn(email, password);
      user.value = _supabase.currentUser;
      Get.offAllNamed(Routes.MAIN_VIEW);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Incorrect email or password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar(
        'Registration Failed',
        'All fields must be filled',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Warning',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _supabase.signUp(email, password);
      
      Get.snackbar(
        'Success',
        'Account created, please login',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Register Failed',
        'Could not create account. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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