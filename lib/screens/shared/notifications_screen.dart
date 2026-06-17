import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../viewmodels/shared/notification_viewmodel.dart';

class NotificationsScreen extends StatefulWidget {
  final User currentUser;
  const NotificationsScreen({super.key, required this.currentUser});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _viewModel = NotificationViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.load(widget.currentUser.id!);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifs = _viewModel.notifications;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifikasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          if (notifs.isNotEmpty)
            TextButton(
                onPressed: () async {
                  await _viewModel.markAllAsRead(widget.currentUser.id!);
                },
                child: const Text('Baca Semua',
                    style: TextStyle(color: Color(0xFFB8973A), fontSize: 12))),
        ],
      ),
      body: _viewModel.loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFFB8973A)))
          : notifs.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(Icons.notifications_none,
                        color: Colors.white.withValues(alpha: 0.15), size: 72),
                    const SizedBox(height: 16),
                    Text('Belum ada notifikasi',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 16)),
                  ]))
              : RefreshIndicator(
                  color: const Color(0xFFB8973A),
                  backgroundColor: const Color(0xFF1A1A1A),
                  onRefresh: () =>
                      _viewModel.load(widget.currentUser.id!),
                  child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: notifs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final n = notifs[i];
                        return _NotifTile(
                          notification: n,
                          onTap: () async {
                            if (!n.isRead) {
                              await _viewModel.markAsRead(
                                  n.id!, widget.currentUser.id!);
                            }
                          },
                        );
                      }),
                ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const _NotifTile({required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case 'order_confirmed':
        return Icons.check_circle_outline;
      case 'order_rejected':
        return Icons.cancel_outlined;
      case 'payment_received':
        return Icons.payment;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case 'order_confirmed':
        return Colors.teal;
      case 'order_rejected':
        return Colors.red;
      case 'payment_received':
        return Colors.green;
      default:
        return const Color(0xFFB8973A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF1A1A1A).withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? const Color(0xFFB8973A).withValues(alpha: 0.08)
                  : const Color(0xFFB8973A).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, color: _iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(notification.title,
                            style: TextStyle(
                              color: notification.isRead
                                  ? Colors.white60
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w700,
                            )),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB8973A),
                          ),
                        ),
                    ]),
                    const SizedBox(height: 4),
                    Text(notification.message,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(_fmtDate(notification.createdAt),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.25),
                          fontSize: 10,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
