import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DataManagementSkeleton extends StatelessWidget {
  const DataManagementSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // ✅ صورة Placeholder
          _buildShimmerBox(height: 200, width: double.infinity, radius: 16),
          const SizedBox(height: 40),

          // ✅ زرارين Placeholder
          Row(
            children: [
              Expanded(
                child: _buildShimmerBox(height: 120, radius: 16),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildShimmerBox(height: 120, radius: 16),
              ),
            ],
          ),

          // ✅ Container Placeholder
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 30),
            child: _buildShimmerBox(height: 100, radius: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    double? height,
    double? width,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
