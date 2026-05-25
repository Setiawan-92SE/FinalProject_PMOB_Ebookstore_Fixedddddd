import '../database/database.helper.dart';
import '../models/book.dart';

class WishlistRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<int> add(int userId, int bookId) => _db.addToWishlist(userId, bookId);
  Future<int> remove(int userId, int bookId) => _db.removeFromWishlist(userId, bookId);
  Future<bool> isInWishlist(int userId, int bookId) => _db.isInWishlist(userId, bookId);
  Future<List<Book>> getBooks(int userId) => _db.getWishlistBooks(userId);
}
