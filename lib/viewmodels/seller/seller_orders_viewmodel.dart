import 'package:flutter/foundation.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/notification_repository.dart';
import '../../models/user.dart';

class SellerOrdersViewModel extends ChangeNotifier {
  final OrderRepository _orderRepo = OrderRepository();
  final NotificationRepository _notifRepo = NotificationRepository();

  List<Map<String, dynamic>> _allOrders = [];
  List<Map<String, dynamic>> _filtered = [];
  List<Map<String, dynamic>> get filtered => _filtered;

  bool _loading = true;
  bool get loading => _loading;

  int _filterIdx = 0;
  int get filterIdx => _filterIdx;

  late User _currentUser;

  void init(User user) {
    _currentUser = user;
  }

  void setFilter(int index) {
    _filterIdx = index;
    _applyFilter();
    notifyListeners();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _allOrders = await _orderRepo.getBySeller(_currentUser.id!);
    _applyFilter();
    _loading = false;
    notifyListeners();
  }

  void _applyFilter() {
    if (_filterIdx == 0) {
      _filtered = List.from(_allOrders);
      return;
    }
    final statusMap = {1: 'pending', 2: 'dikonfirmasi', 3: 'selesai', 4: 'dibatalkan'};
    _filtered = _allOrders.where((o) => o['status'] == statusMap[_filterIdx]).toList();
  }

  Future<void> updateStatus(int orderId, String status) async {
    final order = _allOrders.firstWhere((o) => o['id'] == orderId,
        orElse: () => <String, dynamic>{});
    final buyerId = order['buyer_id'] as int?;
    final bookJudul = order['book_judul'] ?? 'Buku';
    await _orderRepo.updateStatus(orderId, status);
    if (buyerId != null && (status == 'dikonfirmasi' || status == 'dibatalkan')) {
      final title = status == 'dikonfirmasi'
          ? 'Pesanan Dikonfirmasi'
          : 'Pesanan Ditolak';
      final message = status == 'dikonfirmasi'
          ? 'Pesanan "$bookJudul" telah dikonfirmasi. Silakan lakukan pembayaran sekarang.'
          : 'Pesanan "$bookJudul" telah ditolak oleh seller.';
      await _notifRepo.create(buyerId, title, message,
          type: status == 'dikonfirmasi' ? 'order_confirmed' : 'order_rejected',
          relatedOrderId: orderId);
    }
    await load();
  }

  Future<void> updatePaymentStatus(int orderId, String paymentStatus) async {
    await _orderRepo.updatePaymentStatus(orderId, paymentStatus);
    await load();
  }
}
