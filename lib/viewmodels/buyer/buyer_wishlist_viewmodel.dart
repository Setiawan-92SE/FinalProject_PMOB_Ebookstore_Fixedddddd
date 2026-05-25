import 'package:flutter/foundation.dart';
import '../../models/book.dart';
import '../../repositories/wishlist_repository.dart';

class BuyerWishlistViewModel extends ChangeNotifier {
  final WishlistRepository _wishRepo = WishlistRepository();

  List<Book> _books = [];
  List<Book> get books => _books;

  bool _loading = true;
  bool get loading => _loading;

  Future<void> load(int userId) async {
    _loading = true;
    notifyListeners();

    _books = await _wishRepo.getBooks(userId);

    _loading = false;
    notifyListeners();
  }

  Future<void> remove(int userId, int bookId) async {
    await _wishRepo.remove(userId, bookId);
    await load(userId);
  }
}