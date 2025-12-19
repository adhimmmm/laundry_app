import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
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

            const SizedBox(height: 40),

            /// LOGOUT
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: controller.logout,
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
            child: const Icon(
              Icons.person,
              size: 42,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.fullName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.email,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
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
    final nameController =
        TextEditingController(text: controller.fullName);

    Get.dialog(
      AlertDialog(
        title: const Text('Update Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
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
        content: const SingleChildScrollView(
          child: Text(
            'Q: How to order laundry?\n'
            'A: Choose service and place order.\n\n'
            'Q: How long does it take?\n'
            'A: Usually 1–2 days.\n\n'
            'Q: How to contact support?\n'
            'A: Via Help Center.',
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Close')),
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
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Close')),
        ],
      ),
    );
  }
}
