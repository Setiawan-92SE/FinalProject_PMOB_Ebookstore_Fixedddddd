class OrderNotification {
  int? id;
  int userId;
  String title;
  String message;
  String type;
  int? relatedOrderId;
  bool isRead;
  String createdAt;

  OrderNotification({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.type = 'info',
    this.relatedOrderId,
    this.isRead = false,
    required this.createdAt,
  });

  factory OrderNotification.fromMap(Map<String, dynamic> map) =>
      OrderNotification(
        id: map['id'],
        userId: map['user_id'] ?? 0,
        title: map['title'] ?? '',
        message: map['message'] ?? '',
        type: map['type'] ?? 'info',
        relatedOrderId: map['related_order_id'],
        isRead: (map['is_read'] ?? 0) == 1,
        createdAt: map['created_at'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        'related_order_id': relatedOrderId,
        'is_read': isRead ? 1 : 0,
        'created_at': createdAt,
      };
}
