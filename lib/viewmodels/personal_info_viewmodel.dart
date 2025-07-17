import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/personal_info_model.dart';
import '../core/navigation/app_routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Controllers for auto-updating fields
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  // Interests
  Set<String> education = {};
  Set<String> technology = {};
  Set<String> lifestyle = {};
  Set<String> entertainment = {};
  Set<String> careerAndMoney = {};
  Set<String> socialMedia = {};
  Set<String> personalGrowth = {};
  Set<String> regionalAndCultural = {};
  Set<String> wellbeingAndAwareness = {};

  // Phone OTP state
  bool isOtpSent = false;
  bool isPhoneVerified = false;
  String otpCode = '';
  String? verificationId;

  // Password validation state
  bool showPasswordMismatchError = false;
  bool showPasswordCapitalError = false;
  bool showPasswordSpecialCharError = false;

  String get passwordStrength {
    if (password.length < 6) return 'Weak';
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasSpecial = password.contains(RegExp(r'[&@#]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    if (hasUpper && hasSpecial && hasNumber && password.length >= 8) return 'Strong';
    if ((hasUpper || hasSpecial) && password.length >= 6) return 'Medium';
    return 'Weak';
  }

  String? getPasswordErrorMessage() {
    if (password.isEmpty || confirmPassword.isEmpty) return null;
    if (password != confirmPassword) {
      showPasswordMismatchError = true;
      return 'Passwords do not match. Please enter correctly';
    } else {
      showPasswordMismatchError = false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      showPasswordCapitalError = true;
      return 'Please add at least one capital letter';
    } else {
      showPasswordCapitalError = false;
    }
    if (!password.contains(RegExp(r'[&@#]'))) {
      showPasswordSpecialCharError = true;
      return 'Password must include at least one special character: & @ #';
    } else {
      showPasswordSpecialCharError = false;
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      profileImage = File(picked.path);
      notifyListeners();
    }
  }

  String getValidationErrorMessage() {
    List<String> errors = [];
    if (fullName.isEmpty) errors.add('Full Name');
    if (email.isEmpty) errors.add('Email');
    if (mobile.isEmpty) errors.add('Mobile Number');
    if (password.isEmpty) errors.add('Password');
    if (confirmPassword.isEmpty) errors.add('Confirm Password');
    if (password != confirmPassword) errors.add('Passwords do not match');
    if (dob == null) errors.add('Date of Birth');
    if (dob != null && age < 16) errors.add('You must be at least 16 years old');
    if (gender.isEmpty) errors.add('Gender');
    if (country.isEmpty) errors.add('Country');
    if (state.isEmpty) errors.add('State');
    if (city.isEmpty) errors.add('City');
    if (pinCode.isEmpty) errors.add('Pin Code');
    if (qualification.isEmpty) errors.add('Qualification');
    if (occupation.isEmpty) errors.add('Occupation');
    if (totalSelectedInterests.isEmpty) errors.add('At least one interest');
    if (errors.isEmpty) return '';
    // If only one error and it's a custom message, show it directly
    if (errors.length == 1 && (errors[0].startsWith('Passwords') || errors[0].startsWith('You must'))) {
      return errors[0];
    }
    return 'Please correct: ' + errors.join(', ');
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
      case 'country': country = value; countryController.text = value; break;
      case 'state': state = value; stateController.text = value; break;
      case 'city': city = value; cityController.text = value; break;
      case 'pinCode': pinCode = value; pinCodeController.text = value; break;
      case 'qualification': qualification = value; break;
      case 'occupation': occupation = value; break;
      case 'referral': referral = value; break;
    }
    notifyListeners();
  }

  void toggleCategoryInterest(String category, String interest) {
    final Set<String> categorySet = getCategorySet(category);
    if (categorySet.contains(interest)) {
      categorySet.remove(interest);
    } else {
      categorySet.add(interest);
    }
    notifyListeners();
  }

  Set<String> getCategorySet(String category) {
    switch (category) {
      case 'education': return education;
      case 'technology': return technology;
      case 'lifestyle': return lifestyle;
      case 'entertainment': return entertainment;
      case 'careerAndMoney': return careerAndMoney;
      case 'socialMedia': return socialMedia;
      case 'personalGrowth': return personalGrowth;
      case 'regionalAndCultural': return regionalAndCultural;
      case 'wellbeingAndAwareness': return wellbeingAndAwareness;
      default: return {};
    }
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
        totalSelectedInterests.isNotEmpty;
  }

  List<String> get totalSelectedInterests {
    return [
      ...education,
      ...technology,
      ...lifestyle,
      ...entertainment,
      ...careerAndMoney,
      ...socialMedia,
      ...personalGrowth,
      ...regionalAndCultural,
      ...wellbeingAndAwareness,
    ];
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
        profileImageUrl: imageUrl,
        referral: referral.isEmpty ? null : referral,
        education: education.toList(),
        technology: technology.toList(),
        lifestyle: lifestyle.toList(),
        entertainment: entertainment.toList(),
        careerAndMoney: careerAndMoney.toList(),
        socialMedia: socialMedia.toList(),
        personalGrowth: personalGrowth.toList(),
        regionalAndCultural: regionalAndCultural.toList(),
        wellbeingAndAwareness: wellbeingAndAwareness.toList(),
      );

      print('DEBUG PersonalInfoModel: ' + userModel.toMap().toString());

      await FirebaseFirestore.instance.collection('users').doc(uid).set(userModel.toMap());

      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> handleLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        print('Location permission granted');
      } else if (result.isPermanentlyDenied) {
        openAppSettings(); // redirect to settings
      } else {
        print(' Location permission denied');
      }
    } else if (status.isGranted) {
      print(' Already granted');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> fetchAndSetLocation() async {
    try {
      await handleLocationPermission();
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return;
      }

      Position position = await getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        city = place.locality ?? '';
        state = place.administrativeArea ?? '';
        country = place.country ?? '';
        pinCode = place.postalCode ?? '';
        cityController.text = city;
        stateController.text = state;
        countryController.text = country;
        pinCodeController.text = pinCode;
        notifyListeners();
      }
    } catch (e) {
      print('Location error: $e');
    }
  }

  Future<void> sendOtp(String phoneNumber, BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        isPhoneVerified = true;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone verified automatically!')));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed:  ${e.message}')));
      },
      codeSent: (String vId, int? resendToken) {
        verificationId = vId;
        isOtpSent = true;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent!')));
      },
      codeAutoRetrievalTimeout: (String vId) {
        verificationId = vId;
      },
    );
  }

  Future<void> verifyOtp(String smsCode, BuildContext context) async {
    if (verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No verification ID.')));
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      isPhoneVerified = true;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone verified!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP: $e')));
    }
  }
}
