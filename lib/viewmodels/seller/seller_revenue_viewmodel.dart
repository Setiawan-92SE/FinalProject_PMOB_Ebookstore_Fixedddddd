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

  void init(User user) {
    _currentUser = user;
  }

  int get totalRevenue => _orders
      .where((o) => o['status'] == 'selesai')
      .fold(0, (s, o) => s + (o['total'] as num).toInt());

  int get totalOrders => _orders.length;
  int get doneOrders => _orders.where((o) => o['status'] == 'selesai').length;
  int get pendingOrders => _orders.where((o) => o['status'] == 'pending').length;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _orders = await _orderRepo.getBySeller(_currentUser.id!);

    _loading = false;
    notifyListeners();
  }
}
