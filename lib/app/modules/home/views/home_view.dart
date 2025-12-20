import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loundry_app/app/core/services/detail_services.dart';
import 'package:loundry_app/app/modules/laundry_map/bindings/laundry_map_binding.dart';
import 'package:loundry_app/app/modules/laundry_map/views/laundry_map_view.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          /// ================= HEADER =================
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: isDark ? Colors.grey[900] : Theme.of(context).scaffoldBackgroundColor,
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
                        /// TOP BAR
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
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.white70,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'New York, USA',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _buildHeaderIconButton(
                                  icon: Icons.notifications_none_rounded,
                                  hasNotification: true,
                                  onTap: () => Get.toNamed(Routes.NOTIFICATION),
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 8),
                                _buildHeaderIconButton(
                                  icon: Icons.favorite_border_rounded,
                                  hasNotification: true,
                                  onTap: () {},
                                  isDark: isDark,
                                ),
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

                        /// SEARCH BAR
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search service, provider...',
                                    hintStyle: TextStyle(
                                      color: isDark ? Colors.grey[500] : const Color(0xFFADB5BD),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.tune_rounded,
                                color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
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

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// SPECIAL OFFERS WITH IMAGE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Special Offers', isDark),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

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
                      const SizedBox(width: 16),
                      _promoImageCard(
                        image: 'assets/images/1.jpg',
                        badge: 'Premium',
                        title: 'Professional Clean',
                        discount: '30% OFF',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// SERVICES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
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
                              onTap: () => Get.to(
                                () => const DetailServiceView(),
                                arguments: {
                                  'name': 'Washing Service',
                                  'image': 'assets/home/washing-machine.png',
                                  'price': 'Rp 10.000 / kg',
                                  'subtitle': 'Clean & Fresh',
                                  'description':
                                      'Layanan cuci menggunakan mesin otomatis modern dengan deterjen cair premium yang menjaga serat kain tetap awet.',
                                },
                              ),
                            ),
                            _ServiceItem(
                              imagePath: 'assets/home/iron.png',
                              label: 'Ironing',
                              isDark: isDark,
                              onTap: () => Get.to(
                                () => const DetailServiceView(),
                                arguments: {
                                  'name': 'Ironing Only',
                                  'image': 'assets/home/iron.png',
                                  'price': 'Rp 7.000 / kg',
                                  'subtitle': 'Smooth & Neat',
                                  'description':
                                      'Penyetrikaan rapi menggunakan setrika uap untuk memastikan semua lipatan hilang tanpa merusak bahan pakaian.',
                                },
                              ),
                            ),
                            _ServiceItem(
                              imagePath: 'assets/home/dry-cleaning.png',
                              label: 'Dry Clean',
                              isDark: isDark,
                              onTap: () => Get.to(
                                () => const DetailServiceView(),
                                arguments: {
                                  'name': 'Dry Cleaning',
                                  'image': 'assets/home/dry-cleaning.png',
                                  'price': 'Rp 25.000 / pcs',
                                  'subtitle': 'Special Treatment',
                                  'description':
                                      'Pencucian khusus untuk jas, kebaya, atau bahan sensitif lainnya tanpa menggunakan air (solvent based).',
                                },
                              ),
                            ),
                            _ServiceItem(
                              imagePath: 'assets/home/power-washing.png',
                              label: 'Carpet',
                              isDark: isDark,
                              onTap: () => Get.to(
                                () => const DetailServiceView(),
                                arguments: {
                                  'name': 'Carpet Cleaning',
                                  'image': 'assets/home/power-washing.png',
                                  'price': 'Rp 15.000 / m2',
                                  'subtitle': 'Deep Clean',
                                  'description':
                                      'Pembersihan karpet menyeluruh hingga ke sela-sela benang untuk menghilangkan debu dan tungau.',
                                },
                              ),
                            ),
                            _ServiceItem(
                              imagePath: 'assets/home/sofa.png',
                              label: 'Sofa',
                              isDark: isDark,
                              onTap: () => Get.to(
                                () => const DetailServiceView(),
                                arguments: {
                                  'name': 'Sofa Cleaning',
                                  'image': 'assets/home/sofa.png',
                                  'price': 'Rp 50.000 / seat',
                                  'subtitle': 'Hygienic Sofa',
                                  'description':
                                      'Cuci sofa di tempat menggunakan alat vakum khusus untuk hasil bersih dan kering dengan cepat.',
                                },
                              ),
                            ),
                            _ServiceItem(
                              imagePath: 'assets/home/dice.png',
                              label: 'Curtain',
                              isDark: isDark,
                              onTap: () => Get.to(
                                () => const DetailServiceView(),
                                arguments: {
                                  'name': 'Curtain Care',
                                  'image': 'assets/home/dice.png',
                                  'price': 'Rp 12.000 / kg',
                                  'subtitle': 'Dust Free',
                                  'description':
                                      'Cuci gorden tebal maupun tipis agar ruangan kembali segar dan bebas debu pemicu alergi.',
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// POPULAR PROVIDERS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Popular Services', isDark),
                      const SizedBox(height: 12),
                      _popularProvider(
                        name: 'Spotless Attire',
                        price: '1.8k',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _popularProvider(
                        name: 'Fresh & Clean Laundry',
                        price: '1.8k',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _popularProvider(
                        name: 'Perfect Press Service',
                        price: '1.2k',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= UI COMPONENTS =================

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
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
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

  Widget _sectionTitle(String title, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1D1F),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'See all',
            style: TextStyle(
              color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            /// BACKGROUND IMAGE
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  colorFilter: isDark 
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      )
                    : null,
                ),
              ),
            ),

            /// OVERLAY GRADIENT - Enhanced for better contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                    ? [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.85),
                      ]
                    : [
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.75),
                      ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            /// GLASSMORPHISM EFFECT (optional subtle overlay)
            if (isDark)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BADGE with enhanced styling
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF9F43),
                          const Color(0xFFFF6B35),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9F43).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  /// TITLE with shadow for better readability
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  /// DISCOUNT with glow effect
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark 
                        ? Colors.white.withOpacity(0.15)
                        : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      discount,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: isDark 
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// SHINE EFFECT (top right corner)
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(isDark ? 0.15 : 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popularProvider({
    required String name,
    required String price,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : const Color(0xFFF1F3F5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// AVATAR
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark 
                ? Colors.blue[900]!.withOpacity(0.3)
                : const Color(0xFF5B8DEF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_laundry_service_rounded,
              color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF1A1D1F),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Price:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[400] : const Color.fromARGB(255, 32, 33, 35),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[400] : const Color.fromARGB(255, 51, 54, 51),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ARROW
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark 
                ? Colors.blue[900]!.withOpacity(0.3)
                : const Color(0xFF5B8DEF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDark ? Colors.blue[300] : const Color(0xFF5B8DEF),
              size: 16,
            ),
          ),
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

  const _ServiceItem({
    required this.imagePath,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark 
                ? Colors.blue[900]!.withOpacity(0.3)
                : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                size: 40,
                color: isDark ? Colors.grey[600] : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}