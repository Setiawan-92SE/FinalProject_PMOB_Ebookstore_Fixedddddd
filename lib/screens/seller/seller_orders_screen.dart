import 'package:flutter/material.dart';
import '../../viewmodels/seller/seller_orders_viewmodel.dart';
import '../../models/user.dart';

/// SellerOrdersScreen — Daftar Pesanan Seller (dari DB)
/// Path: lib/screens/seller/seller_orders_screen.dart
class SellerOrdersScreen extends StatefulWidget {
  final User currentUser;
  const SellerOrdersScreen({super.key, required this.currentUser});
  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  final _viewModel = SellerOrdersViewModel();
  final _filters = ['Semua', 'Pending', 'Diproses', 'Selesai', 'Dibatalkan'];

  @override
  void initState() {
    super.initState();
    _viewModel.init(widget.currentUser);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.load();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(int orderId, String status) async {
    await _viewModel.updateStatus(orderId, status);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status diperbarui: $status'),
        backgroundColor: const Color(0xFFB8973A),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
          child: Column(children: [
        // Header
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              const Text('Daftar Pesanan',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              const Color(0xFFB8973A).withValues(alpha: 0.3))),
                  child: Text('${_viewModel.filtered.length} pesanan',
                      style: const TextStyle(
                          color: Color(0xFFB8973A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
            ])),
        const SizedBox(height: 12),
        // Filter chips
        SizedBox(
            height: 36,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final sel = _viewModel.filterIdx == i;
                  return GestureDetector(
                      onTap: () => _viewModel.setFilter(i),
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFFB8973A)
                                  : const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: sel
                                      ? const Color(0xFFB8973A)
                                      : const Color(0xFFB8973A)
                                          .withValues(alpha: 0.2))),
                          child: Text(_filters[i],
                              style: TextStyle(
                                  color: sel ? Colors.black : Colors.white60,
                                  fontSize: 12,
                                  fontWeight: sel
                                      ? FontWeight.w700
                                      : FontWeight.normal))));
                })),
        const SizedBox(height: 10),
        // List
        Expanded(
            child: _viewModel.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB8973A)))
                : _viewModel.filtered.isEmpty
                    ? Center(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.receipt_long_outlined,
                            color: Colors.white12, size: 60),
                        const SizedBox(height: 12),
                        Text('Tidak ada pesanan "${_filters[_viewModel.filterIdx]}"',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 14)),
                      ]))
                    : RefreshIndicator(
                        color: const Color(0xFFB8973A),
                        backgroundColor: const Color(0xFF1A1A1A),
                        onRefresh: _viewModel.load,
                        child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                            itemCount: _viewModel.filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) => _OrderCard(
                                order: _viewModel.filtered[i],
                                onUpdateStatus: (s) => _updateStatus(
                                    _viewModel.filtered[i]['id'] as int, s))))),
      ])),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final void Function(String) onUpdateStatus;
  const _OrderCard({required this.order, required this.onUpdateStatus});

  Color get _statusColor {
    switch (order['status']) {
      case 'pending':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = (order['total'] as num).toDouble();
    final status = order['status'] as String;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('ORD-${order['id']}',
              style: const TextStyle(
                  color: Color(0xFFB8973A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(status.toUpperCase(),
                  style: TextStyle(
                      color: _statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.menu_book_outlined, color: Colors.white38, size: 15),
          const SizedBox(width: 6),
          Expanded(
              child: Text(order['book_judul'] ?? '-',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          const Icon(Icons.person_outline, color: Colors.white38, size: 15),
          const SizedBox(width: 6),
          Text(order['buyer_name'] ?? '-',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
          const Spacer(),
          Text('× ${order['qty']}',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text(_fmtDate(order['created_at'] ?? ''),
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
          const Spacer(),
          Text('Rp ${_fmt(total.toInt())}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        ]),
        // Action buttons
        if (status == 'pending' || status == 'diproses') ...[
          const SizedBox(height: 10),
          Row(children: [
            if (status == 'pending') ...[
              Expanded(
                  child: _Btn(
                      label: 'Tolak',
                      color: Colors.red,
                      onTap: () => onUpdateStatus('dibatalkan'))),
              const SizedBox(width: 8),
              Expanded(
                  child: _Btn(
                      label: 'Proses',
                      color: Colors.blue,
                      onTap: () => onUpdateStatus('diproses'))),
            ],
            if (status == 'diproses') ...[
              Expanded(
                  child: _Btn(
                      label: 'Selesai',
                      color: Colors.green,
                      onTap: () => onUpdateStatus('selesai'))),
            ],
          ]),
        ],
      ]),
    );
  }

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 36,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          child: Text(label)));
}
