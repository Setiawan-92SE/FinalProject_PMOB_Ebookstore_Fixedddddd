import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class BookFormViewModel extends ChangeNotifier {
  final BookRepository _bookRepo = BookRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> saveBook(Book book, bool isEditMode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      int result;
      if (isEditMode) {
        result = await _bookRepo.update(book);
      } else {
        result = await _bookRepo.insert(book);
      }

      _isLoading = false;
      notifyListeners();

      if (result > 0) {
        return true;
      } else {
        _error = 'Gagal menyimpan data.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBook(int bookId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _bookRepo.delete(bookId);
      _isLoading = false;
      notifyListeners();
      return result > 0;
    } catch (e) {
      _isLoading = false;
      _error = 'Gagal menghapus: $e';
      notifyListeners();
      return false;
    }
  }
}
