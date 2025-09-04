import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  Widget _skeletonBox({double height = 20, double width = double.infinity, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // العنوان
          _skeletonBox(height: 24, width: 200, radius: BorderRadius.circular(12)),
          const SizedBox(height: 16),

          // الحضور والغياب
          _skeletonBox(height: 20, width: 250, radius: BorderRadius.circular(12)),
          const SizedBox(height: 24),

          // الدايرة
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: screenWidth / 1.5,
              height: screenWidth / 1.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // زرار تحميل
          _skeletonBox(height: 50, width: double.infinity, radius: BorderRadius.circular(12)),
          const SizedBox(height: 20),

          // كروت الفرق (5 فرق)
          Column(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _skeletonBox(height: 70, width: double.infinity, radius: BorderRadius.circular(12)),
              );
            }),
          ),
        ],
      ),
    );
  }
}
