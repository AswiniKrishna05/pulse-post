import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String username = 'Pulse User';

  void setUsername(String name) {
    username = name;
    notifyListeners();
  }
}
