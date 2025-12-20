import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/popular_services_detail_controller.dart';

class PopularServicesDetailView extends GetView<PopularServicesDetailController> {
  const PopularServicesDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> service = Get.arguments as Map<String, dynamic>;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          /// ================= HEADER WITH IMAGE =================
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark 
                  ? Colors.black.withOpacity(0.5) 
                  : Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : Colors.black87,
                  size: 18,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark 
                    ? Colors.black.withOpacity(0.5) 
                    : Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  /// SERVICE IMAGE
                  service['image_url'] != null && service['image_url'].toString().isNotEmpty
                    ? Image.network(
                        service['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(isDark),
                      )
                    : _buildPlaceholderImage(isDark),
                  
                  /// GRADIENT OVERLAY
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          isDark 
                            ? Colors.grey[900]!.withOpacity(0.9)
                            : Colors.grey[50]!.withOpacity(0.9),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                /// SERVICE INFO CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// SERVICE NAME
                      Text(
                        service['name'] ?? 'Service Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      /// SUBTITLE
                      if (service['subtile'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                service['subtile'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                      
                      /// PRICE SECTION
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                            ? Colors.blue[900]!.withOpacity(0.3)
                            : const Color(0xFF5B8DEF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark 
                              ? Colors.blue[800]!.withOpacity(0.5)
                              : const Color(0xFF5B8DEF).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Starting From',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rp ',
                                  style: TextStyle(
                                    color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  service['price']?.toString() ?? '0',
                                  style: TextStyle(
                                    color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// DESCRIPTION SECTION
                if (service['description'] != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'About Service',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          service['description'],
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      /// ================= BOTTOM BOOKING BAR =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              /// INFO BUTTON
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isDark 
                    ? Colors.grey[800]
                    : Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                    size: 22,
                  ),
                  onPressed: () {
                    Get.snackbar(
                      'Service Info',
                      'Contact us for more details',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                      colorText: isDark ? Colors.white : Colors.black87,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              /// BOOK NOW BUTTON
              Expanded(
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B8DEF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Get.snackbar(
                          'Success',
                          'Booking feature coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                        );
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Book Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= HELPER WIDGETS =================

  Widget _buildPlaceholderImage(bool isDark) {
    return Container(
      color: isDark ? Colors.grey[800] : Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.local_laundry_service_rounded,
          size: 64,
          color: isDark ? Colors.grey[600] : Colors.grey[400],
        ),
      ),
    );
  }
}