import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../core/navigation/app_routes.dart'; 

import 'banner_section.dart';
import 'greeting_card.dart';
import 'status_card.dart';
import 'bottom_banner_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Notification action
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Profile action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          BannerSection(),
          GreetingCard(userName: vm.username),
          StatusCard(
            balance: vm.balance,
            credits: vm.credits,
            tasksCompleted: vm.tasksCompleted,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HomeActionButton(
                  icon: Icons.assignment,
                  label: 'View Task',
                  onTap: () {},
                ),
                _HomeActionButton(
                  icon: Icons.group_add,
                  label: 'Invite & Earn',
                  onTap: () {},
                ),
                _HomeActionButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Wallet',
                  onTap: () {},
                ),
                _HomeActionButton(
                  icon: Icons.history,
                  label: 'Task History',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          BottomBannerSection(),
        ],
      ),
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
            iconSize: 32,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
