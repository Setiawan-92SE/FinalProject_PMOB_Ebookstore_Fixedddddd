import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';

class BuyerAuthViewModel extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String? _successMessage;
  String? get successMessage => _successMessage;

  User? _user;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _userRepo.login(email, password, 'buyer');

    _loading = false;
    if (result != null) {
      _user = result;
      notifyListeners();
      return true;
    } else {
      _error = 'Email atau password salah. Pastikan terdaftar sebagai Buyer.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String nama, String email, String phone, String password) async {
    _loading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    final exists = await _userRepo.isEmailExists(email);
    if (exists) {
      _loading = false;
      _error = 'Email sudah terdaftar. Gunakan email lain.';
      notifyListeners();
      return false;
    }

    final newUser = User(
      nama: nama, email: email, phone: phone,
      password: password, role: 'buyer',
    );

    final id = await _userRepo.register(newUser);
    _loading = false;
    if (id > 0) {
      _successMessage = 'Akun Buyer berhasil dibuat! Silakan login.';
      notifyListeners();
      return true;
    } else {
      _error = 'Gagal membuat akun. Coba lagi.';
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}