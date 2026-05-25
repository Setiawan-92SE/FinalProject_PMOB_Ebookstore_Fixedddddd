import 'package:flutter/foundation.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/order_repository.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();
  final OrderRepository _orderRepo = OrderRepository();

  Map<String, int> _stats = {};
  Map<String, int> get stats => _stats;

  List<Map<String, dynamic>> _recentOrders = [];
  List<Map<String, dynamic>> get recentOrders => _recentOrders;

  bool _loading = true;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _stats = await _userRepo.getAnalyticsCounts();
    _recentOrders = await _orderRepo.getAllAdmin(limit: 5);

    _loading = false;
    notifyListeners();
  }
}
