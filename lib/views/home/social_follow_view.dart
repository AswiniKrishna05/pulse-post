import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_strings.dart';
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
                      AppStrings.followInstruction,
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
                            const Text(AppStrings.progress
                            ),
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
                      title: AppStrings.facebook
                       ,
                      subtitle: AppStrings.followOnFacebook
                       ,
                      index: 0,
                      buttonText: AppStrings.iveFollowed
                       ,
                    ),
                     SocialCard(
                      icon: FontAwesomeIcons.instagram,
                      color: Colors.purple,
                      title: AppStrings.instagram
                       ,
                      subtitle: AppStrings.followOnInstagram
                       ,
                      index: 1,
                      buttonText:AppStrings.iveFollowed,
                    ),
                     SocialCard(
                      icon: FontAwesomeIcons.youtube,
                      color: Colors.red,
                      title: AppStrings.youtube
                       ,
                      subtitle: AppStrings.subscribeToYoutube
                       ,
                      index: 2,
                      buttonText: AppStrings.iveSubscribed
                       ,
                    ),
                     SocialCard(
                      icon: FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      title: AppStrings.whatsapp
                       ,
                      subtitle: AppStrings.joinWhatsappBroadcast
                       ,
                      index: 3,
                      buttonText: AppStrings.iveJoined
                       ,
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
                                .collection(AppStrings.users
                            )
                                .doc(uid)
                                .update({AppStrings.isProfileComplete
                                : true});

                            print(AppStrings.markedProfileComplete
                            );
                          } catch (e) {
                            print('Failed to update isProfileComplete: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(AppStrings.somethingWentWrong
                              )),
                            );
                            return;
                          }
                        }

                        print(AppStrings.navigatingToHome
                        );
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(AppStrings.completeAllFollows
                      ),
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
