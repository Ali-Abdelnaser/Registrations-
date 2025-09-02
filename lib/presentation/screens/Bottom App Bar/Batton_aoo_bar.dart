import 'package:flutter/material.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/presentation/screens/Home%20Page/home_page.dart';
import 'package:registration/presentation/screens/attendees/scanned_participants_screen.dart';
import 'package:registration/presentation/screens/dashboard/dashboard_screen.dart';

class ModernBottomNav extends StatefulWidget {
  const ModernBottomNav({super.key, this.userData});
  final Map<String, dynamic>? userData;

  @override
  State<ModernBottomNav> createState() => _ModernBottomNavState();
}

class _ModernBottomNavState extends State<ModernBottomNav> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomePage(key: const PageStorageKey("HomePage")),
      ScannedParticipantsScreen(key: const PageStorageKey("Scanned")),
      DashboardScreen(key: const PageStorageKey("Dashboard")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true, // مهم علشان البودي يدخل تحت الباتم بار
        backgroundColor: Colors.white, // خليه أبيض مش شفاف
        body: IndexedStack(index: _currentIndex, children: _pages),

        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0, "Home"),
            _buildNavItem(Icons.people, 1, "Attendees"),
            _buildNavItem(Icons.dashboard, 2, "Dashboard"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSelected ? 28 : 24,
            color: isSelected ? AppColors.Blue : Colors.grey,
          ),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                color: AppColors.Blue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
