import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/constants/app_strings.dart';
import '../model/personal_info_model.dart';
import '../core/navigation/app_routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

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
  String gender = ''; // No default, user must select
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
    if (password.length < 6) return AppStrings.passwordStrengthWeak
    ;
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasSpecial = password.contains(RegExp(r'[&@#]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    if (hasUpper && hasSpecial && hasNumber && password.length >= 8) return AppStrings.passwordStrengthStrong
    ;
    if ((hasUpper || hasSpecial) && password.length >= 6) return AppStrings.passwordStrengthMedium
    ;
    return 'Weak';
  }

  String? getPasswordErrorMessage() {
    List<String> errors = [];
    if (password.isEmpty || confirmPassword.isEmpty) return null;
    if (password != confirmPassword) {
      showPasswordMismatchError = true;
      errors.add(AppStrings.passwordsDoNotMatch
      );
    } else {
      showPasswordMismatchError = false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      showPasswordCapitalError = true;
      errors.add(AppStrings.addOneCapitalLetter
      );
    } else {
      showPasswordCapitalError = false;
    }
    if (!password.contains(RegExp(r'[&@#]'))) {
      showPasswordSpecialCharError = true;
      errors.add(AppStrings.passwordNeedsSpecialChar
      );
    } else {
      showPasswordSpecialCharError = false;
    }
    if (password.length < 6) {
      errors.add(AppStrings.passwordMinLength
      );
    }
    if (errors.isEmpty) return null;
    return errors.join('\n');
  }

  String? getPhoneNumberError() {
    if (mobile.isEmpty) return AppStrings.phoneNumberRequired
    ;
    if (!RegExp(r'^[0-9]+$').hasMatch(mobile)) return AppStrings.phoneNumberMustBeNumeric
    ;
    if (mobile.length != 10) return AppStrings.phoneNumberLengthError
    ;
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
    if (fullName.isEmpty) errors.add(AppStrings.fullName
    );
    if (email.isEmpty) errors.add(AppStrings.email
    );
    if (mobile.isEmpty) errors.add(AppStrings.mobileNumber
    );
    if (password.isEmpty) errors.add(AppStrings.password
    );
    if (confirmPassword.isEmpty) errors.add(AppStrings.confirmPassword
    );
    if (password != confirmPassword) errors.add(AppStrings.passwordsDoNotMatch
    );
    if (dob == null) errors.add(AppStrings.dateOfBirth
    );
    if (dob != null && age < 16) errors.add(AppStrings.ageValidationError
    );
    if (gender.isEmpty) errors.add(AppStrings.gender
    );
    if (country.isEmpty) errors.add(AppStrings.country
    );
    if (state.isEmpty) errors.add(AppStrings.state
    );
    if (city.isEmpty) errors.add(AppStrings.city
    );
    if (pinCode.isEmpty) errors.add(AppStrings.pinCode
    );
    if (qualification.isEmpty) errors.add(AppStrings.qualification
    );
    if (occupation.isEmpty) errors.add(AppStrings.occupation
    );
    if (totalSelectedInterests.isEmpty) errors.add(AppStrings.atLeastOneInterest
    );
    if (errors.isEmpty) return '';
    // If only one error and it's a custom message, show it directly
    if (errors.length == 1 && (errors[0].startsWith(AppStrings.passwords
    ) || errors[0].startsWith(AppStrings.youMust
    ))) {
      return errors[0];
    }
    return AppStrings.pleaseCorrect
        + errors.join(', ');
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
      case AppStrings.fullName
          : fullName = value; break;
      case AppStrings.email
          : email = value; break;
      case AppStrings.mobile
          : mobile = value; break;
      case AppStrings.password
          : password = value; break;
      case AppStrings.confirmPassword
          : confirmPassword = value; break;
      case AppStrings.genderKey:
        gender = value;
        print('Gender updated: $gender'); // Debug print
        break;
      case AppStrings.country
          : country = value; countryController.text = value; break;
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
      case AppStrings.education
          : return education;
      case AppStrings.technology
          : return technology;
      case AppStrings.lifestyle
          : return lifestyle;
      case AppStrings.entertainment
          : return entertainment;
      case AppStrings.careerAndMoney
          : return careerAndMoney;
      case AppStrings.socialMedia
          : return socialMedia;
      case AppStrings.personalGrowth
          : return personalGrowth;
      case AppStrings.regionalAndCultural
          : return regionalAndCultural;
      case AppStrings.wellbeingAndAwareness
          : return wellbeingAndAwareness;
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
      // Mark personal info as completed
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'isCompletedInfo': true});

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

  // For real-time polyline tracking
  List<LatLng> traveledPath = [];
  StreamSubscription<Position>? _positionStream;

  void startTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // meters
      ),
    ).listen((Position position) {
      traveledPath.add(LatLng(position.latitude, position.longitude));
      notifyListeners();
    });
  }

  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  void clearTraveledPath() {
    traveledPath.clear();
    notifyListeners();
  }

  // Simulate movement for testing polyline without physical movement
  Future<void> simulatePath() async {
    List<LatLng> mockPoints = [
      LatLng(12.9716, 77.5946),
      LatLng(12.9720, 77.5950),
      LatLng(12.9725, 77.5955),
      LatLng(12.9730, 77.5960),
      LatLng(12.9735, 77.5965),
    ];
    for (var point in mockPoints) {
      traveledPath.add(point);
      notifyListeners();
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
