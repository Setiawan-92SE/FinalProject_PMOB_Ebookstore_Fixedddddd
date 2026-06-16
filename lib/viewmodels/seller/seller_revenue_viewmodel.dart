import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../repositories/order_repository.dart';
import '../../models/user.dart';

class SellerRevenueViewModel extends ChangeNotifier {
  final OrderRepository _orderRepo = OrderRepository();

  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> get orders => _orders;

  bool _loading = true;
  bool get loading => _loading;

  late User _currentUser;
  Timer? _timer;

  void init(User user) {
    _currentUser = user;
  }

  int get totalRevenue => _orders
      .where((o) => o['status'] == 'selesai')
      .fold(0, (s, o) => s + (o['total'] as num).toInt());

  int get totalOrders => _orders.length;
  int get doneOrders => _orders.where((o) => o['status'] == 'selesai').length;
  int get pendingOrders => _orders.where((o) => o['status'] == 'pending').length;

  List<Map<String, dynamic>> get monthlyRevenue {
    const monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];
    for (int i = 5; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      result.add({'label': monthNames[d.month], 'total': 0});
    }
    for (final o in _orders) {
      if (o['status'] != 'selesai') continue;
      final date = DateTime.tryParse(o['created_at'] ?? '');
      if (date == null) continue;
      final monthIdx = (now.year - date.year) * 12 + (now.month - date.month);
      if (monthIdx >= 0 && monthIdx < 6) {
        result[5 - monthIdx]['total'] = (result[5 - monthIdx]['total'] as int) + (o['total'] as num).toInt();
      }
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

    _orders = await _orderRepo.getBySeller(_currentUser.id!);

    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
