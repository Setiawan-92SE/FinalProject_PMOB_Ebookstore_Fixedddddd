import 'package:flutter/material.dart';
import '../../viewmodels/seller/seller_revenue_viewmodel.dart';
import '../../models/user.dart';

/// SellerRevenueScreen — Pendapatan Seller (dari DB)
/// Path: lib/screens/seller/seller_revenue_screen.dart
class SellerRevenueScreen extends StatefulWidget {
  final User currentUser;
  const SellerRevenueScreen({super.key, required this.currentUser});
  @override
  State<SellerRevenueScreen> createState() => _SellerRevenueScreenState();
}

class _SellerRevenueScreenState extends State<SellerRevenueScreen> {
  final _viewModel = SellerRevenueViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init(widget.currentUser);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.load();
    _viewModel.startAutoRefresh();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: SafeArea(
            child: _viewModel.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB8973A)))
                : RefreshIndicator(
                    color: const Color(0xFFB8973A),
                    backgroundColor: const Color(0xFF1A1A1A),
                    onRefresh: _viewModel.load,
                    child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        children: [
                          const Text('Pendapatan',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 20),
                          // Revenue card utama
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFB8973A),
                                        Color(0xFFD4B85A)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      const Icon(Icons.account_balance_wallet,
                                          color: Colors.black54, size: 20),
                                      const SizedBox(width: 8),
                                      const Text('Total Pendapatan',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                    ]),
                                    const SizedBox(height: 8),
                                    Text('Rp ${_fmtInt(_viewModel.totalRevenue)}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 4),
                                    Text('Dari ${_viewModel.doneOrders} pesanan selesai',
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12)),
                                  ])),
                          const SizedBox(height: 16),
                          // Stats row
                          Row(children: [
                            Expanded(
                                child: _StatBox(
                                    'Total Pesanan',
                                    '${_viewModel.totalOrders}',
                                    Icons.receipt_outlined,
                                    Colors.blue)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _StatBox('Pending',
                                    '${_viewModel.pendingOrders}',
                                    Icons.pending_outlined, Colors.orange)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _StatBox('Selesai',
                                    '${_viewModel.doneOrders}',
                                    Icons.check_circle_outline, Colors.green)),
                          ]),
                          const SizedBox(height: 24),
                          // Bar chart dummy
                          const Text('Ringkasan Bulanan',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          _BarChart(data: _viewModel.monthlyRevenue),
                          const SizedBox(height: 24),
                          // Transaction list
                          const Text('Riwayat Transaksi',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          if (_viewModel.orders.isEmpty)
                            Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1A1A1A),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: const Color(0xFFB8973A)
                                            .withValues(alpha: 0.1))),
                                child: const Center(
                                    child: Text('Belum ada transaksi',
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 14))))
                          else
                            ..._viewModel.orders
                                .map((o) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _TransactionTile(order: o)))
                                .toList(),
                        ]))));
  }

  String _fmtInt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatBox(this.label, this.value, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFB8973A).withValues(alpha: 0.1))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 16)),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
      ]));
}

class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const _BarChart({required this.data});

  String _fmtK(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}Jt';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return '$v';
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((d) => d['total'] as int).reduce((a, b) => a > b ? a : b);
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFFB8973A).withValues(alpha: 0.12))),
        child: Column(children: [
          SizedBox(
              height: 110,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: data
                      .map((d) {
                        final amount = d['total'] as int;
                        final ratio = maxVal == 0 ? 0.0 : amount / maxVal;
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (amount > 0)
                                Text(_fmtK(amount),
                                    style: const TextStyle(
                                        color: Color(0xFFB8973A),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600)),
                              if (amount > 0)
                                const SizedBox(height: 4),
                              Container(
                                  width: 28,
                                  height: 90 * ratio.clamp(0.02, 1.0),
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Color(0xFFB8973A),
                                            Color(0xFFD4B85A)
                                          ]),
                                      borderRadius: BorderRadius.circular(5))),
                            ]);
                      })
                      .toList())),
          const SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data
                  .map((d) => Text(d['label'] as String,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11)))
                  .toList()),
        ]));
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> order;
  const _TransactionTile({required this.order});

  Color get _color {
    switch (order['status']) {
      case 'selesai':
        return Colors.green;
      case 'dikonfirmasi':
        return Colors.teal;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = (order['total'] as num).toDouble();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFB8973A).withValues(alpha: 0.1))),
        child: Row(children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.menu_book_outlined, color: _color, size: 20)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(order['book_judul'] ?? '-',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(
                    '${order['buyer_name'] ?? '-'} · ${_fmtDate(order['created_at'] ?? '')}',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 11)),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Rp ${_fmt(total.toInt())}',
                style: const TextStyle(
                    color: Color(0xFFB8973A),
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
            Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: _color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(order['status'] ?? '',
                    style: TextStyle(
                        color: _color,
                        fontSize: 9,
                        fontWeight: FontWeight.w600))),
          ]),
        ]));
  }

  String _fmtDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}/${d.year}';
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
