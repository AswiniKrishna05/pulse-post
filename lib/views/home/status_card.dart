import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class StatusCard extends StatelessWidget {
  final int balance;
  final int credits;
  final int tasksCompleted;

  const StatusCard({
    super.key,
    required this.balance,
    required this.credits,
    required this.tasksCompleted,
  });

  @override
  Widget build(BuildContext context) {
    const Color color = Colors.blueAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusItem(AppStrings.validBalance, balance, color),
            _buildStatusItem(AppStrings.totalCredits, credits, color),
            _buildStatusItem(AppStrings.taskCompleted, tasksCompleted, color),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
