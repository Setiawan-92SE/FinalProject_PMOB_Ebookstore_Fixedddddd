import 'package:flutter/foundation.dart';
import '../../repositories/cart_repository.dart';
import '../../repositories/order_repository.dart';

class BuyerCartViewModel extends ChangeNotifier {
  final CartRepository _cartRepo = CartRepository();
  final OrderRepository _orderRepo = OrderRepository();

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  bool _loading = true;
  bool get loading => _loading;

  double get total => _items.fold(0.0,
      (s, m) => s + ((m['harga'] as num).toDouble() * (m['cart_qty'] as int)));

  Future<void> load(int userId) async {
    _loading = true;
    notifyListeners();

    _items = await _cartRepo.getItems(userId);

    _loading = false;
    notifyListeners();
  }

  Future<void> updateQty(int userId, int bookId, int qty) async {
    await _cartRepo.updateQty(userId, bookId, qty);
    await load(userId);
  }

  Future<void> removeItem(int userId, int bookId) async {
    await _cartRepo.removeItem(userId, bookId);
    await load(userId);
  }

  Future<void> clearCart(int userId) async {
    await _cartRepo.clear(userId);
    await load(userId);
  }

  Future<void> checkout(int userId) async {
    for (final item in _items) {
      await _orderRepo.create(
        userId,
        item['id'] as int,
        item['cart_qty'] as int,
        (item['harga'] as num).toDouble() * (item['cart_qty'] as int),
      );
    }
    await _cartRepo.clear(userId);
    await load(userId);
  }
}