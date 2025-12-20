import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var services = <Map<String, dynamic>>[].obs;
  var allServices = <Map<String, dynamic>>[]; // Store original data
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  /// Fetch all services from Supabase
  Future<void> fetchServices() async {
    try {
      isLoading(true);
      final data = await supabase
          .from('laundry_services')
          .select()
          .order('created_at', ascending: false);

      // Store original data
      allServices = List<Map<String, dynamic>>.from(data);
      
      // Display all services initially
      services.assignAll(allServices);
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

  /// Search services by name
  Future<void> searchServices(String query) async {
    try {
      searchQuery.value = query;
      
      if (query.isEmpty) {
        // Show all services when search is empty
        services.assignAll(allServices);
      } else {
        // Filter services based on search query
        final filteredServices = allServices.where((service) {
          final name = service['name']?.toString().toLowerCase() ?? '';
          final subtitle = service['subtitle']?.toString().toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          
          // Search in both name and subtitle
          return name.contains(searchLower) || subtitle.contains(searchLower);
        }).toList();
        
        services.assignAll(filteredServices);
      }
    } catch (e) {
      Get.snackbar(
        'Search Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void filterByCategory(String category) {
  try {
    final selected = category.trim().toLowerCase();

    if (selected.isEmpty || selected == 'all') {
      services.assignAll(allServices);
    } else {
      services.assignAll(
        allServices.where((service) {
          final serviceCategory =
              (service['category'] ?? '').toString().trim().toLowerCase();
          return serviceCategory == selected;
        }).toList(),
      );
    }

    searchQuery.value = '';
  } catch (e) {
    Get.snackbar(
      'Filter Error',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


  /// Refresh services
  Future<void> refreshServices() async {
    await fetchServices();
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
    services.assignAll(allServices);
  }
}