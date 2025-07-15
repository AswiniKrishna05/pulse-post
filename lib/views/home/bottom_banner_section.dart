import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class BottomBannerSection extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/vivo.png',
    'assets/images/poco.webp',
    // Add more images as needed
  ];

  final double imageHeight;

  BottomBannerSection({super.key, this.imageHeight = 120});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: imageHeight,
        child: CarouselSlider.builder(
          slideBuilder: (index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: imageHeight,
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
          viewportFraction: 1.0,
        ),
      ),
    );
  }
} 