import 'package:flutter/foundation.dart';
import '../../repositories/notification_repository.dart';
import '../../models/order_notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repo = NotificationRepository();

  List<OrderNotification> _notifications = [];
  List<OrderNotification> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  bool _loading = true;
  bool get loading => _loading;

  Future<void> load(int userId) async {
    _loading = true;
    notifyListeners();

    _notifications = await _repo.getByUser(userId);
    _unreadCount = await _repo.getUnreadCount(userId);

    _loading = false;
    notifyListeners();
  }

  Future<void> markAsRead(int notificationId, int userId) async {
    await _repo.markAsRead(notificationId);
    await load(userId);
  }

  Future<void> markAllAsRead(int userId) async {
    await _repo.markAllAsRead(userId);
    await load(userId);
  }

  Future<void> refreshUnreadCount(int userId) async {
    _unreadCount = await _repo.getUnreadCount(userId);
    notifyListeners();
  }
}
