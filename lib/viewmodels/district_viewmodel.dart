import 'package:flutter/foundation.dart';

class DistrictViewModel extends ChangeNotifier {
  final List<String> keralaDistricts = [
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];

  String _selectedDistrict = 'Thiruvananthapuram';
  String get selectedDistrict => _selectedDistrict;

  void setDistrict(String district) {
    _selectedDistrict = district;
    notifyListeners();
  }
} 