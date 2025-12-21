import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  final RxBool isUpdating = false.obs;
  final RxBool isLoading = true.obs;
  
  var userData = <String, dynamic>{}.obs;
  var isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    _client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (user != null) {
        fetchUserProfile(user.id);
      } else {
        userData.clear();
        isAdmin.value = false;
      }
    });
    
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId != null) fetchUserProfile(currentUserId);
  }

  String get name => userData['name'] ?? 'User';
  String get email => userData['email'] ?? '-';
  bool get isLoggedIn => _client.auth.currentUser != null;

  Future<void> fetchUserProfile(String userId) async {
    try {
      isLoading.value = true;
      final data = await _client
          .from('profiles')
          .select('name, email, role')
          .eq('id', userId)
          .single();

      userData.value = data;
      isAdmin.value = (data['role'] == 'admin');
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({required String newName, required String newEmail}) async {
    try {
      isUpdating.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      await _client.from('profiles').update({
        'name': newName,
        'email': newEmail,
      }).eq('id', userId);

      if (newEmail.isNotEmpty && newEmail != _client.auth.currentUser?.email) {
        await _client.auth.updateUser(UserAttributes(email: newEmail));
      }

      await fetchUserProfile(userId);
      
      Get.snackbar(
        'Success', 
        'Profile updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Gagal memperbarui profil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  void logout() {
    Get.find<AuthController>().logout();
  }
}