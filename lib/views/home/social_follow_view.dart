import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/navigation/app_routes.dart';
import '../../viewmodels/social_follow_viewmodel.dart';
import '../widgets/social_follow_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialFollowView extends StatelessWidget {
  const SocialFollowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialFollowViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Image.asset('assets/images/pulse_logo.jpeg', height: 100),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome to\nPulsePost!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'To get started, please follow us on the platforms below. This helps you stay informed and get priority in tasks.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Progress'),
                            Text('${vm.progress}/4'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: vm.progress / 4,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 12),
                     SocialCard(
                      icon: FontAwesomeIcons.facebookF,
                      color: Colors.blue,
                      title: 'Facebook',
                      subtitle: 'Follow us on Facebook',
                      index: 0,
                      buttonText: "I've Followed",
                    ),
                     SocialCard(
                      icon: FontAwesomeIcons.instagram,
                      color: Colors.purple,
                      title: 'Instagram',
                      subtitle: 'Follow us on Instagram',
                      index: 1,
                      buttonText: "I've Followed",
                    ),
                     SocialCard(
                      icon: FontAwesomeIcons.youtube,
                      color: Colors.red,
                      title: 'YouTube',
                      subtitle: 'Subscribe to our YouTube',
                      index: 2,
                      buttonText: "I've Subscribed",
                    ),
                     SocialCard(
                      icon: FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      title: 'WhatsApp',
                      subtitle: 'Join our WhatsApp Broadcast',
                      index: 3,
                      buttonText: "I've Joined",
                    ),
                    const SizedBox(height: 24),
                    // Minimal test buttons for debugging
                    ElevatedButton(
                      onPressed: vm.allFollowed
                          ? () async {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid != null) {
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .update({'isProfileComplete': true});

                            print('Marked isProfileComplete = true in Firestore');
                          } catch (e) {
                            print('Failed to update isProfileComplete: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Something went wrong. Please try again.')),
                            );
                            return;
                          }
                        }

                        print('Navigating to home...');
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Complete all follows to continue'),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
