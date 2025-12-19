import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            /// ================= PAGE VIEW =================
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                _page(
                  image: 'assets/images/4.png',
                  titleBlue: 'Laundry',
                  titleBlack: ' Services',
                  subtitle: 'Find the best laundry services near you easily',
                ),
                _page(
                  image: 'assets/images/2.png',
                  titleBlack: 'Explore ',
                  titleBlue: 'Services',
                  subtitle: 'Explore laundry services by interactive map',
                ),
                _page(
                  image: 'assets/images/3.png',
                  titleBlue: 'Create ',
                  titleBlack: 'Account',
                  subtitle: 'Start your laundry journey now',
                ),
              ],
            ),

            /// ================= SKIP BUTTON =================
            Obx(() {
              if (controller.currentPage.value == 2) {
                return const SizedBox();
              }
              return Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: () {
                    //registes
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF5B8DEF),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),

            /// ================= BOTTOM NAV =================
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: _bottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= ONBOARDING PAGE =================
  Widget _page({
    required String image,
    String titleBlack = '',
    String titleBlue = '',
    required String subtitle,
  }) {
    return Stack(
      children: [
        /// IMAGE
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            image,
            height: 500,
            fit: BoxFit.cover,
          ),
        ),

        /// WHITE CONTAINER
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 350,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 100),
            child: Column(
              children: [
                /// TITLE
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: titleBlack,
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: titleBlue,
                        style: const TextStyle(color: Color(0xFF5B8DEF)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// SUBTITLE
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ================= BOTTOM NAVIGATION =================
  Widget _bottomNavigation() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// BACK BUTTON
            _circleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () {
                if (controller.currentPage.value > 0) {
                  controller.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),

            /// INDICATOR
            Row(
              children: List.generate(3, (index) {
                final isActive = controller.currentPage.value == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF5B8DEF)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            /// NEXT BUTTON
            _circleButton(
              icon: Icons.arrow_forward_ios_rounded,
              isPrimary: true,
              onTap: () {
                if (controller.currentPage.value == 2) {
                  //login
                } else {
                  controller.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= CIRCLE BUTTON =================
  Widget _circleButton({
    required IconData icon,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF5B8DEF) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isPrimary
                ? const Color(0xFF5B8DEF)
                : const Color(0xFFE0E0E0),
          ),
          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: const Color(0xFF5B8DEF).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : const Color(0xFF5B8DEF),
          size: 20,
        ),
      ),
    );
  }
}
