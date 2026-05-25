import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user.dart';
import 'buyer_home_screen.dart';
import 'buyer_catalog_screen.dart';
import 'buyer_cart_screen.dart';
import 'buyer_profile_screen.dart';

/// BuyerMainScreen — shell navbar buyer
/// Path: lib/screens/buyer/buyer_main_screen.dart
class BuyerMainScreen extends StatefulWidget {
  final User currentUser;
  const BuyerMainScreen({super.key, required this.currentUser});

  @override
  State<BuyerMainScreen> createState() => _BuyerMainScreenState();
}

class _BuyerMainScreenState extends State<BuyerMainScreen> {
  int _idx = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      BuyerHomeScreen(
          currentUser: widget.currentUser,
          onTabChange: (i) => setState(() => _idx = i)),
      BuyerCatalogScreen(currentUser: widget.currentUser),
      BuyerCartScreen(currentUser: widget.currentUser),
      BuyerProfileScreen(currentUser: widget.currentUser),
    ];
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0F0F0F),
        indicatorColor: const Color(0xFFB8973A).withValues(alpha: 0.2),
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xFFB8973A)),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view, color: Color(0xFFB8973A)),
              label: 'Katalog'),
          NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart, color: Color(0xFFB8973A)),
              label: 'Keranjang'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: Color(0xFFB8973A)),
              label: 'Profil'),
        ],
      ),
    );
  }
}
