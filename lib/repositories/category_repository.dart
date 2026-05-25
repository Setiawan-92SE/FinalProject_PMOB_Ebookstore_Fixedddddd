import '../database/database.helper.dart';
import '../models/category.dart';

class CategoryRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<BookCategory>> getAll({bool activeOnly = false}) => _db.getAllCategories(activeOnly: activeOnly);
  Future<List<String>> getNames() => _db.getCategoryNames();
  Future<int> insert(BookCategory cat) => _db.insertCategory(cat);
  Future<int> update(BookCategory cat) => _db.updateCategory(cat);
  Future<int> delete(int id) => _db.deleteCategory(id);
}
