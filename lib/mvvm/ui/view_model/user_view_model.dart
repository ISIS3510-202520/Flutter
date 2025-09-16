import 'package:flutter/material.dart';
import 'package:here4u/models/user_entity.dart';
import 'package:here4u/mvvm/data/services/user_service.dart';
 
class UserViewModel extends ChangeNotifier {
  final UserService _service = UserService();
  UserEntity? _user;
  
  UserEntity? get user => _user;

  Future<void> loadUser(String id) async {
    _user = await _service.fetchUser(id);
    notifyListeners();
  }
  // Add more methods for login, registration, etc.
}