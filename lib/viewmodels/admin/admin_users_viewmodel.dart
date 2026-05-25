import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';

class AdminUsersViewModel extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();

  List<User> _sellers = [];
  List<User> get sellers => _sellers;

  List<User> _buyers = [];
  List<User> get buyers => _buyers;

  bool _loading = true;
  bool get loading => _loading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<User> filterUsers(List<User> list) {
    if (_searchQuery.isEmpty) return list;
    return list.where((u) =>
        u.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        u.email.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _sellers = await _userRepo.getAll(role: 'seller');
    _buyers = await _userRepo.getAll(role: 'buyer');
    _loading = false;
    notifyListeners();
  }

  Future<void> toggleUserStatus(User user) async {
    await _userRepo.updateStatus(user.id!, !user.isActive);
    await load();
  }

  Future<void> deleteUser(User user) async {
    await _userRepo.delete(user.id!);
    await load();
  }
}
