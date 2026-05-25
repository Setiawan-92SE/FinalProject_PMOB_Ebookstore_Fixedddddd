import '../database/database.helper.dart';
import '../models/book.dart';

class BookRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Book>> getAll({String? status}) => _db.getAllBooks(status: status);
  Future<List<Book>> getBySeller(int sellerId, {String? status}) => _db.getBooksBySeller(sellerId, status: status);
  Future<List<Book>> search(String keyword) => _db.searchBooks(keyword);
  Future<List<Book>> getByCategory(String kategori) => _db.getBooksByKategori(kategori);
  Future<Book?> getById(int id) => _db.getBookById(id);
  Future<int> insert(Book book) => _db.insertBook(book);
  Future<int> update(Book book) => _db.updateBook(book);
  Future<int> updateStatus(int bookId, String status) => _db.updateBookStatus(bookId, status);
  Future<int> delete(int id) => _db.deleteBook(id);
  Future<int> count({String? status}) => _db.countBooks(status: status);
}
