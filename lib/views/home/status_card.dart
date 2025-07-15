import 'package:flutter/material.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusColumn('Valid Balance', balance),
            _buildStatusColumn('Total Credits', credits),
            _buildStatusColumn('Task Completed', tasksCompleted),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusColumn(String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
} 