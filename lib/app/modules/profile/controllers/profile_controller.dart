import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  // Tambahkan baris ini
  final RxBool isUpdating = false.obs;
  
  // Observable untuk menyimpan data profil dari tabel profiles
  var userData = <String, dynamic>{}.obs;
  var isAdmin = false.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Jalankan pengecekan otomatis setiap kali status auth berubah
    _client.auth.onAuthStateChange.listen((data) {
      if (data.session?.user != null) {
        fetchUserProfile(data.session!.user.id);
      } else {
        // Reset jika logout
        userData.clear();
        isAdmin.value = false;
      }
    });
    
    // Ambil data saat ini jika session sudah ada
    final currentId = _client.auth.currentUser?.id;
    if (currentId != null) fetchUserProfile(currentId);
  }

  // Getter agar UI gampang memanggilnya
  String get name => userData['name'] ?? 'User';
  String get email => userData['email'] ?? '-';
  String get imageUrl => userData['image_url'] ?? '';

  Future<void> fetchUserProfile(String userId) async {
    try {
      isLoading.value = true;
      final data = await _client
          .from('profiles')
          .select('name, email, role, image_url')
          .eq('id', userId)
          .single();

      userData.value = data;
      isAdmin.value = (data['role'] == 'admin');
        } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // Tambahkan di ProfileController
var imagePath = ''.obs; // Untuk menampung path gambar yang baru dipilih

Future<void> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    imagePath.value = image.path;
  }
}

Future<void> updateProfile({required String newName, required String newEmail}) async {
  try {
    isUpdating.value = true;
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    // Tetap gunakan URL lama sebagai default
    String? finalImageUrl = userData['image_url'];

    // 1. Jika ada gambar baru, upload ke Storage
    if (imagePath.value.isNotEmpty) {
      final file = File(imagePath.value);
      // Gunakan nama file yang unik atau timpa yang lama
      final fileName = '$userId.jpg';   
      
      // Pastikan nama bucket 'profiles' sudah dibuat di Dashboard Supabase
      // Gunakan upsert: true agar jika file sudah ada, dia akan menimpa (mencegah error 409/403)
      await _client.storage.from('profiles').upload(
        fileName, 
        file,
        fileOptions: const FileOptions(upsert: true),
      );

      finalImageUrl = _client.storage.from('profiles').getPublicUrl(fileName);
    }

    // 2. Update Tabel Profiles (Database)
    // Gunakan try-catch spesifik untuk database update
    await _client.from('profiles').update({
      'name': newName,
      'email': newEmail,
      'image_url': finalImageUrl,
    }).eq('id', userId);

    // 3. Update Email di Supabase Auth (Hanya jika email benar-benar berubah)
    // CATATAN: Ini sering memicu 403 jika pengaturan konfirmasi email aktif di Supabase
    if (newEmail.isNotEmpty && newEmail != _client.auth.currentUser?.email) {
      await _client.auth.updateUser(UserAttributes(email: newEmail));
      Get.snackbar('Info', 'Silahkan konfirmasi email baru Anda jika diperlukan.');
    }

    await fetchUserProfile(userId);
    imagePath.value = ''; 
    
    if (Get.isDialogOpen == true) Get.back(); // Tutup dialog jika terbuka
    
    Get.snackbar(
      'Success', 
      'Profile updated successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    print("Error Update: $e");
    Get.snackbar('Error', 'Gagal memperbarui profil. Periksa koneksi atau izin akses.');
  } finally {
    isUpdating.value = false;
  }
}
  void logout() {
    Get.find<AuthController>().logout();
  }
}