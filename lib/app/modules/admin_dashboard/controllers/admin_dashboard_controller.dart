import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io'; // Penting untuk File
import 'package:image_picker/image_picker.dart';

class AdminDashboradController extends GetxController {
  final supabase = Supabase.instance.client;
  var imagePath = ''.obs;

  // Observable list untuk menyimpan data dari database
  var listData = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Ambil data saat pertama kali dibuka
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      final data = await supabase.from('laundry_services').select();
      print("Data yang didapat: $data");
      listData.assignAll(data);
    } catch (e) {
      print("Error Supabase: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteData(String id) async {
    try {
      // 1. Tampilkan loading atau konfirmasi (opsional)
      // Get.dialog(Center(child: CircularProgressIndicator()));

      // 2. Perintah hapus ke Supabase
      // Menghapus baris di tabel 'services' yang kolom 'id'-nya cocok
      await supabase.from('laundry_services').delete().match({
        'id': id,
      }).select();

      // 3. Update data di lokal (UI) tanpa perlu narik data ulang dari internet (lebih cepat)
      listData.removeWhere((item) => item['id'] == id);

      // 4. Beri feedback ke user
      Get.snackbar(
        'Sukses',
        'Data berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // 5. Tangani jika ada error (misal: masalah jaringan)
      Get.snackbar(
        'Gagal',
        'Gagal menghapus data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi Pilih Gambar
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  // Fungsi Upload ke Supabase Storage
 Future<String?> uploadImage(File imageFile) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'uploads/$fileName';

      // Pastikan nama bucket 'laundry_services' atau 'services' sesuai di dashboard Supabase Anda
      await supabase.storage.from('laundry_services').upload(path, imageFile);

      // Ambil URL publik
      final String publicUrl = supabase.storage.from('laundry_services').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  // Update Fungsi Create Data
  Future<void> createData({
    required String name,
    required String subtitle,
    required String price,
    required String description,
  }) async {
    try {
      isLoading(true);
      String? finalUrl;

      // Jika ada gambar yang dipilih, upload dulu
      if (imagePath.value.isNotEmpty) {
        finalUrl = await uploadImage(File(imagePath.value));
      }

      await supabase.from('laundry_services').insert({
        'name': name,
        'subtitle': subtitle,
        'image_url': finalUrl, // Gunakan URL dari storage
        'price': price,
        'description': description,
      });

      await fetchData();
      imagePath.value = ''; // Reset path
      Get.back();
      Get.snackbar('Sukses', 'Data tersimpan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }


  Future<void> updateData({
    required String id,
    required String name,
    required String subtitle,
    required String price,
    required String description,
    String? oldImageUrl, // Tambahkan parameter URL lama
  }) async {
    try {
      isLoading(true);
      String? finalUrl = oldImageUrl; // Default pakai URL lama

      // Logika: Jika user memilih gambar baru (imagePath tidak kosong)
      if (imagePath.value.isNotEmpty) {
        finalUrl = await uploadImage(File(imagePath.value));
        if (finalUrl == null) {
          Get.snackbar('Error', 'Gagal mengunggah gambar baru');
          return;
        }
      }

      // Update ke database
      await supabase
          .from('laundry_services')
          .update({
            'name': name,
            'subtitle': subtitle,
            'image_url': finalUrl, // Gunakan URL baru atau URL lama
            'price': price,
            'description': description,
          })
          .match({'id': id});

      await fetchData(); // Refresh UI
      imagePath.value = ''; // Reset path gambar
      Get.back(); // Tutup bottom sheet
      Get.snackbar(
        'Sukses',
        'Data berhasil diperbarui',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
