import 'package:flutter/material.dart';
import 'package:ziya_project/viewmodels/splash_viewmodel.dart';
import 'package:provider/provider.dart';


class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final splashViewModel= Provider.of<SplashViewModel>(context,listen: false);
     Future.microtask(() => splashViewModel.initializeApp(context));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/pulse_logo.jpeg",width: 150,height: 150,),
            const SizedBox(height: 20,),
            const Text('Pulse Post',
            style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
            ),
            const Text(
              'Post.Prove.Earn.',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
