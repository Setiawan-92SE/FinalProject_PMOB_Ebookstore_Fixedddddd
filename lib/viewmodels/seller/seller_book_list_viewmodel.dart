import 'package:flutter/foundation.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/category_repository.dart';
import '../../models/user.dart';

class SellerBookListViewModel extends ChangeNotifier {
  final BookRepository _bookRepo = BookRepository();
  final CategoryRepository _catRepo = CategoryRepository();

  List<Book> _books = [];
  List<Book> get books => _books;

  List<String> _categories = [];
  List<String> get categories => _categories;

  bool _loading = true;
  bool get loading => _loading;

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  late User _currentUser;
  User get currentUser => _currentUser;

  void init(User user) {
    _currentUser = user;
  }

  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
    load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final statusMap = {0: null, 1: 'pending', 2: 'approved', 3: 'rejected'};
    final results = await Future.wait([
      _bookRepo.getBySeller(_currentUser.id!, status: statusMap[_selectedTab]),
      _catRepo.getNames(),
    ]);

    _books = results[0] as List<Book>;
    _categories = results[1] as List<String>;
    _loading = false;
    notifyListeners();
  }

  Future<void> addBook(String judul, String penulis, String kategori, double harga, int stok, String deskripsi) async {
    final book = Book(
      judul: judul, penulis: penulis, kategori: kategori,
      harga: harga, stok: stok, deskripsi: deskripsi,
      status: 'pending', sellerId: _currentUser.id,
    );
    await _bookRepo.insert(book);
    await load();
  }

  Future<void> updateBook(Book book) async {
    await _bookRepo.update(book);
    await load();
  }

  Future<void> deleteBook(Book book) async {
    await _bookRepo.delete(book.id!);
    await load();
  }
}
