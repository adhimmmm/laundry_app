import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loundry_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:loundry_app/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import '../../../core/services/http_service.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 30),

            _menuCard(
              icon: Icons.person_outline,
              title: 'Your Profile',
              subtitle: 'Update your name',
              onTap: () => _showEditNameDialog(),
            ),

            _menuCard(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Application preferences',
              onTap: () {
                Get.snackbar(
                  'Settings',
                  'Settings feature coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),

            _menuCard(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Frequently Asked Questions',
              onTap: () => _showFaqDialog(),
            ),

            _menuCard(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () => _showPrivacyDialog(),
            ),

            _menuCard(
              icon: Icons.storage,
              title: 'Admin Storage',
              subtitle: 'Management storage and  services',
              onTap: () => {
                Get.toNamed(Routes.ADMIN_DASHBORAD),
              },
            ),

            const SizedBox(height: 40),

            /// LOGOUT
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => {authController.logout()},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _profileHeader() {
    return Obx(
      () => Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: const Icon(Icons.person, size: 42, color: Colors.blue),
          ),
          const SizedBox(height: 12),
          Text(
            controller.fullName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(controller.email, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // ================= MENU CARD =================

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // ================= DIALOGS =================

  void _showEditNameDialog() {
    final nameController = TextEditingController(text: controller.fullName);

    Get.dialog(
      AlertDialog(
        title: const Text('Update Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Full Name'),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isUpdating.value
                  ? null
                  : () {
                      controller.updateName(nameController.text.trim());
                      Get.back();
                    },
              child: controller.isUpdating.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  void _showFaqDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('FAQ'),
        content: SizedBox(
          width: double.maxFinite,
          child: FutureBuilder<List<dynamic>>(
            future: HttpService.getFaqs(),
            builder: (context, snapshot) {
              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // error
              if (snapshot.hasError) {
                return const Text('Gagal memuat FAQ');
              }

              final faqs = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: faqs.map((faq) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q: ${faq['question']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('A: ${faq['answer']}'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'We respect your privacy.\n\n'
            'Your data is used only to provide laundry services '
            'and will not be shared with third parties.',
          ),
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('Close'))],
      ),
    );
  }
}
