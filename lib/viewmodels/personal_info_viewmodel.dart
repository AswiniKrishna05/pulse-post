import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/personal_info_model.dart';
import '../core/navigation/app_routes.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  File? profileImage;

  // Form Fields
  String fullName = '';
  String email = '';
  String mobile = '';
  String password = '';
  String confirmPassword = '';
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
  final Set<String> selectedInterests = {};

  void pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      profileImage = File(picked.path);
      notifyListeners();
    }
  }

  void setDob(DateTime date) {
    dob = date;
    final now = DateTime.now();
    age = now.year - date.year;
    if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
      age--;
    }
    notifyListeners();
  }

  void updateField(String field, String value) {
    switch (field) {
      case 'fullName': fullName = value; break;
      case 'email': email = value; break;
      case 'mobile': mobile = value; break;
      case 'password': password = value; break;
      case 'confirmPassword': confirmPassword = value; break;
      case 'gender': gender = value; break;
      case 'country': country = value; break;
      case 'state': state = value; break;
      case 'city': city = value; break;
      case 'pinCode': pinCode = value; break;
      case 'qualification': qualification = value; break;
      case 'occupation': occupation = value; break;
      case 'referral': referral = value; break;
    }
    notifyListeners();
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  bool get isFormValid {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        mobile.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        dob != null &&
        age >= 16 &&
        gender.isNotEmpty &&
        country.isNotEmpty &&
        state.isNotEmpty &&
        city.isNotEmpty &&
        pinCode.isNotEmpty &&
        qualification.isNotEmpty &&
        occupation.isNotEmpty &&
        selectedInterests.isNotEmpty;
  }

  Future<void> saveToFirestore(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not logged in")));
        return;
      }

      String? imageUrl;
      if (profileImage != null) {
        final ref = FirebaseStorage.instance.ref().child("profile_images/$uid.jpg");
        await ref.putFile(profileImage!);
        imageUrl = await ref.getDownloadURL();
      }

      final userModel = PersonalInfoModel(
        fullName: fullName,
        email: email,
        mobile: mobile,
        password: password,
        dob: dob!,
        age: age,
        gender: gender,
        country: country,
        state: state,
        city: city,
        pinCode: pinCode,
        qualification: qualification,
        occupation: occupation,
        interests: selectedInterests.toList(),
        profileImageUrl: imageUrl,
        referral: referral.isEmpty ? null : referral,
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).set(userModel.toMap());

      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
