import 'package:flutter/foundation.dart';
import '../../models/book.dart';
import '../../repositories/cart_repository.dart';
import '../../repositories/wishlist_repository.dart';

class BuyerBookDetailViewModel extends ChangeNotifier {
  final WishlistRepository _wishRepo = WishlistRepository();
  final CartRepository _cartRepo = CartRepository();

  bool _inWish = false;
  bool get inWish => _inWish;

  bool _inCart = false;
  bool get inCart => _inCart;

  int _qty = 1;
  int get qty => _qty;

  void setQty(int value) {
    _qty = value;
    notifyListeners();
  }

  double getTotal(Book book) => book.harga * _qty;

  Future<void> checkState(int userId, Book book) async {
    if (book.id == null) return;
    final results = await Future.wait([
      _wishRepo.isInWishlist(userId, book.id!),
      _cartRepo.getItems(userId),
    ]);

    _inWish = results[0] as bool;
    final cartItems = results[1] as List<Map<String, dynamic>>;
    _inCart = cartItems.any((m) => m['id'] == book.id);
    notifyListeners();
  }

  Future<void> toggleWishlist(int userId, int bookId) async {
    if (_inWish) {
      await _wishRepo.remove(userId, bookId);
    } else {
      await _wishRepo.add(userId, bookId);
    }
    _inWish = !_inWish;
    notifyListeners();
  }

  Future<void> addToCart(int userId, int bookId) async {
    await _cartRepo.addItem(userId, bookId, qty: _qty);
    _inCart = true;
    notifyListeners();
  }
}