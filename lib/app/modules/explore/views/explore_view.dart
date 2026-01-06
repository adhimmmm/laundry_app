import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore Services', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A1D1F), letterSpacing: -0.5)),
                  const SizedBox(height: 20),
                  _searchBar(isDark),
                  const SizedBox(height: 16),
                  Obx(() => controller.recentSearches.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recent Searches', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 32,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.recentSearches.length,
                                itemBuilder: (_, i) => GestureDetector(
                                  onTap: () => controller.selectRecentSearch(controller.recentSearches[i]),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(color: const Color(0xFF5B8DEF).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                    child: Text(controller.recentSearches[i], style: const TextStyle(fontSize: 12)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        )
                      : const SizedBox.shrink()),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _filterChip('All', 'all', isDark),
                              const SizedBox(width: 8),
                              _filterChip('Washing', 'washing', isDark),
                              const SizedBox(width: 8),
                              _filterChip('Ironing', 'ironing', isDark),
                              const SizedBox(width: 8),
                              _filterChip('Dry Clean', 'dry clean', isDark),
                              const SizedBox(width: 8),
                              _filterChip('Carpet', 'carpet', isDark),
                              const SizedBox(width: 8),
                              _filterChip('Shoe', 'shoe', isDark),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showFilterOverlay(context, isDark),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFF5B8DEF).withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF5B8DEF).withOpacity(0.3))),
                          child: const Icon(Icons.filter_list, color: Color(0xFF5B8DEF), size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => controller.clearAllFilters(),
                    child: Text('Clear All', style: TextStyle(fontSize: 12, color: const Color(0xFF5B8DEF), decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF5B8DEF)));
                if (controller.services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: const Color(0xFF5B8DEF).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFF5B8DEF))),
                        const SizedBox(height: 20),
                        Text('No Services Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A1D1F))),
                        const SizedBox(height: 8),
                        Text('Try adjusting your search or filter', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: controller.services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85),
                  itemBuilder: (_, i) => _serviceCard(controller.services[i], isDark),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(bool isDark) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E9EB)),
      ),
      child: TextField(
        onChanged: (value) => controller.searchServices(value),
        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D1F)),
        decoration: InputDecoration(
          hintText: 'Search services...',
          hintStyle: TextStyle(color: isDark ? Colors.grey[500] : const Color(0xFF9CA3AF), fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF5B8DEF), size: 22),
          suffixIcon: PopupMenuButton<String>(
            onSelected: (value) => controller.sortServices(value),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              const PopupMenuItem(value: 'price_asc', child: Text('Price: Low to High')),
              const PopupMenuItem(value: 'price_desc', child: Text('Price: High to Low')),
            ],
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF5B8DEF).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.tune_rounded, color: Color(0xFF5B8DEF), size: 20),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == value;
      return GestureDetector(
        onTap: () => controller.filterByCategory(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5B8DEF) : isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFF5B8DEF) : isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E9EB)),
          ),
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : isDark ? Colors.grey[300] : const Color(0xFF6C757D), fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, fontSize: 14)),
        ),
      );
    });
  }

  Widget _serviceCard(Map<String, dynamic> item, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed('/popular-services-detail', arguments: item),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF1F3F5)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  item['image_url'] ?? '',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFF5B8DEF).withOpacity(0.1), child: const Icon(Icons.local_laundry_service_rounded, size: 48, color: Color(0xFF5B8DEF))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] ?? '-', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : const Color(0xFF1A1D1F))),
                  const SizedBox(height: 8),
                  Text(item['price'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5B8DEF))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOverlay(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Advanced Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A1D1F))),
                GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close, color: isDark ? Colors.white : const Color(0xFF1A1D1F))),
              ],
            ),
            const SizedBox(height: 20),
            Text('Service Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1A1D1F))),
            const SizedBox(height: 12),
            ..._buildFilterOptions(['washing', 'ironing', 'dry clean', 'carpet', 'shoe'], isDark),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.selectedFilters.clear();
                      controller.applyFilters();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF5B8DEF)), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Reset', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF5B8DEF), fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFF5B8DEF), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Apply', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFilterOptions(List<String> categories, bool isDark) {
    return categories.map((cat) {
      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              controller.toggleMultiFilter(cat);
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF5B8DEF)),
                      borderRadius: BorderRadius.circular(4),
                      color: controller.selectedFilters.contains(cat) ? const Color(0xFF5B8DEF) : Colors.transparent,
                    ),
                    child: controller.selectedFilters.contains(cat) ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 12),
                  Text(cat.toUpperCase(), style: TextStyle(fontSize: 14, color: isDark ? Colors.white : const Color(0xFF1A1D1F))),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }
}