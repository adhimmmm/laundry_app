import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var services = <Map<String, dynamic>>[].obs;
  var allServices = <Map<String, dynamic>>[]; 
  var searchQuery = ''.obs;
  var sortBy = 'name'.obs;
  var selectedFilter = 'all'.obs;
  var selectedFilters = <String>[].obs;
  var recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading(true);
      final data = await supabase.from('laundry_services').select().order('created_at', ascending: false);
      allServices = List<Map<String, dynamic>>.from(data);
      services.assignAll(allServices);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchServices(String query) async {
    try {
      searchQuery.value = query;
      if (query.isNotEmpty && !recentSearches.contains(query)) {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) recentSearches.removeLast();
      }
      applyFilters();
    } catch (e) {
      Get.snackbar('Search Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void filterByCategory(String category) {
    selectedFilter.value = category.toLowerCase();
    applyFilters();
  }

  void toggleMultiFilter(String category) {
    final cat = category.toLowerCase();
    if (selectedFilters.contains(cat)) {
      selectedFilters.remove(cat);
    } else {
      selectedFilters.add(cat);
    }
  }

  void sortServices(String sortType) {
    sortBy.value = sortType;
    applyFilters();
  }

  void applyFilters() {
    List<Map<String, dynamic>> result = List.from(allServices);

    if (selectedFilter.value != 'all') {
      result = result.where((service) {
        final cat = (service['category'] ?? '').toString().trim().toLowerCase();
        return cat == selectedFilter.value;
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      result = result.where((service) {
        final cat = (service['category'] ?? '').toString().trim().toLowerCase();
        return selectedFilters.contains(cat);
      }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final searchLower = searchQuery.value.toLowerCase();
      result = result.where((service) {
        final name = service['name']?.toString().toLowerCase() ?? '';
        final subtitle = service['subtitle']?.toString().toLowerCase() ?? '';
        return name.contains(searchLower) || subtitle.contains(searchLower);
      }).toList();
    }

    if (sortBy.value == 'name') {
      result.sort((a, b) => (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()));
    } else if (sortBy.value == 'price_asc') {
      result.sort((a, b) {
        final priceA = double.tryParse((a['price'] ?? '0').toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
        final priceB = double.tryParse((b['price'] ?? '0').toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (sortBy.value == 'price_desc') {
      result.sort((a, b) {
        final priceA = double.tryParse((a['price'] ?? '0').toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
        final priceB = double.tryParse((b['price'] ?? '0').toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
        return priceB.compareTo(priceA);
      });
    }

    services.assignAll(result);
  }

  void selectRecentSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void clearAllFilters() {
    searchQuery.value = '';
    selectedFilter.value = 'all';
    selectedFilters.clear();
    sortBy.value = 'name';
    applyFilters();
  }

  Future<void> refreshServices() => fetchServices();
  void clearSearch() {
    searchQuery.value = '';
    applyFilters();
  }
}