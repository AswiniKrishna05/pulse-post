import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class GreetingCard extends StatelessWidget {
  final String userName;
  const GreetingCard({super.key, required this.userName});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppStrings.goodMorning;
    } else if (hour < 17) {
      return AppStrings.goodAfternoon;
    } else {
      return AppStrings.goodEvening;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '${getGreeting()}, \n$userName!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
