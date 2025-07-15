import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerSection extends StatelessWidget {
  final List<Map<String, String>> banners = [
    {
      'image': 'assets/images/flutter.png',
      'url': 'https://ziyaacademy.com/flutter-internship'
    },
    {
      'image': 'assets/images/python.webp',
      'url': 'https://ziyaacademy.com/python-internship'
    },
    // Add more banners as needed
  ];

  BannerSection({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: CarouselSlider.builder(
        slideBuilder: (index) {
          final banner = banners[index];
          return GestureDetector(
            onTap: () => _launchURL(banner['url']!),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                banner['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
        itemCount: banners.length,
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