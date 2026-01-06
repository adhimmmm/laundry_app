import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboradView extends GetView<AdminDashboradController> {
  const AdminDashboradView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
              Tab(icon: Icon(Icons.list), text: 'Data List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _dashboardTab(context),
            _dataListTab(context),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TAB 1 : DASHBOARD
  // =====================================================

  Widget _dashboardTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _overviewCards(isDark),
            const SizedBox(height: 20),
            _categoryChart(isDark),
            const SizedBox(height: 20),
            _recentServices(isDark),
          ],
        ),
      );
    });
  }

  Widget _overviewCards(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            _statCard(
              'Total Services',
              controller.totalServices.toString(),
              Icons.shopping_bag,
              Colors.blue,
              isDark,
            ),
            _statCard(
              'Avg Price',
              'Rp ${controller.averagePrice.toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.orange,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(title),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CATEGORY CHART
  // =====================================================

  Widget _categoryChart(bool isDark) {
    final data = controller.categoryDistribution;
    final maxValue =
        data.values.isEmpty ? 1 : data.values.reduce(math.max).toDouble();

    return _card(
      isDark,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service by Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...data.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key),
                      Text('${e.value}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: e.value / maxValue,
                    minHeight: 12,
                    valueColor: AlwaysStoppedAnimation(
                      _categoryColor(e.key),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // =====================================================
  // RECENT SERVICES
  // =====================================================

  Widget _recentServices(bool isDark) {
    return _card(
      isDark,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Services',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...controller.recentServices.map((item) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  item['image_url'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image),
                ),
              ),
              title: Text(item['name']),
              subtitle: Text(item['category']),
              trailing: Text('Rp ${item['price']}'),
            );
          }),
        ],
      ),
    );
  }

  // =====================================================
  // TAB 2 : DATA LIST + CRUD
  // =====================================================

  Widget _dataListTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.listData.isEmpty) {
        return const Center(child: Text('Tidak ada data'));
      }

      return Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: controller.listData.length,
            itemBuilder: (context, index) {
              final item = controller.listData[index];

              return Card(
                child: ListTile(
                  leading: Image.network(
                    item['image_url'] ?? '',
                    width: 50,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(item['subtitle']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _showEditForm(context, item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            controller.deleteData(item['id'].toString()),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () => _showCreateForm(context),
              child: const Text('Tambah Service'),
            ),
          ),
        ],
      );
    });
  }

  // =====================================================
  // FORM CREATE & EDIT
  // =====================================================

  void _showCreateForm(BuildContext context) {
    _openForm(context);
  }

  void _showEditForm(BuildContext context, Map item) {
    _openForm(context, item: item);
  }

  void _openForm(BuildContext context, {Map? item}) {
    final name = TextEditingController(text: item?['name']);
    final sub = TextEditingController(text: item?['subtitle']);
    final price =
        TextEditingController(text: item?['price']?.toString());
    final desc = TextEditingController(text: item?['description']);

    controller.selectedCategory.value = item?['category'] ?? '';
    controller.imagePath.value = '';

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _textField(name, 'Nama'),
              _textField(sub, 'Subtitle'),
              _textField(price, 'Harga', isNumber: true),
              _textField(desc, 'Deskripsi', maxLines: 3),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  items: controller.categories
                      .where((e) => e != 'All')
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (v) =>
                      controller.selectedCategory.value = v ?? '',
                  decoration:
                      const InputDecoration(labelText: 'Kategori'),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (item == null) {
                    controller.createData(
                      name: name.text,
                      subtitle: sub.text,
                      price: price.text,
                      description: desc.text,
                    );
                  } else {
                    controller.updateData(
                      id: item['id'].toString(),
                      name: name.text,
                      subtitle: sub.text,
                      price: price.text,
                      description: desc.text,
                      oldImageUrl: item['image_url'],
                    );
                  }
                },
                child: Text(item == null ? 'Simpan' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController c,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _card(bool isDark, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Washing':
        return Colors.blue;
      case 'Ironing':
        return Colors.orange;
      case 'Dry Clean':
        return Colors.purple;
      case 'Carpet':
        return Colors.green;
      case 'Shoe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// =====================================================
// PIE CHART PAINTER
// =====================================================

class PieChartPainter extends CustomPainter {
  final Map<String, int> data;

  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0, (a, b) => a + b);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = -math.pi / 2;

    data.forEach((key, value) {
      final sweep = value / total * 2 * math.pi;
      final paint = Paint()
        ..color =
            Colors.primaries[key.hashCode % Colors.primaries.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        paint,
      );
      startAngle += sweep;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
