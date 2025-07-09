import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../viewmodels/social_follow_viewmodel.dart';

class SocialCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final int index;
  final String buttonText;

  const SocialCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.index,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SocialFollowViewModel>(context);
    final followed = vm.followed[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top row: Icon + Title/SubTitle
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bottom row: Follow button + Confirm button
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.person, size: 16),
                  label: const Text('Follow'),
                  onPressed: followed
                      ? null
                      : () async {
                    final url = Uri.parse(vm.getReferralLink(index));
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch URL')),
                      );
                    }
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => vm.markFollowed(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: followed ? Colors.deepPurple : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(buttonText),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
