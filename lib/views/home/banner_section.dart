import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class BannerSection extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/ziyalogo.jpeg',
    'assets/images/pulse_logo.jpeg',
    // Add more images if needed
  ];

  BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: CarouselSlider.builder(
        slideBuilder: (index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        },
        itemCount: imagePaths.length,
        enableAutoSlider: true,
        unlimitedMode: true,
        slideTransform: const DefaultTransform(),
        slideIndicator: CircularSlideIndicator(
          padding: EdgeInsets.only(bottom: 8),
        ),
        viewportFraction: 0.9,
      ),
    );
  }
} 