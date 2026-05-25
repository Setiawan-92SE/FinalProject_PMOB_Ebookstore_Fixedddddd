import 'package:flutter/foundation.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/category_repository.dart';

class BuyerCatalogViewModel extends ChangeNotifier {
  final BookRepository _bookRepo = BookRepository();
  final CategoryRepository _catRepo = CategoryRepository();

  List<Book> _books = [];
  List<Book> get books => _books;

  List<String> _categories = ['Semua'];
  List<String> get categories => _categories;

  String _selected = 'Semua';
  String get selectedCategory => _selected;

  bool _loading = true;
  bool get loading => _loading;

  String _sortBy = 'nama';

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final cats = await _catRepo.getNames();
    final bookList = _selected == 'Semua'
        ? await _bookRepo.getAll(status: 'approved')
        : await _bookRepo.getByCategory(_selected);

    _categories = ['Semua', ...cats];
    _books = _sortBooks(bookList);
    _loading = false;
    notifyListeners();
  }

  List<Book> _sortBooks(List<Book> books) {
    final sorted = List<Book>.from(books);
    if (_sortBy == 'harga_asc') {
      sorted.sort((a, b) => a.harga.compareTo(b.harga));
    } else if (_sortBy == 'harga_desc') {
      sorted.sort((a, b) => b.harga.compareTo(a.harga));
    } else {
      sorted.sort((a, b) => a.judul.compareTo(b.judul));
    }
    return sorted;
  }

  void setCategory(String category) {
    _selected = category;
    load();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    load();
  }
}