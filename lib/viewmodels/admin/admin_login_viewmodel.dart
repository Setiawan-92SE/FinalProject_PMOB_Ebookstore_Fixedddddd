import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';

class AdminLoginViewModel extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  User? _user;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _userRepo.login(email, password, 'admin');

    _loading = false;
    if (result != null) {
      _user = result;
      notifyListeners();
      return true;
    } else {
      _error = 'Email atau password admin salah.';
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _loading = false;
    _error = null;
    _user = null;
    notifyListeners();
  }
}
