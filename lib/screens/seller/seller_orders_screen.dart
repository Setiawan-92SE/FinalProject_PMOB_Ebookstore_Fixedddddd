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
  final _filters = ['Semua', 'Pending', 'Dikonfirmasi', 'Selesai', 'Dibatalkan'];

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
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status diperbarui: $status'),
        backgroundColor: const Color(0xFFB8973A),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  void _showDetail(Map<String, dynamic> order) {
    final total = (order['total'] as num).toDouble();
    final qty = order['qty'] as int;
    final bookHarga = (order['book_harga'] as num?)?.toDouble() ?? 0;
    final paymentStatus = order['payment_status'] as String? ?? 'belum_bayar';
    final paymentMethod = order['payment_method'] as String?;
    final paymentAccount = order['payment_account'] as String?;

    showDialog(
        context: context,
        builder: (ctx) {
      final screen = MediaQuery.of(ctx);
      final hPad = screen.size.width > 600 ? 40.0 : 20.0;
      return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          insetPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
          contentPadding: EdgeInsets.fromLTRB(
              24, 20, 24, 12 + screen.viewInsets.bottom),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Row(children: [
            const Icon(Icons.receipt, color: Color(0xFFB8973A), size: 22),
            const SizedBox(width: 8),
            Text('ORD-${order['id']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
          ]),
          content: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min, children: [
            _detailRow('Status',
                '${(order["status"] ?? "").toString().toUpperCase()}'),
            const Divider(
                color: Color(0xFFB8973A), height: 20, thickness: 0.3),
            _detailRow('Pembeli', order['buyer_name'] ?? '-'),
            _detailRow('Email', order['buyer_email'] ?? '-'),
            _detailRow('Telepon', order['buyer_phone'] ?? '-'),
            const Divider(
                color: Color(0xFFB8973A), height: 20, thickness: 0.3),
            _detailRow('Buku', order['book_judul'] ?? '-'),
            _detailRow('Penulis', order['book_penulis'] ?? '-'),
            _detailRow('Harga Satuan', 'Rp ${_fmt(bookHarga.toInt())}'),
            _detailRow('Jumlah', '$qty'),
            _detailRow('Total', 'Rp ${_fmt(total.toInt())}',
                isBold: true),
            const Divider(
                color: Color(0xFFB8973A), height: 20, thickness: 0.3),
            _detailRow(
              'Status Pembayaran',
              paymentStatus == 'lunas' ? 'Lunas' : 'Belum Dibayar',
              valueColor: paymentStatus == 'lunas'
                  ? Colors.green
                  : Colors.orange,
            ),
            if (paymentMethod != null && paymentStatus == 'lunas') ...[
              _detailRow('Metode', paymentMethod),
              if (paymentAccount != null && paymentAccount.isNotEmpty)
                _detailRow('Akun', paymentAccount),
            ],
            const SizedBox(height: 8),
            Text('Pesanan: ${_fmtDate(order["created_at"] ?? "")}',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 11)),
          ])),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup',
                    style: TextStyle(color: Color(0xFFB8973A)))),
          ]);
    });
  }

  Widget _detailRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 110,
                  child: Text(label,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13))),
              Expanded(
                  child: Text(value,
                      style: TextStyle(
                          color: valueColor ?? Colors.white,
                          fontSize: 13,
                          fontWeight:
                              isBold ? FontWeight.w700 : FontWeight.normal))),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
          child: Column(children: [
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
                          color: const Color(0xFFB8973A)
                              .withValues(alpha: 0.3))),
                  child: Text('${_viewModel.filtered.length} pesanan',
                      style: const TextStyle(
                          color: Color(0xFFB8973A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
            ])),
        const SizedBox(height: 12),
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
                                  color: sel
                                      ? Colors.black
                                      : Colors.white60,
                                  fontSize: 12,
                                  fontWeight: sel
                                      ? FontWeight.w700
                                      : FontWeight.normal))));
                })),
        const SizedBox(height: 10),
        Expanded(
            child: _viewModel.loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFB8973A)))
                : _viewModel.filtered.isEmpty
                    ? Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Icon(Icons.receipt_long_outlined,
                                color: Colors.white12, size: 60),
                            const SizedBox(height: 12),
                            Text(
                                'Tidak ada pesanan "${_filters[_viewModel.filterIdx]}"',
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 14)),
                          ]))
                    : RefreshIndicator(
                        color: const Color(0xFFB8973A),
                        backgroundColor: const Color(0xFF1A1A1A),
                        onRefresh: _viewModel.load,
                        child: ListView.separated(
                            padding:
                                const EdgeInsets.fromLTRB(20, 4, 20, 24),
                            itemCount: _viewModel.filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) => _OrderCard(
                                order: _viewModel.filtered[i],
                                onTap: () =>
                                    _showDetail(_viewModel.filtered[i]),
                                onUpdateStatus: (s) => _updateStatus(
                                    _viewModel.filtered[i]['id'] as int,
                                    s))))),
      ])),
    );
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

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;
  final void Function(String) onUpdateStatus;
  const _OrderCard(
      {required this.order,
      required this.onTap,
      required this.onUpdateStatus});

  Color get _statusColor {
    switch (order['status']) {
      case 'pending':
        return Colors.orange;
      case 'dikonfirmasi':
        return Colors.teal;
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
    final paymentStatus = order['payment_status'] as String? ?? 'belum_bayar';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _statusColor.withValues(alpha: 0.2)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('ORD-${order['id']}',
                    style: const TextStyle(
                        color: Color(0xFFB8973A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
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
                const Icon(Icons.menu_book_outlined,
                    color: Colors.white38, size: 15),
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
                const Icon(Icons.person_outline,
                    color: Colors.white38, size: 15),
                const SizedBox(width: 6),
                Text(order['buyer_name'] ?? '-',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13)),
                const Spacer(),
                Text('× ${order['qty']}',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                _PaymentBadge(
                  label: paymentStatus == 'lunas'
                      ? 'Lunas'
                      : 'Belum Dibayar',
                  color: paymentStatus == 'lunas'
                      ? Colors.green
                      : Colors.orange,
                ),
                if (paymentStatus == 'lunas' && order['payment_method'] != null) ...[
                  const SizedBox(width: 8),
                  _PaymentBadge(
                    label: order['payment_method'] as String,
                    color: const Color(0xFFB8973A),
                  ),
                ],
                const Spacer(),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text(_fmtDate(order['created_at'] ?? ''),
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 11)),
                const Spacer(),
                Text('Rp ${_fmt(total.toInt())}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.info_outline,
                    color: Color(0xFFB8973A), size: 13),
                const SizedBox(width: 4),
                Text('Tap untuk detail',
                    style: TextStyle(
                        color: const Color(0xFFB8973A).withValues(alpha: 0.6),
                        fontSize: 11)),
                const Spacer(),
              ]),
              // Action buttons
              if (status == 'pending') ...[
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: _Btn(
                          label: 'Tolak',
                          color: Colors.red,
                          onTap: () => onUpdateStatus('dibatalkan'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _Btn(
                          label: 'Konfirmasi',
                          color: Colors.teal,
                          onTap: () => onUpdateStatus('dikonfirmasi'))),
                ]),
              ],
            ]),
      ),
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

class _PaymentBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _PaymentBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700)));
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
              textStyle: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700)),
          child: Text(label)));
}
