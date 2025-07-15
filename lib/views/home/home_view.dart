import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ⬅️ Import Firebase Auth
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../core/navigation/app_routes.dart'; // ⬅️ If you're using named routes
import 'banner_section.dart';
import 'greeting_card.dart';

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
            icon: const Icon(Icons.logout),
            onPressed: () async {
              //Sign out from Firebase
              await FirebaseAuth.instance.signOut();

              //Navigate to login screen
              Navigator.pushReplacementNamed(context, AppRoutes.signupPersonal);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          BannerSection(),
          GreetingCard(userName: vm.username),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Welcome, ${vm.username}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
