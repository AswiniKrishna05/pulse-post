import 'package:flutter/material.dart';

class SocialFollowViewModel extends ChangeNotifier {
  final List<bool> _followed = [false, false, false, false];


  List<bool> get followed => List.unmodifiable(_followed);
  int get progress => _followed.where((f) => f).length;
  bool get allFollowed => progress == _followed.length;

  final List<String> _referralLinks = [
    'https://www.facebook.com/share/1JRQaweaVW/',
    'https://www.instagram.com/ziya_academy_/',
    'https://youtube.com/yourchannel',
    'https://wa.me/yourwhatsapplink',
  ];

  void markFollowed(int index) {
    if (!_followed[index]) {
      _followed[index] = true;
      notifyListeners();
    }
  }

  String getReferralLink(int index) => _referralLinks[index];
}
