import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../core/navigation/app_routes.dart'; 

import 'banner_section.dart';
import 'greeting_card.dart';
import 'status_card.dart';
import 'bottom_banner_section.dart';
import 'package:shimmer/shimmer.dart';
import 'home_shimmer_skeleton.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    // Start a timer to remove shimmer after 2 seconds
    if (vm.isLoading) {
      Future.delayed(const Duration(seconds: 2), () {
        if (vm.isLoading) {
          vm.setLoading(false);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Notification action
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Profile action
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out from Firebase
              await FirebaseAuth.instance.signOut();
              // Navigate to login or splash screen
              Navigator.pushReplacementNamed(context, AppRoutes.signupPersonal);
            },
            tooltip: AppStrings.logout
            ,
          ),
        ],
      ),
      body: vm.isLoading
          ? const HomeShimmerSkeleton()
          : SingleChildScrollView(
              child: Column(
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
                          label: AppStrings.viewTask
                          ,
                          onTap: () {},
                        ),
                        _HomeActionButton(
                          icon: Icons.group_add,
                          label:AppStrings.inviteAndEarn
                          ,
                          onTap: () {},
                        ),
                        _HomeActionButton(
                          icon: Icons.account_balance_wallet,
                          label: AppStrings.wallet
                          ,
                          onTap: () {},
                        ),
                        _HomeActionButton(
                          icon: Icons.history,
                          label: AppStrings.taskHistory
                          ,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BottomBannerSection(),
                ],
              ),
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
