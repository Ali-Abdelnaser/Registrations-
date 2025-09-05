import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ الخلفية الرمادي
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[200],
        ),

        // ✅ المحتوى الوهمي
        SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // 📝 عنوان وهمي
                    Container(height: 20, width: 220, color: Colors.white),
                    const SizedBox(height: 12),

                    Container(height: 16, width: 280, color: Colors.white),
                    const SizedBox(height: 20),

                    // ✅ الجريد الوهمي
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: List.generate(6, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 14,
                                width: 80,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
