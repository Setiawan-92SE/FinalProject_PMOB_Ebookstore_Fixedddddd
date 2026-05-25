import '../database/database.helper.dart';

class CartRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<int> addItem(int userId, int bookId, {int qty = 1}) => _db.addToCart(userId, bookId, qty: qty);
  Future<int> updateQty(int userId, int bookId, int qty) => _db.updateCartQty(userId, bookId, qty);
  Future<int> removeItem(int userId, int bookId) => _db.removeFromCart(userId, bookId);
  Future<List<Map<String, dynamic>>> getItems(int userId) => _db.getCartItems(userId);
  Future<int> clear(int userId) => _db.clearCart(userId);
}
