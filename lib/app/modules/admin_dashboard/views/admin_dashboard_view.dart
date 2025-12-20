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
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.listData.isEmpty) {
              return const Center(child: Text("Tidak ada data"));
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
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
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    title: Text(item['name'] ?? ''),
                    subtitle: Text(item['subtitle'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => showEditForm(context, item),
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
                                controller.deleteData(item['id'].toString());
                                Get.back();
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => showCreateForm(context),
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

    controller.imagePath.value = '';
    controller.selectedCategory.value = '';

    Get.bottomSheet(
      _formContainer(
        title: "Tambah Service Baru",
        nameController: nameController,
        subController: subController,
        priceController: priceController,
        descController: descController,
        onSubmit: () => controller.createData(
          name: nameController.text,
          subtitle: subController.text,
          price: priceController.text,
          description: descController.text,
        ),
        buttonText: "Simpan Data",
        buttonColor: Colors.blue,
      ),
      isScrollControlled: true,
    );
  }

  void showEditForm(BuildContext context, Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name']);
    final subController = TextEditingController(text: item['subtitle']);
    final priceController =
        TextEditingController(text: item['price'].toString());
    final descController = TextEditingController(text: item['description']);

    controller.imagePath.value = '';
    controller.selectedCategory.value = item['category'] ?? '';

    Get.bottomSheet(
      _formContainer(
        title: "Edit Service",
        nameController: nameController,
        subController: subController,
        priceController: priceController,
        descController: descController,
        oldImageUrl: item['image_url'],
        onSubmit: () => controller.updateData(
          id: item['id'].toString(),
          name: nameController.text,
          subtitle: subController.text,
          price: priceController.text,
          description: descController.text,
          oldImageUrl: item['image_url'],
        ),
        buttonText: "Perbarui Data",
        buttonColor: Colors.orange,
      ),
      isScrollControlled: true,
    );
  }

  Widget _formContainer({
    required String title,
    required TextEditingController nameController,
    required TextEditingController subController,
    required TextEditingController priceController,
    required TextEditingController descController,
    required VoidCallback onSubmit,
    required String buttonText,
    required Color buttonColor,
    String? oldImageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Obx(
              () => GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: controller.imagePath.value.isEmpty
                      ? (oldImageUrl != null && oldImageUrl.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                oldImageUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.camera_alt, size: 40),
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
            _textField(nameController, "Nama Service", Icons.label),
            _textField(subController, "Subtitle", Icons.subtitles),
            _textField(priceController, "Price", Icons.money,
                isNumber: true),
            _textField(descController, "Description", Icons.description,
                maxLines: 3),
            const SizedBox(height: 12),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                items: controller.categories
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    controller.selectedCategory.value = value ?? '',
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: buttonColor),
                  onPressed: controller.isLoading.value ? null : onSubmit,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          buttonText,
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController ctrl,
    String label,
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
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
