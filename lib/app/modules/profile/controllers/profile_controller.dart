import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _client.auth.currentUser;
  }

  String get email => user.value?.email ?? '-';
  String get fullName =>
      user.value?.userMetadata?['full_name'] ?? 'User';

  Future<void> updateName(String name) async {
    try {
      isUpdating.value = true;

      await _client.auth.updateUser(
        UserAttributes(
          data: {'full_name': name},
        ),
      );

      user.value = _client.auth.currentUser;

      Get.snackbar(
        'Success',
        'Name updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  void logout() {
    Get.find<AuthController>().logout();
  }
}
