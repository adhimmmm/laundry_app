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
      // Mengambil data dari tabel laundry_services
      final data = await supabase
          .from('laundry_services')
          .select()
          .limit(5); // Ambil 5 data teratas sebagai "Popular"
      
      popularServices.assignAll(data);
    } catch (e) {
      print("Error fetching popular services: $e");
    } finally {
      isLoading(false);
    }
  }

}
