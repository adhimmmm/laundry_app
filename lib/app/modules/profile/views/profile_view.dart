

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileCard(isDark),
            const SizedBox(height: 20),
            _buildMenuSection(authController, isDark),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE CARD =================
  Widget _buildProfileCard(bool isDark) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Avatar
            Hero(
              tag: 'profile_avatar',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Name
            Text(
              controller.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    controller.email,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Verified Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 6),
                  Text(
                    'Verified Account',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MENU SECTION =================
  Widget _buildMenuSection(AuthController authController, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          _buildModernMenuItem(
            icon: Icons.person_outline_rounded,
            title: 'Your Profile',
            subtitle: 'Update your name',
            iconBgColor: Colors.blue.shade50,
            iconColor: Colors.blue.shade600,
            onTap: () => _showEditProfile(),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildModernMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Application preferences',
            iconBgColor: Colors.purple.shade50,
            iconColor: Colors.purple.shade600,
            onTap: () {
              Get.snackbar(
                'Settings',
                'Settings feature coming soon',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                colorText: isDark ? Colors.white : Colors.black87,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildModernMenuItem(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            subtitle: 'Frequently Asked Questions',
            iconBgColor: Colors.orange.shade50,
            iconColor: Colors.orange.shade600,
            onTap: () => _showFaqDialog(),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildModernMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            iconBgColor: Colors.green.shade50,
            iconColor: Colors.green.shade600,
            onTap: () => _showPrivacyDialog(),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          // Di dalam Column menu profil Anda
Obx(() {
  // Jika role adalah admin, tampilkan menu
  if (controller.isAdmin.value) {
    return Column(
      children: [
        _buildDivider(isDark), // Garis pembatas agar rapi
        _buildModernMenuItem(
          icon: Icons.storage_rounded,
          title: 'Admin Storage',
          subtitle: 'Management storage and services',
          iconBgColor: Colors.indigo.shade50,
          iconColor: Colors.indigo.shade600,
          onTap: () => Get.toNamed(Routes.ADMIN_DASHBORAD),
          isDark: isDark,
        ),
      ],
    );
  }

  // Jika BUKAN admin, kembalikan widget kosong tanpa dimensi (0x0)
  // Ini akan menghilangkan menu sepenuhnya dari tampilan
  return const SizedBox.shrink();
}),
          const SizedBox(height: 20),
          _buildLogoutButton(authController),
        ],
      ),
    );
  }

  // ================= MODERN MENU ITEM =================
  Widget _buildModernMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? Colors.grey[800] : Colors.grey[200],
    );
  }

  // ================= LOGOUT BUTTON =================
  Widget _buildLogoutButton(AuthController authController) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => authController.logout(),
          borderRadius: BorderRadius.circular(14),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= DIALOGS =================

  void _showEditProfile() {
  final nameController = TextEditingController(text: controller.name);
  final emailController = TextEditingController(text: controller.email);

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit Profile', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              const SizedBox(height: 25),
              _buildEditTextField(nameController, 'Full Name', Icons.person),
              const SizedBox(height: 15),
              _buildEditTextField(emailController, 'Email', Icons.email),
              
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : () => controller.updateProfile(
                                newName: nameController.text.trim(),
                                newEmail: emailController.text.trim(),
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: controller.isUpdating.value
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Save Changes', style: TextStyle(color: Colors.white)),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Helper Widget untuk TextField agar kode lebih bersih
Widget _buildEditTextField(TextEditingController controller, String label, IconData icon) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, size: 20),
      labelText: label,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
  );
}
  void _showFaqDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      color: Colors.orange.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'FAQ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: FutureBuilder<List<dynamic>>(
                  future: HttpService.getFaqs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            const Text('Gagal memuat FAQ'),
                          ],
                        ),
                      );
                    }

                    final faqs = snapshot.data!;

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: faqs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final faq = faqs[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.question_mark_rounded,
                                      size: 16,
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      faq['question'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Text(
                                  faq['answer'],
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  color: Colors.green.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'We respect your privacy.\n\n'
                  'Your data is used only to provide laundry services '
                  'and will not be shared with third parties.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.6,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: Get.back,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}