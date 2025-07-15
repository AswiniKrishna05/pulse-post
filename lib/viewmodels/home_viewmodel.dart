import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String username = 'Pulse User';

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
