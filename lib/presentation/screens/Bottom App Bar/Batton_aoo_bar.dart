import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/internet_cubit.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/presentation/screens/Home%20Page/home_page.dart';
import 'package:registration/presentation/screens/Skeleton%20Loader/home_skeleton.dart';
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
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, state) {
        if (state is InternetConnected) {
          // النت موجود → نعرض الـ BottomNavBar بتاعك
          return WillPopScope(
            onWillPop: () async {
              if (_currentIndex != 0) {
                setState(() => _currentIndex = 0);
                return false;
              }
              return true;
            },
            child: Scaffold(
              extendBody: true, // علشان البودي يدخل تحت الباتم بار
              backgroundColor: Colors.white,
              body: IndexedStack(index: _currentIndex, children: _pages),
              bottomNavigationBar: _buildBottomNav(),
            ),
          );
        } else if (state is InternetDisconnected) {
          // النت مش موجود → شاشة بديلة
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/img/no_internet.png",
                        height: 350,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Internet Connection",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<InternetCubit>().checkConnection();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.Blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // أول حالة (Initial / لسه بيشيك)
        return HomePageSkeleton();
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.Blue,
          style: BorderStyle.solid,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.Blue.withValues(alpha: 0.8),
            blurRadius: 10,
            // offset: const Offset(3, 3),
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
