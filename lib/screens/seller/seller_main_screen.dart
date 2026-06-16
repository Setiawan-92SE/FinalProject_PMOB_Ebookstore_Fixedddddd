import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user.dart';
import 'seller_book_list_screen.dart';
import 'seller_orders_screen.dart';
import 'seller_revenue_screen.dart';
import 'seller_profile_screen.dart';
import 'seller_auth_screen.dart';

/// SellerMainScreen — Shell utama Seller dengan 4 tab NavigationBar
/// Path: lib/screens/seller/seller_main_screen.dart
class SellerMainScreen extends StatefulWidget {
  final User currentUser;
  const SellerMainScreen({super.key, required this.currentUser});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _idx = 0;
  int _ordersRefreshKey = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _buildScreens();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  void _buildScreens() {
    _screens = [
      SellerBookListScreen(currentUser: widget.currentUser),
      SellerOrdersScreen(
          key: ValueKey('orders_$_ordersRefreshKey'),
          currentUser: widget.currentUser),
      SellerRevenueScreen(currentUser: widget.currentUser),
      SellerProfileScreen(currentUser: widget.currentUser),
    ];
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Konfirmasi Logout',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text('Apakah Anda yakin ingin keluar?',
            style: TextStyle(color: Colors.white70, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SellerAuthScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFB8973A).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.storefront_outlined,
                color: Color(0xFFB8973A), size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'Halo, ${widget.currentUser.nama.split(' ').first}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFB8973A), size: 22),
            tooltip: 'Logout',
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0F0F0F),
        indicatorColor: const Color(0xFFB8973A).withValues(alpha: 0.2),
        selectedIndex: _idx,
        onDestinationSelected: (i) {
          setState(() {
            if (i == 1) {
              _ordersRefreshKey++;
              _buildScreens();
            }
            _idx = i;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: Color(0xFFB8973A)),
            label: 'Buku Saya',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_outlined),
            selectedIcon: Icon(Icons.receipt, color: Color(0xFFB8973A)),
            label: 'Pesanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money_outlined),
            selectedIcon: Icon(Icons.attach_money, color: Color(0xFFB8973A)),
            label: 'Pendapatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFFB8973A)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
