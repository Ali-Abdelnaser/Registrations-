import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/presentation/screens/Add%20Member/add_member.dart';
import 'package:registration/presentation/screens/Data%20Management/data_management_screen.dart';
import 'package:registration/presentation/screens/Event%20Attend/AttendedScreen.dart';
import 'package:registration/presentation/screens/Event%20Management/DataManagementScreen.dart';
import 'package:registration/presentation/screens/Event%20Scan%20Screen/EventScanScreen.dart';
import 'package:registration/presentation/screens/Members%20Screen/MembersScreen.dart';
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
                  const SizedBox(height: 60),

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

                  // ✅ الجريد
                  RefreshIndicator(
                    onRefresh: () async =>
                        context.read<BranchMembersCubit>().loadBranchMembers(),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // علشان مايحصلش تعارض
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildGridItem(
                          context,
                          Icons.badge,
                          "Scan Membar Card",
                          const QRViewScreen(),
                        ),
                        _buildGridItem(
                          context,
                          Icons.event,
                          "Scan Event",
                          const EventScanScreen(),
                        ),
                        _buildGridItem(
                          context,
                          Icons.add_circle_outline,
                          "Add New Member",
                          AddMemberScreen(),
                        ),
                        _buildGridItem(
                          context,
                          Icons.cloud_upload_sharp,
                          "Update Member Data",
                          const MembersScreen(),
                        ),
                        _buildGridItem(
                          context,
                          Icons.event_repeat,
                          "Update Event Data",
                          const EventDataManagementScreen(),
                        ),
                        _buildGridItem(
                          context,
                          Icons.event_seat,
                          "Event Attendes",
                          const AttendedScreen(),
                        ),
                        _buildGridItem(
                          context,
                          Icons.manage_accounts_rounded,
                          "Data Management",
                          const DataManagementScreen(),
                        ),
                        _buildGridItem(
                          context,
                          Icons.info,
                          "About",
                          const Placeholder(),
                        ),
                      ],
                    ),
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
            Icon(icon, color: Colors.white, size: 60),
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
