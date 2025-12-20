import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;
  var popularServices = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
  try {
    isLoading(true);
    final data = await supabase
        .from('laundry_services')
        .select()
        .order('created_at', ascending: false)
        .limit(5);
    popularServices.assignAll(data);
  } catch (e) {
    print("Error fetching popular services: $e");
  } finally {
    isLoading(false);
  }
}

}
