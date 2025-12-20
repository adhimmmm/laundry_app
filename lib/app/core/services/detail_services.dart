import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailServiceView extends StatelessWidget {
  const DetailServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Header Pro dengan Parallax & Custom Back Button
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false, // Mematikan tombol bawaan
            leadingWidth: 80,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Putih melingkar di tombol back
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ),
            backgroundColor: const Color(0xFF5B8DEF),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: data['name'] ?? 'service',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(data['image']),
                    // Overlay Gradasi
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black26,
                            Colors.transparent,
                            Colors.black45,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Konten Detail Utama
          SliverToBoxAdapter(
            child: Container(
              // Menambah jarak angkat ke atas agar border radius terlihat jelas di atas gambar
              transform: Matrix4.translationValues(0, -40, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    40,
                  ), // Border radius kiri atas lebih besar
                  topRight: Radius.circular(
                    40,
                  ), // Border radius kanan atas lebih besar
                ),
                // Menambahkan sedikit bayangan halus agar transisi dari gambar ke putih lebih smooth
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                24,
                40,
                24,
                100,
              ), // Padding atas diperbesar jadi 40
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- KOTAK IDENTITAS (Dengan Jarak/Margin Bawah) ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      24,
                    ), // Padding dalam diperbesar agar lebih lega
                    margin: const EdgeInsets.only(
                      bottom: 24,
                    ), // JARAK antar kotak identitas ke konten bawah
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data['name'] ?? 'Service Name',
                                style: const TextStyle(
                                  fontSize:
                                      26, // Ukuran font sedikit diperbesar
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.7,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF5B8DEF,
                                ).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text(
                                "Active",
                                style: TextStyle(
                                  color: Color(0xFF5B8DEF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ), // Jarak antar teks diperlebar
                        Text(
                          data['subtitle'] ?? 'Premium Quality Service',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- INFO CARDS (Harga & Estimasi) ---
                  // Anda bisa memberikan jarak lagi di sini jika dirasa kurang
                  Row(
                    children: [
                      _buildInfoTile(
                        Icons.payments_outlined,
                        "Price",
                        data['price'] ?? 'Free',
                      ),
                      const SizedBox(width: 16),
                      _buildInfoTile(
                        Icons.timer_outlined,
                        "Estimate",
                        "2-3 Days",
                      ),
                    ],
                  ),

                  const SizedBox(height: 35), // Jarak ke deskripsi diperlebar
                  // --- DESKRIPSI SECTION ---
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 15),
                    child: Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      data['description'] ?? 'No description provided.',
                      style: TextStyle(
                        fontSize: 15,
                        height:
                            1.7, // Line height diperlebar agar nyaman dibaca
                        color: Colors.grey[700],
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Tombol Booking Pro
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B8DEF),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Get.snackbar(
                "Booking Info",
                "Berhasil memilih ${data['name']}",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.white.withOpacity(0.9),
                margin: const EdgeInsets.all(15),
                borderRadius: 15,
                boxShadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              );
            },
            child: const Text(
              "Book Service Now",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Widget pendukung untuk Price & Estimate
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF5B8DEF), size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 80, color: Colors.grey),
      );
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.cover);
    }
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image),
      ),
    );
  }
}
