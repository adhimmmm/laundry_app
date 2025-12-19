import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboradController extends GetxController {
  final supabase = Supabase.instance.client;

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

  // Controller
  Future<void> createData({
    required String name,
    required String subtitle,
    required String imageUrl,
    required String price,
    required String description,
  }) async {
    try {
      isLoading(true);
      await supabase.from('laundry_services').insert({
        'name': name, // pastikan nama kolom sesuai di database
        'subtitle': subtitle,
        'image_url': imageUrl,
        'price': price,
        'description': description,
      });

      await fetchData(); // Refresh data setelah menambah
      Get.back(); // Tutup popup
      Get.snackbar(
        'Sukses',
        'Data berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateData({
    required String id,
    required String name,
    required String subtitle,
    required String imageUrl,
    required String price,
    required String description,
  }) async {
    try {
      isLoading(true);
      await supabase
          .from('laundry_services')
          .update({
            'name': name,
            'subtitle': subtitle,
            'image_url': imageUrl,
            'price': price,
            'description': description,
          })
          .match({'id': id}); // Mencocokkan UUID/ID yang akan diedit

      await fetchData(); // Refresh list agar data terbaru muncul
      Get.back(); // Tutup popup
      Get.snackbar(
        'Sukses',
        'Data berhasil diperbarui',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
