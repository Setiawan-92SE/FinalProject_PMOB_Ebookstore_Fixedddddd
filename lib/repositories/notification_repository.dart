import '../database/database.helper.dart';
import '../models/order_notification.dart';

class NotificationRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<int> create(int userId, String title, String message,
          {String type = 'info', int? relatedOrderId}) =>
      _db.createNotification(userId, title, message,
          type: type, relatedOrderId: relatedOrderId);

  Future<List<OrderNotification>> getByUser(int userId) async {
    final rows = await _db.getNotifications(userId);
    return rows.map((m) => OrderNotification.fromMap(m)).toList();
  }

  Future<int> getUnreadCount(int userId) =>
      _db.getUnreadNotificationCount(userId);

  Future<int> markAsRead(int notificationId) =>
      _db.markNotificationRead(notificationId);

  Future<int> markAllAsRead(int userId) =>
      _db.markAllNotificationsRead(userId);
}
