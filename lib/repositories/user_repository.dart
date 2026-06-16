import '../database/database.helper.dart';
import '../models/user.dart';

class UserRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<User?> login(String email, String password, String role) => _db.login(email, password, role);
  Future<int> register(User user) => _db.register(user);
  Future<bool> isEmailExists(String email) => _db.isEmailExists(email);
  Future<List<User>> getAll({String? role}) => _db.getAllUsers(role: role);
  Future<int> updateStatus(int userId, bool isActive) => _db.updateUserStatus(userId, isActive);
  Future<int> updateUser(User user) => _db.updateUser(user);
  Future<int> delete(int userId) => _db.deleteUser(userId);
  Future<int> count({String? role}) => _db.countUsers(role: role);
  Future<Map<String, int>> getAnalyticsCounts() => _db.getAnalyticsCounts();
}
