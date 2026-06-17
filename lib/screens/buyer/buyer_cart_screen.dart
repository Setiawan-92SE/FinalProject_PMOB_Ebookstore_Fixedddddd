import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../viewmodels/buyer/buyer_cart_viewmodel.dart';
import 'buyer_orders_screen.dart';

class BuyerCartScreen extends StatefulWidget {
  final User currentUser;
  const BuyerCartScreen({super.key, required this.currentUser});
  @override
  State<BuyerCartScreen> createState() => _BuyerCartScreenState();
}

class _BuyerCartScreenState extends State<BuyerCartScreen> {
  final _viewModel = BuyerCartViewModel();

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

  Future<void> _checkout() async {
    final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              title: const Text('Konfirmasi Checkout',
                  style: TextStyle(color: Colors.white)),
              content: const Text(
                  'Anda akan checkout semua item di keranjang. Lanjutkan?',
                  style: TextStyle(color: Colors.white60)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Batal',
                        style: TextStyle(color: Colors.white54))),
                ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8973A),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text('Checkout')),
              ],
            ));
    if (ok != true) return;
    await _viewModel.checkout(widget.currentUser.id!);
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              title: const Text('Pesanan Berhasil!',
                  style: TextStyle(color: Colors.white)),
              content: const Text(
                  'Pesanan Anda telah dibuat.\nTunggu konfirmasi seller untuk melanjutkan pembayaran.',
                  style: TextStyle(color: Colors.white60)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('OK',
                        style: TextStyle(color: Color(0xFFB8973A))))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(children: [
              const Text('Keranjang',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              if (_viewModel.items.isNotEmpty)
                TextButton(
                    onPressed: () async {
                      await _viewModel.clearCart(widget.currentUser.id!);
                    },
                    child: const Text('Kosongkan',
                        style: TextStyle(color: Colors.red, fontSize: 13))),
              TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BuyerOrdersScreen(
                              currentUser: widget.currentUser))),
                  child: const Text('Riwayat',
                      style:
                          TextStyle(color: Color(0xFFB8973A), fontSize: 13))),
            ])),
        Expanded(
            child: _viewModel.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB8973A)))
                : _viewModel.items.isEmpty
                    ? _EmptyCart()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: _viewModel.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, i) => _CartTile(
                            item: _viewModel.items[i],
                            userId: widget.currentUser.id!,
                            viewModel: _viewModel))),
      ])),
      bottomNavigationBar: _viewModel.items.isNotEmpty
          ? Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 24),
              decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  border: Border(
                      top: BorderSide(
                          color: const Color(0xFFB8973A)
                              .withValues(alpha: 0.15)))),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_viewModel.items.length} item',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14)),
                      Text('Rp ${_fmtD(_viewModel.total)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                    ]),
                const SizedBox(height: 14),
                SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                        onPressed: _checkout,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8973A),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0),
                        child: const Text('Checkout',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)))),
              ]),
            )
          : null,
    );
  }

  String _fmtD(double v) => _fmt(v.toInt());
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

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.shopping_cart_outlined,
            color: Colors.white12, size: 72),
        const SizedBox(height: 16),
        const Text('Keranjang kosong',
            style: TextStyle(color: Colors.white38, fontSize: 16)),
        const SizedBox(height: 8),
        Text('Tambahkan buku dari Katalog',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.25), fontSize: 13)),
      ]));
}

class _CartTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final int userId;
  final BuyerCartViewModel viewModel;
  const _CartTile(
      {required this.item,
      required this.userId,
      required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final qty = item['cart_qty'] as int;
    final harga = (item['harga'] as num).toDouble();
    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFB8973A).withValues(alpha: 0.12))),
        child: Row(children: [
          Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.menu_book_outlined,
                  color: Color(0xFFB8973A), size: 26)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(item['judul'] ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('Rp ${_fmt(harga.toInt())}',
                    style: const TextStyle(
                        color: Color(0xFFB8973A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(children: [
                  _QtyBtn(
                      icon: Icons.remove,
                      onTap: () async {
                        await viewModel.updateQty(
                            userId, item['id'] as int, qty - 1);
                      }),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('$qty',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700))),
                  _QtyBtn(
                      icon: Icons.add,
                      onTap: () async {
                        await viewModel.updateQty(
                            userId, item['id'] as int, qty + 1);
                      }),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      onPressed: () async {
                        await viewModel.removeItem(
                            userId, item['id'] as int);
                      }),
                ]),
              ])),
        ]));
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

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: const Color(0xFFB8973A).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, color: const Color(0xFFB8973A), size: 16)));
}
