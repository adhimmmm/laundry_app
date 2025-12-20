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
    return Scaffold(
      extendBodyBehindAppBar: true,

      /// ===== BODY =====
      body: CustomScrollView(
        slivers: [
          /// ================= HEADER =================
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF5B8DEF),
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
                            Column(
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
                                    children: const [
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
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Get.toNamed(Routes.NOTIFICATION);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
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
                            ),
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
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
                            GestureDetector(
                              onTap: () async {
                                await ThemeService.switchTheme();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.12)
                                      : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Get.isDarkMode
                                      ? Icons.nightlight_round
                                      : Icons.sunny,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        /// SEARCH BAR
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.search_rounded,
                                color: Color(0xFF5B8DEF),
                                size: 22,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search service, provider...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFADB5BD),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.tune_rounded,
                                color: Color(0xFF5B8DEF),
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
                      _sectionTitle('Special Offers'),
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
                      ),
                      const SizedBox(width: 16),
                      _promoImageCard(
                        image: 'assets/images/1.jpg',
                        badge: 'New Customer',
                        title: 'First Order Bonus',
                        discount: 'Free Delivery',
                      ),
                      const SizedBox(width: 16),
                      _promoImageCard(
                        image: 'assets/images/1.jpg',
                        badge: 'Premium',
                        title: 'Professional Clean',
                        discount: '30% OFF',
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
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
                              imagePath:
                                  'assets/home/dice.png', // Ganti jika ada icon curtain
                              label: 'Curtain',
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
                      _sectionTitle('Popular Services'),
                      const SizedBox(height: 12),
                      _popularProvider(name: 'Spotless Attire', price: '1.8k'),
                      const SizedBox(height: 12),
                      _popularProvider(
                        name: 'Fresh & Clean Laundry',
                        price: '1.8k',
                      ),
                      const SizedBox(height: 12),
                      _popularProvider(
                        name: 'Perfect Press Service',
                        price: '1.2k',
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

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1D1F),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'See all',
            style: TextStyle(
              color: Color(0xFF5B8DEF),
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
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
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
                ),
              ),
            ),

            /// OVERLAY GRADIENT
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F43),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    discount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popularProvider({required String name, required String price}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1),
      ),
      child: Row(
        children: [
          /// AVATAR
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF5B8DEF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_laundry_service_rounded,
              color: Color(0xFF5B8DEF),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1A1D1F),
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
                        color: Color.fromARGB(255, 32, 33, 35),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 51, 54, 51),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),

          /// ARROW
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF5B8DEF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF5B8DEF),
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
  final VoidCallback onTap; // Tambahkan parameter onTap

  const _ServiceItem({
    required this.imagePath,
    required this.label,
    required this.onTap, // Wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Menjalankan fungsi saat diklik
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: 40,
              height: 40,
              // Jika gambar tidak ada, tampilkan icon default agar tidak merah (error)
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
