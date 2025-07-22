import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../core/navigation/app_routes.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

import 'banner_section.dart';
import 'greeting_card.dart';
import 'status_card.dart';
import 'bottom_banner_section.dart';
import 'package:shimmer/shimmer.dart';
import 'home_shimmer_skeleton.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _fetchAndSetUserName();
  }

  Future<void> _fetchAndSetUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final name = doc.data()?['fullName'] ?? 'Pulse User';
        if (mounted) {
          Provider.of<HomeViewModel>(context, listen: false).setUsername(name);
        }
      }
    }
  }

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
              Navigator.pushNamed(context, '/google_map');
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
                  const SizedBox(height: 10),
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
    const Color color = Colors.blueAccent;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}

