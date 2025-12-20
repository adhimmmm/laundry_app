import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboradView extends GetView<AdminDashboradController> {
  const AdminDashboradView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), centerTitle: true),
      body: Stack(
        children: [
          // Gunakan Obx agar UI reaktif terhadap perubahan data di controller
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.listData.isEmpty) {
              return const Center(child: Text("Tidak ada data"));
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                80,
              ), // Padding bawah agar tidak tertutup tombol
              itemCount: controller.listData.length,
              itemBuilder: (context, index) {
                final item = controller.listData[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['image_url'] ?? '',
                        key: ValueKey(item['image_url']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image), // Jika link error
                      ),
                    ),
                    title: Text(item['name'] ?? 'Tanpa Judul'), // Field judul
                    subtitle: Text(
                      item['subtitle'] ?? 'Tanpa Sub',
                    ), // Field sub judul
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => showEditForm(
                            context,
                            item,
                          ), // Kirim data 'item' baris ini
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Hapus Data",
                              middleText:
                                  "Apakah Anda yakin ingin menghapus data ini?",
                              textConfirm: "Hapus",
                              textCancel: "Batal",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              onConfirm: () {
                                controller.deleteData(item['id']);
                                Get.back(); // Menutup dialog setelah klik hapus
                              },
                            );
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),

          // Tombol Create (Tetap sama seperti desain sketsamu)
          // Di dalam build AdminDashboradView
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () =>
                      showCreateForm(context), // Panggil popup form di sini
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCreateForm(BuildContext context) {
    final nameController = TextEditingController();
    final subController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();

    // Reset imagePath saat buka form
    controller.imagePath.value = '';

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Tambah Service Baru",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // --- UI PILIH GAMBAR ---
              Obx(
                () => GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: controller.imagePath.value.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 40),
                              Text("Klik untuk upload gambar"),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(controller.imagePath.value),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              _buildTextField(nameController, "Nama Service", Icons.label),
              _buildTextField(subController, "Subtitle", Icons.subtitles),
              _buildTextField(
                priceController,
                "Price",
                Icons.money,
                isNumber: true,
              ),
              _buildTextField(
                descController,
                "Description",
                Icons.description,
                maxLines: 3,
              ),

              const SizedBox(height: 20),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.createData(
                            name: nameController.text,
                            subtitle: subController.text,
                            price: priceController.text,
                            description: descController.text,
                          ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Simpan Data",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Widget bantuan untuk input field yang rapi
  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void showEditForm(BuildContext context, Map<String, dynamic> item) {
    // Isi controller langsung dengan data yang sudah ada
    final nameController = TextEditingController(text: item['name']);
    final subController = TextEditingController(text: item['subtitle']);
    final priceController = TextEditingController(
      text: item['price'].toString(),
    );
    final descController = TextEditingController(text: item['description']);

    // Reset imagePath saat buka form agar tidak nyangkut dari editan sebelumnya
    controller.imagePath.value = '';

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Edit Service",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // --- UI PILIH GAMBAR (SAMA DENGAN CREATE) ---
              Obx(
                () => GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: controller.imagePath.value.isEmpty
                        ? (item['image_url'] != null &&
                                  item['image_url'].toString().startsWith(
                                    'http',
                                  )
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item['image_url'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt, size: 40),
                                    Text("Klik untuk ganti gambar"),
                                  ],
                                ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(controller.imagePath.value),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              _buildTextField(nameController, "Nama Service", Icons.label),
              _buildTextField(subController, "Subtitle", Icons.subtitles),
              _buildTextField(
                priceController,
                "Price",
                Icons.money,
                isNumber: true,
              ),
              _buildTextField(
                descController,
                "Description",
                Icons.description,
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              // --- TOMBOL UPDATE ---
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ), // Warna orange untuk Edit
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.updateData(
                            id: item['id'].toString(),
                            name: nameController.text,
                            subtitle: subController.text,
                            price: priceController.text,
                            description: descController.text,
                            oldImageUrl: item['image_url'],
                          ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Perbarui Data",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
