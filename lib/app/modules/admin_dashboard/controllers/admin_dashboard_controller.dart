import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboradController extends GetxController {
  final supabase = Supabase.instance.client;

  var listData = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var imagePath = ''.obs;

  final categories = <String>[
    'All',
    'Washing',
    'Ironing',
    'Dry Clean',
    'Carpet',
    'Shoe',
  ].obs;

  var selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      final data = await supabase.from('laundry_services').select();
      listData.assignAll(data);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteData(String id) async {
    try {
      await supabase.from('laundry_services').delete().match({'id': id});
      listData.removeWhere((item) => item['id'] == id);
      Get.snackbar(
        'Sukses',
        'Data berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'uploads/$fileName';

      await supabase.storage.from('laundry-services').upload(
            path,
            imageFile,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final publicUrl =
          supabase.storage.from('laundry-services').getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> createData({
    required String name,
    required String subtitle,
    required String price,
    required String description,
  }) async {
    try {
      if (selectedCategory.value.isEmpty) {
        Get.snackbar('Error', 'Kategori harus dipilih');
        return;
      }

      isLoading(true);

      String? imageUrl;

      if (imagePath.value.isNotEmpty) {
        imageUrl = await uploadImage(File(imagePath.value));
        if (imageUrl == null) {
          Get.snackbar('Error', 'Upload gambar gagal');
          return;
        }
      }

      await supabase.from('laundry_services').insert({
        'name': name,
        'subtitle': subtitle,
        'price': price,
        'description': description,
        'category': selectedCategory.value,
        'image_url': imageUrl,
      });

      await fetchData();
      imagePath.value = '';
      selectedCategory.value = '';
      Get.back();

      Get.snackbar(
        'Sukses',
        'Data berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
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
    String? oldImageUrl,
  }) async {
    try {
      if (selectedCategory.value.isEmpty) {
        Get.snackbar('Error', 'Kategori harus dipilih');
        return;
      }

      isLoading(true);

      String? imageUrl = oldImageUrl;

      if (imagePath.value.isNotEmpty) {
        final uploadedUrl = await uploadImage(File(imagePath.value));
        if (uploadedUrl == null) {
          Get.snackbar('Error', 'Upload gambar gagal');
          return;
        }
        imageUrl = uploadedUrl;
      }

      await supabase.from('laundry_services').update({
        'name': name,
        'subtitle': subtitle,
        'price': price,
        'description': description,
        'category': selectedCategory.value,
        'image_url': imageUrl,
      }).match({'id': id});

      await fetchData();
      imagePath.value = '';
      selectedCategory.value = '';
      Get.back();

      Get.snackbar(
        'Sukses',
        'Data berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
