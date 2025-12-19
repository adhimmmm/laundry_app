import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loundry_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:loundry_app/app/modules/profile/views/profile_view.dart';
import '../../home/views/home_view.dart';
import '../../../core/widgets/app_bottom_nav.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    /// ✅ REGISTER CONTROLLER SEKALI
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(), permanent: true);
    }
  }

  final pages = const [
    HomeView(),
    Center(child: Text('Explore')),
    Center(child: Text('Orders')),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
