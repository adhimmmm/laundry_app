import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loundry_app/app/modules/explore/controllers/explore_controller.dart';
import 'package:loundry_app/app/modules/explore/views/explore_view.dart';
import 'package:loundry_app/app/modules/home/controllers/home_controller.dart';
import 'package:loundry_app/app/modules/order/views/order_view.dart';
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


    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(), permanent: true);
    }

    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController(), permanent: true);
    }
    if (!Get.isRegistered<ExploreController>()) {
      Get.put(ExploreController(), permanent: true);
    }
  }

  final pages = const [
    HomeView(),
    ExploreView(),
    // OrderView(),
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
