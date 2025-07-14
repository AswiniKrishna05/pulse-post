import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziya_project/viewmodels/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Safe way to call async logic after build
    Future.microtask(() {
      final splashViewModel = Provider.of<SplashViewModel>(context, listen: false);
      splashViewModel.initializeApp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/ziyalogo.jpeg",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pulse Post',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Post. Prove. Earn.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
