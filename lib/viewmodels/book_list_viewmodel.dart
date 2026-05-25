import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class BookListViewModel extends ChangeNotifier {
  final BookRepository _bookRepo = BookRepository();

  List<Book> _books = [];
  List<Book> get books => _books;

  List<Book> _filteredBooks = [];
  List<Book> get filteredBooks => _filteredBooks;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _selectedKategori = 'Semua';
  String get selectedKategori => _selectedKategori;

  String _searchKeyword = '';

  final List<String> kategoriFilter = [
    'Semua', 'Fiksi', 'Non-Fiksi', 'Pengembangan Diri',
    'Teknologi', 'Bisnis', 'Sains', 'Sejarah', 'Agama',
  ];

  void setSelectedKategori(String kategori) {
    _selectedKategori = kategori;
    _applyFilter();
    notifyListeners();
  }

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword.toLowerCase().trim();
    _applyFilter();
    notifyListeners();
  }

  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();

    _books = await _bookRepo.getAll();
    _applyFilter();
    _isLoading = false;
    notifyListeners();
  }

  void _applyFilter() {
    _filteredBooks = _books.where((book) {
      final matchKategori = _selectedKategori == 'Semua' || book.kategori == _selectedKategori;
      final matchSearch = _searchKeyword.isEmpty ||
          book.judul.toLowerCase().contains(_searchKeyword) ||
          book.penulis.toLowerCase().contains(_searchKeyword);
      return matchKategori && matchSearch;
    }).toList();
  }

  Future<void> deleteBook(Book book) async {
    await _bookRepo.delete(book.id!);
    await loadBooks();
  }
}
