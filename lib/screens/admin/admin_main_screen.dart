import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user.dart';
import 'admin_dashboard_screen.dart';
import 'admin_users_screen.dart';
import 'admin_books_screen.dart';
import 'admin_profile_screen.dart';

/// AdminMainScreen — Shell utama Admin dengan 4 tab NavigationBar
/// Path: lib/screens/admin/admin_main_screen.dart
class AdminMainScreen extends StatefulWidget {
  final User currentUser;
  const AdminMainScreen({super.key, required this.currentUser});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _idx = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AdminDashboardScreen(currentUser: widget.currentUser),
      AdminUsersScreen(currentUser: widget.currentUser),
      AdminBooksScreen(currentUser: widget.currentUser),
      AdminProfileScreen(currentUser: widget.currentUser),
    ];
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFFB8973A)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group, color: Color(0xFFB8973A)),
            label: 'Pengguna',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: Color(0xFFB8973A)),
            label: 'Daftar Buku',
          ),
          NavigationDestination(
            icon: Icon(Icons.manage_accounts_outlined),
            selectedIcon: Icon(Icons.manage_accounts, color: Color(0xFFB8973A)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}