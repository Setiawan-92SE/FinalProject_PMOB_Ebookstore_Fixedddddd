import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../models/category.dart';

/// DatabaseHelper — Singleton SQLite (versi lengkap v3 + Admin methods)
/// Path: lib/database/database_helper.dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'ebookstore.db';
  static const int _dbVersion = 3;

  // Tables
  static const String tableBooks = 'books';
  static const String tableUsers = 'users';
  static const String tableCategories = 'categories';
  static const String tableWishlist = 'wishlist';
  static const String tableCart = 'cart';
  static const String tableOrders = 'orders';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) async => await db.execute('PRAGMA foreign_keys = ON'));
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createAllTables(db);
    await _insertSeedData(db);
  }

  Future<void> _onUpgrade(Database db, int old, int nv) async {
    for (final t in [
      tableOrders,
      tableCart,
      tableWishlist,
      tableUsers,
      tableBooks,
      tableCategories
    ]) {
      await db.execute('DROP TABLE IF EXISTS $t');
    }
    await _createAllTables(db);
    await _insertSeedData(db);
  }

  Future<void> _createAllTables(Database db) async {
    await db.execute('''CREATE TABLE $tableCategories (
      id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT NOT NULL UNIQUE,
      deskripsi TEXT, is_active INTEGER NOT NULL DEFAULT 1)''');

    await db.execute('''CREATE TABLE $tableBooks (
      id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT NOT NULL,
      penulis TEXT NOT NULL, kategori TEXT NOT NULL, harga REAL NOT NULL DEFAULT 0,
      deskripsi TEXT NOT NULL, cover_url TEXT, stok INTEGER NOT NULL DEFAULT 0,
      status TEXT NOT NULL DEFAULT 'pending', seller_id INTEGER)''');

    await db.execute('''CREATE TABLE $tableUsers (
      id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE, phone TEXT NOT NULL, password TEXT NOT NULL,
      role TEXT NOT NULL DEFAULT 'buyer', is_active INTEGER NOT NULL DEFAULT 1)''');

    await db.execute('''CREATE TABLE $tableWishlist (
      id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL,
      book_id INTEGER NOT NULL, UNIQUE(user_id, book_id))''');

    await db.execute('''CREATE TABLE $tableCart (
      id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL,
      book_id INTEGER NOT NULL, qty INTEGER NOT NULL DEFAULT 1,
      UNIQUE(user_id, book_id))''');

    await db.execute('''CREATE TABLE $tableOrders (
      id INTEGER PRIMARY KEY AUTOINCREMENT, buyer_id INTEGER NOT NULL,
      book_id INTEGER NOT NULL, qty INTEGER NOT NULL DEFAULT 1,
      total REAL NOT NULL DEFAULT 0, status TEXT NOT NULL DEFAULT 'pending',
      created_at TEXT NOT NULL)''');
  }

  Future<void> _insertSeedData(Database db) async {
    final cats = [
      'Fiksi',
      'Non-Fiksi',
      'Pengembangan Diri',
      'Pendidikan',
      'Teknologi',
      'Bisnis'
    ];
    for (final c in cats) {
      await db.insert(tableCategories, {'nama': c, 'is_active': 1},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    final users = [
      {
        'nama': 'Demo Seller',
        'email': 'seller@demo.com',
        'phone': '081234567890',
        'password': 'seller123',
        'role': 'seller',
        'is_active': 1
      },
      {
        'nama': 'Demo Buyer',
        'email': 'buyer@demo.com',
        'phone': '089876543210',
        'password': 'buyer123',
        'role': 'buyer',
        'is_active': 1
      },
      {
        'nama': 'Administrator',
        'email': 'admin@demo.com',
        'phone': '081111111111',
        'password': 'admin123',
        'role': 'admin',
        'is_active': 1
      },
    ];
    for (final u in users) {
      await db.insert(tableUsers, u,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    final books = [
      {
        'judul': 'Laskar Pelangi',
        'penulis': 'Andrea Hirata',
        'kategori': 'Fiksi',
        'harga': 85000.0,
        'deskripsi': 'Novel tentang semangat anak-anak Belitung.',
        'cover_url': null,
        'stok': 50,
        'status': 'approved',
        'seller_id': 1
      },
      {
        'judul': 'Atomic Habits',
        'penulis': 'James Clear',
        'kategori': 'Pengembangan Diri',
        'harga': 120000.0,
        'deskripsi': 'Cara membangun kebiasaan baik.',
        'cover_url': null,
        'stok': 30,
        'status': 'approved',
        'seller_id': 1
      },
      {
        'judul': 'Sapiens',
        'penulis': 'Yuval Noah Harari',
        'kategori': 'Non-Fiksi',
        'harga': 135000.0,
        'deskripsi': 'Sejarah singkat umat manusia.',
        'cover_url': null,
        'stok': 25,
        'status': 'approved',
        'seller_id': 1
      },
      {
        'judul': 'Clean Code',
        'penulis': 'Robert C. Martin',
        'kategori': 'Teknologi',
        'harga': 150000.0,
        'deskripsi': 'Panduan menulis kode bersih.',
        'cover_url': null,
        'stok': 20,
        'status': 'approved',
        'seller_id': 1
      },
      {
        'judul': 'Rich Dad Poor Dad',
        'penulis': 'Robert Kiyosaki',
        'kategori': 'Bisnis',
        'harga': 95000.0,
        'deskripsi': 'Pelajaran keuangan dua sudut pandang.',
        'cover_url': null,
        'stok': 40,
        'status': 'approved',
        'seller_id': 1
      },
      {
        'judul': 'Buku Menunggu Approval',
        'penulis': 'Penulis Baru',
        'kategori': 'Fiksi',
        'harga': 75000.0,
        'deskripsi': 'Contoh buku pending persetujuan admin.',
        'cover_url': null,
        'stok': 10,
        'status': 'pending',
        'seller_id': 1
      },
    ];
    for (final b in books) {
      await db.insert(tableBooks, b,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  // ── AUTH ──────────────────────────────────────────────────────────────────
  Future<User?> login(String email, String password, String role) async {
    final db = await database;
    final r = await db.query(tableUsers,
        where: 'email = ? AND password = ? AND role = ? AND is_active = 1',
        whereArgs: [email.trim().toLowerCase(), password, role],
        limit: 1);
    return r.isEmpty ? null : User.fromMap(r.first);
  }

  Future<int> register(User user) async {
    final db = await database;
    try {
      return await db.insert(tableUsers, user.toMap()..remove('id'),
          conflictAlgorithm: ConflictAlgorithm.fail);
    } catch (_) {
      return -1;
    }
  }

  Future<bool> isEmailExists(String email) async {
    final db = await database;
    final r = await db.query(tableUsers,
        where: 'email = ?', whereArgs: [email.trim().toLowerCase()], limit: 1);
    return r.isNotEmpty;
  }

  // ── CATEGORIES ────────────────────────────────────────────────────────────
  Future<List<BookCategory>> getAllCategories({bool activeOnly = false}) async {
    final db = await database;
    final r = await db.query(tableCategories,
        where: activeOnly ? 'is_active = 1' : null, orderBy: 'nama ASC');
    return r.map((m) => BookCategory.fromMap(m)).toList();
  }

  Future<List<String>> getCategoryNames() async =>
      (await getAllCategories(activeOnly: true)).map((c) => c.nama).toList();

  Future<int> insertCategory(BookCategory cat) async {
    final db = await database;
    try {
      return await db.insert(tableCategories, cat.toMap()..remove('id'),
          conflictAlgorithm: ConflictAlgorithm.fail);
    } catch (_) {
      return -1;
    }
  }

  Future<int> updateCategory(BookCategory cat) async {
    final db = await database;
    return await db.update(tableCategories, cat.toMap(),
        where: 'id = ?', whereArgs: [cat.id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(tableCategories, where: 'id = ?', whereArgs: [id]);
  }

  // ── BOOKS ─────────────────────────────────────────────────────────────────
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert(tableBooks, book.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getAllBooks({String? status}) async {
    final db = await database;
    final r = await db.query(tableBooks,
        where: status != null ? 'status = ?' : null,
        whereArgs: status != null ? [status] : null,
        orderBy: 'judul ASC');
    return r.map((m) => Book.fromMap(m)).toList();
  }

  Future<List<Book>> getBooksBySeller(int sellerId, {String? status}) async {
    final db = await database;
    String where = 'seller_id = ?';
    List<dynamic> args = [sellerId];
    if (status != null) {
      where += ' AND status = ?';
      args.add(status);
    }
    final r = await db.query(tableBooks,
        where: where, whereArgs: args, orderBy: 'judul ASC');
    return r.map((m) => Book.fromMap(m)).toList();
  }

  Future<List<Book>> searchBooks(String kw) async {
    final db = await database;
    final r = await db.query(tableBooks,
        where: "(judul LIKE ? OR penulis LIKE ?) AND status = 'approved'",
        whereArgs: ['%$kw%', '%$kw%'],
        orderBy: 'judul ASC');
    return r.map((m) => Book.fromMap(m)).toList();
  }

  Future<List<Book>> getBooksByKategori(String kategori) async {
    final db = await database;
    final r = await db.query(tableBooks,
        where: "kategori = ? AND status = 'approved'",
        whereArgs: [kategori],
        orderBy: 'judul ASC');
    return r.map((m) => Book.fromMap(m)).toList();
  }

  Future<Book?> getBookById(int id) async {
    final db = await database;
    final r =
        await db.query(tableBooks, where: 'id = ?', whereArgs: [id], limit: 1);
    return r.isEmpty ? null : Book.fromMap(r.first);
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(tableBooks, book.toMap(),
        where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> updateBookStatus(int bookId, String status) async {
    final db = await database;
    return await db.update(tableBooks, {'status': status},
        where: 'id = ?', whereArgs: [bookId]);
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(tableBooks, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countBooks({String? status}) async {
    final db = await database;
    final r = await db.rawQuery('SELECT COUNT(*) as total FROM $tableBooks'
        '${status != null ? " WHERE status=\'$status\'" : ""}');
    return Sqflite.firstIntValue(r) ?? 0;
  }

  // ── USERS (Admin) ─────────────────────────────────────────────────────────
  Future<List<User>> getAllUsers({String? role}) async {
    final db = await database;
    final r = await db.query(tableUsers,
        where: role != null ? 'role = ?' : null,
        whereArgs: role != null ? [role] : null,
        orderBy: 'nama ASC');
    return r.map((m) => User.fromMap(m)).toList();
  }

  Future<int> updateUserStatus(int userId, bool isActive) async {
    final db = await database;
    return await db.update(tableUsers, {'is_active': isActive ? 1 : 0},
        where: 'id = ?', whereArgs: [userId]);
  }

  /// ✅ Hapus user (Admin)
  Future<int> deleteUser(int userId) async {
    final db = await database;
    return await db.delete(tableUsers, where: 'id = ?', whereArgs: [userId]);
  }

  Future<int> countUsers({String? role}) async {
    final db = await database;
    final r = await db.rawQuery('SELECT COUNT(*) as total FROM $tableUsers'
        '${role != null ? " WHERE role=\'$role\'" : ""}');
    return Sqflite.firstIntValue(r) ?? 0;
  }

  // ── WISHLIST ──────────────────────────────────────────────────────────────
  Future<int> addToWishlist(int userId, int bookId) async {
    final db = await database;
    try {
      return await db.insert(
          tableWishlist, {'user_id': userId, 'book_id': bookId},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (_) {
      return -1;
    }
  }

  Future<int> removeFromWishlist(int userId, int bookId) async {
    final db = await database;
    return await db.delete(tableWishlist,
        where: 'user_id = ? AND book_id = ?', whereArgs: [userId, bookId]);
  }

  Future<bool> isInWishlist(int userId, int bookId) async {
    final db = await database;
    final r = await db.query(tableWishlist,
        where: 'user_id = ? AND book_id = ?',
        whereArgs: [userId, bookId],
        limit: 1);
    return r.isNotEmpty;
  }

  Future<List<Book>> getWishlistBooks(int userId) async {
    final db = await database;
    final r = await db.rawQuery('''
      SELECT b.* FROM $tableBooks b
      INNER JOIN $tableWishlist w ON b.id = w.book_id
      WHERE w.user_id = ? AND b.status = 'approved'
      ORDER BY b.judul ASC''', [userId]);
    return r.map((m) => Book.fromMap(m)).toList();
  }

  // ── CART ──────────────────────────────────────────────────────────────────
  Future<int> addToCart(int userId, int bookId, {int qty = 1}) async {
    final db = await database;
    final ex = await db.query(tableCart,
        where: 'user_id = ? AND book_id = ?',
        whereArgs: [userId, bookId],
        limit: 1);
    if (ex.isNotEmpty) {
      final nq = (ex.first['qty'] as int) + qty;
      return await db.update(tableCart, {'qty': nq},
          where: 'user_id = ? AND book_id = ?', whereArgs: [userId, bookId]);
    }
    return await db.insert(
        tableCart, {'user_id': userId, 'book_id': bookId, 'qty': qty},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateCartQty(int userId, int bookId, int qty) async {
    final db = await database;
    if (qty <= 0)
      return await db.delete(tableCart,
          where: 'user_id = ? AND book_id = ?', whereArgs: [userId, bookId]);
    return await db.update(tableCart, {'qty': qty},
        where: 'user_id = ? AND book_id = ?', whereArgs: [userId, bookId]);
  }

  Future<int> removeFromCart(int userId, int bookId) async {
    final db = await database;
    return await db.delete(tableCart,
        where: 'user_id = ? AND book_id = ?', whereArgs: [userId, bookId]);
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT b.*, c.qty as cart_qty FROM $tableBooks b
      INNER JOIN $tableCart c ON b.id = c.book_id
      WHERE c.user_id = ? AND b.status = 'approved'
      ORDER BY b.judul ASC''', [userId]);
  }

  Future<int> clearCart(int userId) async {
    final db = await database;
    return await db
        .delete(tableCart, where: 'user_id = ?', whereArgs: [userId]);
  }

  // ── ORDERS ────────────────────────────────────────────────────────────────
  Future<int> createOrder(
      int buyerId, int bookId, int qty, double total) async {
    final db = await database;
    return await db.insert(tableOrders, {
      'buyer_id': buyerId,
      'book_id': bookId,
      'qty': qty,
      'total': total,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getOrdersByBuyer(int buyerId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT o.*, b.judul as book_judul FROM $tableOrders o
      INNER JOIN $tableBooks b ON o.book_id = b.id
      WHERE o.buyer_id = ? ORDER BY o.created_at DESC''', [buyerId]);
  }

  Future<List<Map<String, dynamic>>> getOrdersBySeller(int sellerId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT o.*, b.judul as book_judul, u.nama as buyer_name
      FROM $tableOrders o
      INNER JOIN $tableBooks b ON o.book_id = b.id
      INNER JOIN $tableUsers u ON o.buyer_id = u.id
      WHERE b.seller_id = ? ORDER BY o.created_at DESC''', [sellerId]);
  }

  Future<int> updateOrderStatus(int orderId, String status) async {
    final db = await database;
    return await db.update(tableOrders, {'status': status},
        where: 'id = ?', whereArgs: [orderId]);
  }

  /// ✅ Admin: ambil semua pesanan terbaru (lintas seller)
  Future<List<Map<String, dynamic>>> getAllOrdersAdmin({int limit = 20}) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT o.*, b.judul as book_judul, u.nama as buyer_name
      FROM $tableOrders o
      INNER JOIN $tableBooks b ON o.book_id = b.id
      INNER JOIN $tableUsers u ON o.buyer_id = u.id
      ORDER BY o.created_at DESC
      LIMIT $limit''');
  }

  // ── ANALYTICS ─────────────────────────────────────────────────────────────
  Future<Map<String, int>> getAnalyticsCounts() async {
    final db = await database;
    final ordR = await db.rawQuery('SELECT COUNT(*) as t FROM $tableOrders');
    final revR = await db.rawQuery(
        "SELECT SUM(total) as t FROM $tableOrders WHERE status='selesai'");
    return {
      'totalUsers': await countUsers(),
      'totalSellers': await countUsers(role: 'seller'),
      'totalBuyers': await countUsers(role: 'buyer'),
      'totalBooks': await countBooks(),
      'approvedBooks': await countBooks(status: 'approved'),
      'pendingBooks': await countBooks(status: 'pending'),
      'totalOrders': Sqflite.firstIntValue(ordR) ?? 0,
      'revenue': ((revR.first['t'] ?? 0) as num).toInt(),
    };
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}