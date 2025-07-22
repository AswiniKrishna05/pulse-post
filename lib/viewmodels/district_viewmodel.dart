import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';

class DistrictViewModel extends ChangeNotifier {
  final List<String> keralaDistricts = [
    AppStrings.thiruvananthapuram,
    AppStrings.kollam,
    AppStrings.pathanamthitta,
    AppStrings.alappuzha,
    AppStrings.kottayam,
    AppStrings.idukki,
    AppStrings.ernakulam,
    AppStrings.thrissur,
    AppStrings.palakkad,
    AppStrings.malappuram,
    AppStrings.kozhikode,
    AppStrings.wayanad,
    AppStrings.kannur,
    AppStrings.kasaragod,
  ];

  String _selectedDistrict = AppStrings.thiruvananthapuram;
  String get selectedDistrict => _selectedDistrict;

  void setDistrict(String district) {
    _selectedDistrict = district;
    notifyListeners();
  }
} 