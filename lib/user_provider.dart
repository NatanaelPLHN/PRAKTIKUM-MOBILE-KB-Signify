import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _email = '';
  String? _profilePictureUrl;

  String get username => _username;
  String get email => _email;
  String? get profilePictureUrl => _profilePictureUrl;

  void setUserProfile({
    required String username,
    required String email,
    String? profilePictureUrl,
  }) {
    _username = username;
    _email = email;
    _profilePictureUrl = profilePictureUrl;
    notifyListeners(); 
  }
}
