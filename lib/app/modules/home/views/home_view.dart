import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loundry_app/app/core/services/detail_services.dart';
import 'package:loundry_app/app/modules/home/controllers/home_controller.dart';
import 'package:loundry_app/app/modules/laundry_map/bindings/laundry_map_binding.dart';
import 'package:loundry_app/app/modules/laundry_map/views/laundry_map_view.dart';
import 'package:loundry_app/app/modules/notification/controllers/notification_controller.dart';
import 'package:loundry_app/app/routes/app_pages.dart';
import '../../../core/services/theme_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final HomeController homeC = Get.find<HomeController>();
    final NotificationController notifController = Get.put(NotificationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: isDark
                ? Colors.grey[900]
                : Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
                        : [const Color(0xFF5B8DEF), const Color(0xFF4A7FE8)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hi, Welcome Back',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => const LaundryMapView(),
                                        binding: LaundryMapBinding(),
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.location_on_rounded,
                                            color: Colors.white70, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          'New York, USA',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Obx(() => _buildHeaderIconButton(
                                      icon: Icons.notifications_none_rounded,
                                      hasNotification: notifController.hasUnread,
                                      onTap: () {
                                        notifController.markAllAsRead();
                                        Get.toNamed(Routes.NOTIFICATION);
                                      },
                                      isDark: isDark,
                                    )),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    await ThemeService.switchTheme();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isDark
                                          ? Icons.nightlight_round
                                          : Icons.sunny,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDark ? 0.3 : 0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: isDark
                                    ? Colors.blue[300]
                                    : const Color(0xFF5B8DEF),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87),
                                  decoration: InputDecoration(
                                    hintText: 'Search service, provider...',
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.grey[500]
                                          : const Color(0xFFADB5BD),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.tune_rounded,
                                color: isDark
                                    ? Colors.blue[300]
                                    : const Color(0xFF5B8DEF),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Special Offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _promoImageCard(
                        image: 'assets/images/1.jpg',
                        badge: 'Weekend Deal',
                        title: 'Get Special Discount',
                        discount: '40% OFF',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      _promoImageCard(
                        image: 'assets/images/1.jpg',
                        badge: 'New Customer',
                        title: 'First Order Bonus',
                        discount: 'Free Delivery',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _ServiceItem(
                          imagePath: 'assets/home/washing-machine.png',
                          label: 'Washing',
                          isDark: isDark,
                          onTap: () => Get.to(() => const DetailServiceView(),
                              arguments: {
                                'name': 'Washing Service',
                                'image': 'assets/home/washing-machine.png',
                                'price': 'Rp 10.000 / kg'
                              }),
                        ),
                        _ServiceItem(
                          imagePath: 'assets/home/iron.png',
                          label: 'Ironing',
                          isDark: isDark,
                          onTap: () => Get.to(() => const DetailServiceView(),
                              arguments: {
                                'name': 'Ironing Only',
                                'image': 'assets/home/iron.png',
                                'price': 'Rp 7.000 / kg'
                              }),
                        ),
                        _ServiceItem(
                          imagePath: 'assets/home/dry-cleaning.png',
                          label: 'Dry Clean',
                          isDark: isDark,
                          onTap: () => Get.to(() => const DetailServiceView(),
                              arguments: {
                                'name': 'Dry Cleaning',
                                'image': 'assets/home/dry-cleaning.png',
                                'price': 'Rp 25.000 / pcs'
                              }),
                        ),
                        _ServiceItem(
                          imagePath: 'assets/home/power-washing.png',
                          label: 'Power Washing',
                          isDark: isDark,
                          onTap: () => Get.to(() => const DetailServiceView(),
                              arguments: {
                                'name': 'Power Washing',
                                'image': 'assets/home/power-washing.png',
                                'price': 'Rp 50.000 / pcs'
                              }),
                        ),
                        _ServiceItem(
                          imagePath: 'assets/home/shoe.png',
                          label: 'Shoe',
                          isDark: isDark,
                          onTap: () => Get.to(() => const DetailServiceView(),
                              arguments: {
                                'name': 'Shoe',
                                'image': 'assets/home/shoe.png',
                                'price': 'Rp 35.000 / pcs'
                              }),
                        ),
                        _ServiceItem(
                          imagePath: 'assets/home/sofa.png',
                          label: 'Sofa',
                          isDark: isDark,
                          onTap: () => Get.to(() => const DetailServiceView(),
                              arguments: {
                                'name': 'Sofa',
                                'image': 'assets/home/sofa.png',
                                'price': 'Rp 50.000 / pcs'
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _sectionTitle('Popular Services', isDark, onSeeAll: () {
                        Get.toNamed(Routes.EXPLORE);
                      }),
                      const SizedBox(height: 12),
                      Obx(() {
                        if (homeC.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Column(
                          children: homeC.popularServices.map((service) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => Get.toNamed(
                                    Routes.POPULAR_SERVICES_DETAIL,
                                    arguments: service),
                                child: _popularProvider(
                                    service: service, isDark: isDark),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required bool hasNotification,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          if (hasNotification)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5757),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black)),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text('See All',
              style: TextStyle(
                  color: Color(0xFF5B8DEF), fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _promoImageCard({
    required String image,
    required String badge,
    required String title,
    required String discount,
    required bool isDark,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(image, fit: BoxFit.cover, width: 280, height: 160),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(badge,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(discount,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popularProvider(
      {required Map<String, dynamic> service, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: service['image_url'] != null
                  ? DecorationImage(
                      image: NetworkImage(service['image_url']),
                      fit: BoxFit.cover)
                  : null,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: service['image_url'] == null
                ? const Icon(Icons.local_laundry_service, color: Colors.blue)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service['name'] ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87)),
                Text(service['price'] ?? '',
                    style: const TextStyle(
                        color: Color(0xFF5B8DEF), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _ServiceItem(
      {required this.imagePath,
      required this.label,
      required this.onTap,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isDark ? Colors.blue[900]!.withOpacity(0.2) : Colors.blue[50],
                borderRadius: BorderRadius.circular(12)),
            child: Image.asset(imagePath, width: 32, height: 32),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }
}