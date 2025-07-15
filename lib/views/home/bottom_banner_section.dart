import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/district_viewmodel.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class DistrictDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final districtVM = Provider.of<DistrictViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DropdownButton<String>(
        value: districtVM.selectedDistrict,
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
    );
  }
}

class BottomBannerSection extends StatelessWidget {
  final double imageHeight;
  BottomBannerSection({super.key, this.imageHeight = 200});

  // Default banners (shown before district selection or if no banners for district)
  final List<Map<String, String>> defaultBanners = [
    {'image': 'assets/images/vivo.png', 'url': 'https://www.vivo.com/'},
    {'image': 'assets/images/textile.jfif', 'url': 'https://www.textilevaluechain.in/'},
    {'image': 'assets/images/poco.webp', 'url': 'https://www.po.co/global/'},
    {'image': 'assets/images/textiles.jpg', 'url': 'https://www.textilevaluechain.in/'},
  ];

  // Map of banners for each district
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
    // If the selected district has banners, show them; otherwise show default banners
    final banners = (districtBanners[district] != null && districtBanners[district]!.isNotEmpty)
        ? districtBanners[district]!
        : defaultBanners;

    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        DistrictDropdown(), // Dropdown above the carousel
        SizedBox(
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
        ),
      ],
    );
  }
}