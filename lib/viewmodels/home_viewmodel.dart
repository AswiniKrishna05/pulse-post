import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';

class HomeViewModel extends ChangeNotifier {
  String username = AppStrings.pulseUser
  ;

  int balance = 0;
  int credits = 0;
  int tasksCompleted = 0;

  bool isLoading = true;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setUsername(String name) {
    username = name;
    notifyListeners();
  }
}
