import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/district_viewmodel.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/district_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/district_viewmodel.dart';

class DistrictDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final districtVM = Provider.of<DistrictViewModel>(context);
    const Color color = Colors.blueAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Choose District:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: districtVM.selectedDistrict.isEmpty
                      ? null
                      : districtVM.selectedDistrict,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: color),
                  dropdownColor: Colors.white,
                  hint: const Text(
                    'Select',
                    style: TextStyle(color: Colors.black54),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  items: districtVM.keralaDistricts.map((district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      districtVM.setDistrict(value);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BottomBannerSection extends StatelessWidget {
  final double imageHeight;
  BottomBannerSection({super.key, this.imageHeight = 150});

  final List<Map<String, String>> defaultBanners = [
    {'image': 'assets/images/vivo.png', 'url': 'https://www.vivo.com/'},
    {'image': 'assets/images/textile.jfif', 'url': 'https://www.textilevaluechain.in/'},
    {'image': 'assets/images/poco.webp', 'url': 'https://www.po.co/global/'},
    {'image': 'assets/images/textiles.jpg', 'url': 'https://www.textilevaluechain.in/'},
  ];

  final Map<String, List<Map<String, String>>> districtBanners = {
    'Alappuzha': [
      {'image': 'assets/images/textiles.jpg', 'url': 'https://www.textilevaluechain.in/'},
      {'image': 'assets/images/textile.jfif', 'url': 'https://www.textilevaluechain.in/'},
    ],
    'Kollam': [
      {'image': 'assets/images/vivo.png', 'url': 'https://www.vivo.com/'},
      {'image': 'assets/images/poco.webp', 'url': 'https://www.po.co/global/'},
    ],
  };

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final district = Provider.of<DistrictViewModel>(context).selectedDistrict;
    final banners = (districtBanners[district] != null && districtBanners[district]!.isNotEmpty)
        ? districtBanners[district]!
        : defaultBanners;

    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        DistrictDropdown(),
        const SizedBox(height: 8),
        SizedBox(
          width: width,
          height: imageHeight,
          child: CarouselSlider.builder(
            itemCount: banners.length,
            enableAutoSlider: true,
            unlimitedMode: true,
            viewportFraction: 0.9,
            slideTransform: const ParallaxTransform(),
            slideIndicator: CircularSlideIndicator(
              padding: const EdgeInsets.only(bottom: 12),
              indicatorBackgroundColor: Colors.grey.shade300,
              currentIndicatorColor: Colors.blueAccent,
            ),
            slideBuilder: (index) {
              final banner = banners[index];
              return GestureDetector(
                onTap: () => _launchURL(banner['url']!),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          banner['image']!,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              district.isEmpty ? 'Default' : district,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
