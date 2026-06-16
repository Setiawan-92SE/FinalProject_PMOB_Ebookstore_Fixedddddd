import 'dart:async';
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

  List<Map<String, dynamic>> _monthlyRevenueRaw = [];
  Timer? _timer;

  bool _loading = true;
  bool get loading => _loading;

  List<Map<String, dynamic>> get monthlyRevenue {
    const monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final now = DateTime.now();
    final dbMap = <String, int>{};
    for (final row in _monthlyRevenueRaw) {
      final key = '${row['year']}-${row['month']}';
      dbMap[key] = row['total'] as int;
    }
    final result = <Map<String, dynamic>>[];
    for (int i = 5; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      final key = '${d.year}-${d.month}';
      result.add({'label': monthNames[d.month], 'total': dbMap[key] ?? 0});
    }
    return result;
  }

  void startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => load());
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _stats = await _userRepo.getAnalyticsCounts();
    _recentOrders = await _orderRepo.getAllAdmin(limit: 5);
    _monthlyRevenueRaw = await _orderRepo.getMonthlyRevenueAll();

    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
