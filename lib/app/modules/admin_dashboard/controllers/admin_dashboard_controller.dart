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
  var filterCategory = 'All'.obs; // untuk filter chart

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

  // Computed properties untuk Dashboard Statistics
  int get totalServices => listData.length;

  int get totalByCategory {
    if (filterCategory.value == 'All') return listData.length;
    return listData
        .where((item) => item['category'] == filterCategory.value)
        .length;
  }

  double get averagePrice {
    if (listData.isEmpty) return 0;
    final total = listData.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item['price'].toString()) ?? 0),
    );
    return total / listData.length;
  }

  Map<String, int> get categoryDistribution {
    final distribution = <String, int>{};
    for (var category in categories) {
      if (category == 'All') continue;
      distribution[category] =
          listData.where((item) => item['category'] == category).length;
    }
    return distribution;
  }

  // Get filtered data berdasarkan kategori
  List<Map<String, dynamic>> get filteredData {
    if (filterCategory.value == 'All') return listData;
    return listData
        .where((item) => item['category'] == filterCategory.value)
        .toList();
  }

  // Get recent services (untuk sparkline/timeline)
  List<Map<String, dynamic>> get recentServices {
    final sorted = List<Map<String, dynamic>>.from(listData);
    sorted.sort((a, b) {
      final aDate = DateTime.tryParse(a['created_at']?.toString() ?? '');
      final bDate = DateTime.tryParse(b['created_at']?.toString() ?? '');
      if (aDate == null || bDate == null) return 0;
      return bDate.compareTo(aDate);
    });
    return sorted.take(5).toList();
  }

  // Get price range data
  Map<String, int> get priceRangeDistribution {
    final ranges = <String, int>{
      '0-50k': 0,
      '50k-100k': 0,
      '100k-200k': 0,
      '200k+': 0,
    };

    for (var item in listData) {
      final price = double.tryParse(item['price'].toString()) ?? 0;
      if (price < 50000) {
        ranges['0-50k'] = (ranges['0-50k'] ?? 0) + 1;
      } else if (price < 100000) {
        ranges['50k-100k'] = (ranges['50k-100k'] ?? 0) + 1;
      } else if (price < 200000) {
        ranges['100k-200k'] = (ranges['100k-200k'] ?? 0) + 1;
      } else {
        ranges['200k+'] = (ranges['200k+'] ?? 0) + 1;
      }
    }
    return ranges;
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