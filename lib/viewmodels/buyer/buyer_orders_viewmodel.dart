import 'package:flutter/foundation.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/notification_repository.dart';

class BuyerOrdersViewModel extends ChangeNotifier {
  final OrderRepository _orderRepo = OrderRepository();
  final NotificationRepository _notifRepo = NotificationRepository();

  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> get orders => _orders;

  bool _loading = true;
  bool get loading => _loading;

  int _filterIdx = 0;
  int get filterIdx => _filterIdx;

  static const _statusMap = {
    0: null,
    1: 'pending',
    2: 'dikonfirmasi',
    3: 'selesai',
    4: 'dibatalkan',
  };

  List<Map<String, dynamic>> get filtered {
    final status = _statusMap[_filterIdx];
    if (status == null) return List.from(_orders);
    return _orders.where((o) => o['status'] == status).toList();
  }

  void setFilter(int index) {
    _filterIdx = index;
    notifyListeners();
  }

  Future<void> load(int userId) async {
    _loading = true;
    notifyListeners();

    _orders = await _orderRepo.getByBuyer(userId);

    _loading = false;
    notifyListeners();
  }

  Future<void> payOrder(
      int orderId, String paymentMethod, String accountNumber, String pin) async {
    final order = _orders.firstWhere((o) => o['id'] == orderId,
        orElse: () => <String, dynamic>{});
    final sellerId = order['seller_id'] as int?;
    final bookJudul = order['book_judul'] ?? 'Buku';
    await _orderRepo.updatePaymentAndStatus(orderId, 'lunas', 'selesai',
        paymentMethod: paymentMethod, paymentAccount: accountNumber);
    if (sellerId != null) {
      await _notifRepo.create(
          sellerId,
          'Pembayaran Diterima',
          'Pembayaran untuk "$bookJudul" telah diterima via $paymentMethod.',
          type: 'payment_received',
          relatedOrderId: orderId);
    }
  }

  Future<void> refresh(int userId) async {
    await load(userId);
  }
}
