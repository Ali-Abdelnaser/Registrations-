import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:registration/presentation/screens/Add%20Member/add_member.dart';
import 'package:registration/presentation/screens/Skeleton%20Loader/home_skeleton.dart';
import 'package:registration/presentation/screens/scan/qr_scan.dart';
import 'package:registration/presentation/widgets/navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ الخلفية
        Image.asset('assets/img/home.jpg', fit: BoxFit.cover),

        // ✅ البلور
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(color: Colors.black54.withValues(alpha: 0.4)),
        ),

        // ✅ المحتوى Scrollable + في النص
        SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    'Welcome Registration Team',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Let\'s scan, verify & organize participants ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(200, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ الجريد
                  GridView.count(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // علشان مايحصلش تعارض
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildGridItem(
                        context,
                        Icons.qr_code_scanner,
                        "Scan QR",
                        const QRViewScreen(),
                      ),
                      _buildGridItem(
                        context,
                        Icons.add_circle_outline,
                        "Add New Member",
                        AddMemberScreen(),
                      ),
                      _buildGridItem(
                        context,
                        Icons.settings,
                        "Settings",
                        const HomePageSkeleton(),
                      ),
                      _buildGridItem(
                        context,
                        Icons.info,
                        "About",
                        const Placeholder(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ مكون لكل Item في الجريد
  Widget _buildGridItem(
    BuildContext context,
    IconData icon,
    String label,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        AppNavigator.fade(context, screen, replace: false);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
