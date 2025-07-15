import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBannerSection extends StatelessWidget {
  final List<Map<String, String>> banners = [
    {
      'image': 'assets/images/vivo.png',
      'url': 'https://www.vivo.com/'
    },
    {
      'image': 'assets/images/poco.webp',
      'url': 'https://www.po.co/global/'
    },
    // Add more banners as needed
  ];

  final double imageHeight;

  BottomBannerSection({super.key, this.imageHeight = 200});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: imageHeight,
      child: CarouselSlider.builder(
        slideBuilder: (index) {
          final banner = banners[index];
          return GestureDetector(
            onTap: () => _launchURL(banner['url']!),
            child: Image.asset(
              banner['image']!,
              fit: BoxFit.contain,
              width: width,
              height: imageHeight,
            ),
          );
        },
        itemCount: banners.length,
        enableAutoSlider: true,
        unlimitedMode: true,
        slideTransform: CubeTransform(),
        slideIndicator: CircularSlideIndicator(
          padding: EdgeInsets.only(bottom: 8),
        ),
        viewportFraction: 1.0,
      ),
    );
  }
} 