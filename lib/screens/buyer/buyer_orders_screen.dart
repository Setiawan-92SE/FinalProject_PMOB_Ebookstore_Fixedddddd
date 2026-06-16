import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../viewmodels/buyer/buyer_orders_viewmodel.dart';

class BuyerOrdersScreen extends StatefulWidget {
  final User currentUser;
  const BuyerOrdersScreen({super.key, required this.currentUser});
  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen> {
  final _viewModel = BuyerOrdersViewModel();
  final _filters = ['Semua', 'Pending', 'Dikonfirmasi', 'Selesai', 'Dibatalkan'];

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

  void _showPaymentDialog(Map<String, dynamic> order) {
    final total = (order['total'] as num).toDouble();
    final orderId = order['id'] as int;
    final paymentMethod = ValueNotifier<String>('M-Banking');
    final accountCtrl = TextEditingController();
    final pinCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Row(children: [
                Icon(Icons.payment, color: Color(0xFFB8973A), size: 22),
                SizedBox(width: 8),
                Text('Pembayaran',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
              ]),
              content: Form(
                  key: formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Metode Pembayaran',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13))),
                    const SizedBox(height: 6),
                    ValueListenableBuilder<String>(
                        valueListenable: paymentMethod,
                        builder: (_, pm, __) => Row(children: [
                              Expanded(
                                  child: _MethodChip(
                                      label: 'M-Banking',
                                      selected: pm == 'M-Banking',
                                      onTap: () =>
                                          paymentMethod.value = 'M-Banking')),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: _MethodChip(
                                      label: 'E-Wallet',
                                      selected: pm == 'E-Wallet',
                                      onTap: () =>
                                          paymentMethod.value = 'E-Wallet')),
                            ])),
                    const SizedBox(height: 14),
                    TextFormField(
                        controller: accountCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nomor ${paymentMethod.value}',
                          labelStyle:
                              const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF0F0F0F),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFB8973A))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: const Color(0xFFB8973A)
                                      .withValues(alpha: 0.3))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFB8973A))),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Masukkan nomor' : null),
                    const SizedBox(height: 12),
                    Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color(0xFF0F0F0F),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFFB8973A)
                                    .withValues(alpha: 0.3))),
                        child: Row(children: [
                          const Icon(Icons.receipt_long,
                              color: Color(0xFFB8973A), size: 18),
                          const SizedBox(width: 8),
                          const Text('Total Pembayaran',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 13)),
                          const Spacer(),
                          Text('Rp ${_fmt(total.toInt())}',
                              style: const TextStyle(
                                  color: Color(0xFFB8973A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ])),
                    const SizedBox(height: 12),
                    TextFormField(
                        controller: pinCtrl,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'PIN',
                          labelStyle:
                              const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF0F0F0F),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFB8973A))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: const Color(0xFFB8973A)
                                      .withValues(alpha: 0.3))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFB8973A))),
                          counterStyle:
                              const TextStyle(color: Colors.white38),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.length < 4)
                            ? 'PIN minimal 4 digit'
                            : null),
                  ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Batal',
                        style: TextStyle(color: Colors.white54))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8973A),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      await _viewModel.payOrder(
                          orderId, accountCtrl.text, pinCtrl.text);
                      await _viewModel.refresh(widget.currentUser.id!);
                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Pembayaran berhasil!'),
                          backgroundColor: const Color(0xFFB8973A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))));
                    },
                    child: const Text('Bayar')),
              ],
            ));
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

  @override
  Widget build(BuildContext context) {
    final orders = _viewModel.filtered;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(children: [
              const Text('Pesanan Saya',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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
                  child: Text('${orders.length} pesanan',
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                  color:
                                      sel ? Colors.black : Colors.white60,
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
                : orders.isEmpty
                    ? Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Icon(Icons.receipt_long_outlined,
                                color: Colors.white12, size: 60),
                            const SizedBox(height: 12),
                            Text(
                                'Belum ada pesanan',
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 14)),
                          ]))
                    : RefreshIndicator(
                        color: const Color(0xFFB8973A),
                        backgroundColor: const Color(0xFF1A1A1A),
                        onRefresh: () =>
                            _viewModel.refresh(widget.currentUser.id!),
                        child: ListView.separated(
                            padding:
                                const EdgeInsets.fromLTRB(24, 4, 24, 24),
                            itemCount: orders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) =>
                                _OrderCard(
                                    order: orders[i],
                                    onPay: _showPaymentDialog)))),
      ])),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final void Function(Map<String, dynamic>) onPay;

  const _OrderCard({required this.order, required this.onPay});

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

  String get _statusLabel {
    switch (order['status']) {
      case 'pending':
        return 'Menunggu';
      case 'dikonfirmasi':
        return 'Dikonfirmasi';
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return order['status'] ?? '-';
    }
  }

  String get _paymentLabel {
    switch (order['payment_status']) {
      case 'lunas':
        return 'Lunas';
      case 'belum_bayar':
        return 'Belum Dibayar';
      default:
        return order['payment_status'] ?? '-';
    }
  }

  Color get _paymentColor {
    switch (order['payment_status']) {
      case 'lunas':
        return Colors.green;
      case 'belum_bayar':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = (order['total'] as num).toDouble();
    final qty = order['qty'] as int;
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(_statusLabel.toUpperCase(),
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
          Text(order['book_penulis'] ?? '-',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13)),
          const Spacer(),
          Text('× $qty',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          _PaymentBadge(
              label: _paymentLabel, color: _paymentColor),
          const Spacer(),
          Text('Rp ${_fmt(total.toInt())}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text(_fmtDate(order['created_at'] ?? ''),
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11)),
          const Spacer(),
        ]),
        if (order['status'] == 'dikonfirmasi' &&
            order['payment_status'] == 'belum_bayar') ...[
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () => onPay(order),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8973A),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  child: const Text('Bayar Sekarang'))),
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

class _MethodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MethodChip(
      {required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFB8973A).withValues(alpha: 0.15)
                    : const Color(0xFF0F0F0F),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: selected
                        ? const Color(0xFFB8973A)
                        : const Color(0xFFB8973A).withValues(alpha: 0.2))),
            child: Center(
                child: Text(label,
                    style: TextStyle(
                        color: selected
                            ? const Color(0xFFB8973A)
                            : Colors.white54,
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.normal)))));
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
