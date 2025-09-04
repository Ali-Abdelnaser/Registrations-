import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ScannedParticipantsSkeleton extends StatelessWidget {
  const ScannedParticipantsSkeleton({super.key});

  Widget _block({
    double height = 16,
    double width = double.infinity,
    BorderRadius? radius,
    BoxShape? shape,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: shape == BoxShape.circle
              ? null
              : (radius ?? BorderRadius.circular(12)),
          shape: shape ?? BoxShape.rectangle,
        ),
      ),
    );
  }

  Widget _listTileSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _block(height: 42, width: 42, shape: BoxShape.circle),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _block(height: 14, width: double.infinity),
                const SizedBox(height: 8),
                _block(height: 12, width: 140),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _block(height: 28, width: 28, radius: BorderRadius.circular(8)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // شريط البحث
              _block(height: 48, radius: BorderRadius.circular(30)),
              const SizedBox(height: 16),
              // ليست عناصر سكيلتون
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, __) => _listTileSkeleton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
