import '../database/database.helper.dart';

class OrderRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<int> create(int buyerId, int bookId, int qty, double total) => _db.createOrder(buyerId, bookId, qty, total);
  Future<List<Map<String, dynamic>>> getByBuyer(int buyerId) => _db.getOrdersByBuyer(buyerId);
  Future<List<Map<String, dynamic>>> getBySeller(int sellerId) => _db.getOrdersBySeller(sellerId);
  Future<List<Map<String, dynamic>>> getAllAdmin({int limit = 20}) => _db.getAllOrdersAdmin(limit: limit);
  Future<int> updateStatus(int orderId, String status) => _db.updateOrderStatus(orderId, status);
  Future<int> updatePaymentStatus(int orderId, String paymentStatus) => _db.updatePaymentStatus(orderId, paymentStatus);
  Future<int> updatePaymentAndStatus(int orderId, String paymentStatus, String status) => _db.updatePaymentAndStatus(orderId, paymentStatus, status);
  Future<List<Map<String, dynamic>>> getMonthlyRevenueAll() => _db.getMonthlyRevenueAll();
  Future<List<Map<String, dynamic>>> getMonthlyRevenueBySeller(int sellerId) => _db.getMonthlyRevenueBySeller(sellerId);
}
