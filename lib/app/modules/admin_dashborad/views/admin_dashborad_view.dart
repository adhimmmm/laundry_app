import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashborad_controller.dart';

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
                        item['image_url'] ??
                            '', // Ambil field image_url dari database
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
    final imgController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tambah Service Baru",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildTextField(nameController, "Nama Service", Icons.label),
              _buildTextField(subController, "Subtitle", Icons.subtitles),
              _buildTextField(imgController, "Image URL", Icons.image),
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    controller.createData(
                      name: nameController.text,
                      subtitle: subController.text,
                      imageUrl: imgController.text,
                      price: priceController.text,
                      description: descController.text,
                    );
                  },
                  child: const Text(
                    "Simpan Data",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true, // Agar form tidak tertutup keyboard
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
  // Isi controller langsung dengan data yang sudah ada (item)
  final nameController = TextEditingController(text: item['name']);
  final subController = TextEditingController(text: item['subtitle']);
  final imgController = TextEditingController(text: item['image_url']);
  final priceController = TextEditingController(text: item['price'].toString());
  final descController = TextEditingController(text: item['description']);

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Edit Service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildTextField(nameController, "Nama Service", Icons.label),
            _buildTextField(subController, "Subtitle", Icons.subtitles),
            _buildTextField(imgController, "Image URL", Icons.image),
            _buildTextField(priceController, "Price", Icons.money, isNumber: true),
            _buildTextField(descController, "Description", Icons.description, maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  controller.updateData(
                    id: item['id'].toString(), // Kirim ID untuk pencocokan database
                    name: nameController.text,
                    subtitle: subController.text,
                    imageUrl: imgController.text,
                    price: priceController.text,
                    description: descController.text,
                  );
                },
                child: const Text("Perbarui Data", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
}


