import 'package:flutter/foundation.dart';
import '../../models/book.dart';
import '../../models/category.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/category_repository.dart';

class AdminBooksViewModel extends ChangeNotifier {
  final BookRepository _bookRepo = BookRepository();
  final CategoryRepository _catRepo = CategoryRepository();

  List<Book> _pending = [];
  List<Book> get pending => _pending;

  List<Book> _approved = [];
  List<Book> get approved => _approved;

  List<Book> _rejected = [];
  List<Book> get rejected => _rejected;

  List<BookCategory> _categories = [];
  List<BookCategory> get categories => _categories;

  bool _loading = true;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final results = await Future.wait([
      _bookRepo.getAll(status: 'pending'),
      _bookRepo.getAll(status: 'approved'),
      _bookRepo.getAll(status: 'rejected'),
      _catRepo.getAll(),
    ]);

    _pending = results[0] as List<Book>;
    _approved = results[1] as List<Book>;
    _rejected = results[2] as List<Book>;
    _categories = results[3] as List<BookCategory>;
    _loading = false;
    notifyListeners();
  }

  Future<void> approveBook(Book book) async {
    await _bookRepo.updateStatus(book.id!, 'approved');
    await load();
  }

  Future<void> rejectBook(Book book) async {
    await _bookRepo.updateStatus(book.id!, 'rejected');
    await load();
  }

  Future<void> deleteBook(Book book) async {
    await _bookRepo.delete(book.id!);
    await load();
  }

  Future<void> addCategory(String nama, {String? deskripsi}) async {
    final cat = BookCategory(nama: nama, deskripsi: deskripsi);
    await _catRepo.insert(cat);
    await load();
  }

  Future<void> updateCategory(BookCategory cat) async {
    await _catRepo.update(cat);
    await load();
  }

  Future<void> deleteCategory(BookCategory cat) async {
    await _catRepo.delete(cat.id!);
    await load();
  }
}
