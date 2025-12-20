import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/controller/home_controller.dart';
import 'package:healthy_scanner/view/home/home.dart';
import 'package:healthy_scanner/view/archive/archive_calendar.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/shutter_button.dart';

class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    const ArchiveCalendarView(),
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0 && Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.staticWhite,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.softGray,
                width: 1,
              ),
            ),
          ),
          child: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      label: '홈',
                      isHome: true,
                      selected: _selectedIndex == 0,
                      onTap: () => _onTabTapped(0),
                    ),
                  ),
                  const SizedBox(width: 100),
                  Expanded(
                    child: _NavItem(
                      label: '리포트',
                      isHome: false,
                      selected: _selectedIndex == 1,
                      onTap: () => _onTabTapped(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 98,
        height: 98,
        child: FloatingActionButton(
          onPressed: () => Get.find<NavigationController>().goToScanReady(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: const ShutterButton(size: 98),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/// 기존 _NavItem 그대로 복사
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.isHome,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool isHome;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.staticBlack : AppColors.stoneGray;
    final iconPath = isHome
        ? (selected
            ? 'assets/icons/ic_home_on.png'
            : 'assets/icons/ic_home_off.png')
        : (selected
            ? 'assets/icons/ic_report_on.png'
            : 'assets/icons/ic_report_off.png');

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(image: AssetImage(iconPath), width: 28, height: 28),
          const SizedBox(height: 4),
          Text(label, style: context.caption2Regular.copyWith(color: color)),
        ],
      ),
    );
  }
}
