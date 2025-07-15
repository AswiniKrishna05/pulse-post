import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerSkeleton extends StatelessWidget {
  const HomeShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Banner shimmer
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            width: width,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Greeting card shimmer
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: width,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // Status card shimmer
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: width,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // Action buttons shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => 
                Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom carousel shimmer
          Container(
            margin: const EdgeInsets.all(16),
            width: width,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
} 