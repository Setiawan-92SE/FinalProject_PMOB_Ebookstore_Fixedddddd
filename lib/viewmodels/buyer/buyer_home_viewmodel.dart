import 'package:flutter/foundation.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';

class BuyerHomeViewModel extends ChangeNotifier {
  final BookRepository _bookRepo = BookRepository();

  List<Book> _allBooks = [];
  List<Book> get allBooks => _allBooks;

  List<Book> _featured = [];
  List<Book> get featured => _featured;

  bool _loading = true;
  bool get loading => _loading;

  Future<void> loadBooks() async {
    _loading = true;
    notifyListeners();

    _allBooks = await _bookRepo.getAll(status: 'approved');
    _featured = _allBooks.take(5).toList();

    _loading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadBooks();
      return;
    }
    _loading = true;
    notifyListeners();

    _allBooks = await _bookRepo.search(query);

    _loading = false;
    notifyListeners();
  }
}