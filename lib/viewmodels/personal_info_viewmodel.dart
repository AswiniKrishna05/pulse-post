import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/navigation/app_routes.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  File? profileImage;

  String fullName = '';
  String email = '';
  String mobile = '';
  DateTime? dob;
  int age = 0;
  String gender = '';
  String country = '';
  String state = '';
  String city = '';
  String pinCode = '';
  String qualification = '';
  String occupation = '';
  String referral = '';

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      profileImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> saveProfileToFirestore(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    String? imageUrl;
    if (profileImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');
      await ref.putFile(profileImage!);
      imageUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'dob': dob?.toIso8601String(),
      'age': age,
      'gender': gender,
      'country': country,
      'state': state,
      'city': city,
      'pinCode': pinCode,
      'qualification': qualification,
      'occupation': occupation,
      'referral': referral,
      'profileImageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
  }

  void setDob(DateTime date) {
    dob = date;
    _calculateAge();
    notifyListeners();
  }

  void _calculateAge() {
    if (dob == null) return;
    final now = DateTime.now();
    age = now.year - dob!.year;
    if (now.month < dob!.month || (now.month == dob!.month && now.day < dob!.day)) {
      age--;
    }
  }

  void updateField(String key, String value) {
    switch (key) {
      case 'fullName': fullName = value; break;
      case 'email': email = value; break;
      case 'mobile': mobile = value; break;
      case 'gender': gender = value; break;
      case 'country': country = value; break;
      case 'state': state = value; break;
      case 'city': city = value; break;
      case 'pin': pinCode = value; break;
      case 'qualification': qualification = value; break;
      case 'occupation': occupation = value; break;
      case 'referral': referral = value; break;
    }
    notifyListeners();
  }
}
