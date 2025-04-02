import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  UserModel? _user;
  bool _loading = false;

  UserModel? get user => _user;
  bool get loading => _loading;

  Future<void> loadUser() async {
    _loading = true;
    notifyListeners();

    try {
      _user = await _userService.getCurrentUser();
    } catch (e) {
      print('Error loading user: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _loading = true;
    notifyListeners();

    try {
      await _userService.logout();
      _user = null;
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> updateLocation(String location) async {
    if (_user == null) return;

    _loading = true;
    notifyListeners();

    try {
      await _userService.updateLocation(_user!.id, location);
      _user = _user?.copyWith(location: location);
    } catch (e) {
      print('Error updating location: $e');
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
