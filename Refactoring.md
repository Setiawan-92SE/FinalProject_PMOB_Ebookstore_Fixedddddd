# Refactoring Documentation: MVVM Pattern Implementation

## 📋 Overview

Proyek **E-BookStore Flutter** telah direfaktor dari arsitektur **2-Layer Monolith** (UI + Database langsung) menjadi **MVVM (Model-View-ViewModel)** dengan tambahan **Repository Layer**.

### Arsitektur Sebelumnya (Before)

```
┌─────────────────────────────────────┐
│          Screens (UI)                │
│  (StatefulWidget + setState)         │
│         ↓ langsung                   │
│  DatabaseHelper (Singleton SQLite)   │
└─────────────────────────────────────┘
```

**Masalah:**
- UI dan business logic tercampur dalam satu file
- Database dipanggil langsung dari setiap screen (`DatabaseHelper()`)
- State management hanya menggunakan `setState`
- Tidak ada pemisahan tanggung jawab (Separation of Concerns)
- Duplikasi kode antar screen
- Sulit diuji (tight coupling ke database)

### Arsitektur Sesudah (After - MVVM)

```
┌─────────────────────────────────────┐
│   View (Screens) — UI Only          │
│   (ListenableBuilder + ViewModel)    │
└──────────────┬──────────────────────┘
               │ observes / calls
┌──────────────▼──────────────────────┐
│   ViewModel — Business Logic        │
│   (ChangeNotifier + State)          │
└──────────────┬──────────────────────┘
               │ calls
┌──────────────▼──────────────────────┐
│   Repository — Data Access          │
│   (wraps DatabaseHelper)            │
└──────────────┬──────────────────────┘
               │ delegates to
┌──────────────▼──────────────────────┐
│   DatabaseHelper — SQLite           │
│   (Singleton, unchanged)            │
└─────────────────────────────────────┘
```

---

## 📁 Struktur Direktori

### Sebelum (25 file)
```
lib/
  main.dart
  database/database.helper.dart
  models/ (3 files)
  screens/
    welcome_screen.dart
    book_list_screen.dart
    book_detail_screen.dart
    book_form_screen.dart
    admin/ (6 files)
    seller/ (5 files)
    buyer/ (7 files)
```

### Sesudah (51 file)
```
lib/
  main.dart
  database/database.helper.dart          ← unchanged
  models/
    book.dart                            ← unchanged
    category.dart                        ← unchanged
    user.dart                            ← unchanged
  repositories/                          ← NEW LAYER ★
    book_repository.dart
    cart_repository.dart
    category_repository.dart
    order_repository.dart
    user_repository.dart
    wishlist_repository.dart
  viewmodels/                            ← NEW LAYER ★
    book_list_viewmodel.dart
    book_form_viewmodel.dart
    admin/
      admin_login_viewmodel.dart
      admin_dashboard_viewmodel.dart
      admin_users_viewmodel.dart
      admin_books_viewmodel.dart
    seller/
      seller_auth_viewmodel.dart
      seller_book_list_viewmodel.dart
      seller_orders_viewmodel.dart
      seller_revenue_viewmodel.dart
    buyer/
      buyer_auth_viewmodel.dart
      buyer_home_viewmodel.dart
      buyer_catalog_viewmodel.dart
      buyer_book_detail_viewmodel.dart
      buyer_cart_viewmodel.dart
      buyer_wishlist_viewmodel.dart
  screens/                               ← REFACTORED ★
    welcome_screen.dart                   (unchanged — no DB calls)
    book_list_screen.dart                 (refactored)
    book_detail_screen.dart               (unchanged — no DB calls)
    book_form_screen.dart                 (refactored)
    admin/ (6 files — all refactored)
    seller/ (5 files — 4 refactored)
    buyer/ (7 files — 6 refactored)
```

---

## 🏗️ Lapisan Arsitektur

### 1. Model Layer (`lib/models/`)

**Tidak berubah.** Model tetap menggunakan kelas Dart murni dengan `fromMap()`/`toMap()`/`copyWith()`:
- `Book` — data buku
- `User` — data pengguna
- `BookCategory` — data kategori

### 2. Repository Layer (`lib/repositories/`) — NEW

Setiap repository membungkus operasi DatabaseHelper yang terkait dengan satu entitas:

| Repository | Tanggung Jawab |
|------------|----------------|
| `BookRepository` | CRUD buku, search, filter status/kategori |
| `UserRepository` | Login, register, manajemen user (admin), analytics |
| `CategoryRepository` | CRUD kategori |
| `OrderRepository` | CRUD pesanan, filter by buyer/seller/admin |
| `CartRepository` | CRUD keranjang (add, update qty, remove, clear) |
| `WishlistRepository` | CRUD wishlist (add, remove, check, get) |

**Keuntungan:**
- Memusatkan semua operasi database untuk satu entity
- Jika suatu saat migrasi dari SQLite ke API/server, cukup ubah Repository
- Testing lebih mudah (Repository bisa di-mock)

### 3. ViewModel Layer (`lib/viewmodels/`) — NEW

ViewModel adalah kelas yang extends `ChangeNotifier`, berisi:
- **State** — data yang akan ditampilkan di View
- **Business Logic** — validasi, filter, sorting, transformasi data
- **Methods** — aksi yang bisa dipanggil oleh View

| ViewModel | State yang Dikelola |
|-----------|-------------------|
| `AdminLoginViewModel` | loading, error, user |
| `AdminDashboardViewModel` | stats, recentOrders, loading |
| `AdminUsersViewModel` | sellers, buyers, loading, searchQuery |
| `AdminBooksViewModel` | pending, approved, rejected, categories, loading |
| `SellerAuthViewModel` | loading, error, successMessage, user |
| `SellerBookListViewModel` | books, categories, loading, selectedTab |
| `SellerOrdersViewModel` | allOrders, filtered, loading, filterIdx |
| `SellerRevenueViewModel` | orders, loading, computed totals |
| `BuyerAuthViewModel` | loading, error, successMessage, user |
| `BuyerHomeViewModel` | allBooks, featured, loading |
| `BuyerCatalogViewModel` | books, categories, selected, loading |
| `BuyerBookDetailViewModel` | inWish, inCart, qty |
| `BuyerCartViewModel` | items, loading, total |
| `BuyerWishlistViewModel` | books, loading |
| `BookListViewModel` | books, filteredBooks, isLoading, selectedKategori |
| `BookFormViewModel` | isLoading, error |

**Pola ViewModel:**
```dart
class ExampleViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  List<String> _items = [];
  List<String> get items => _items;

  Future<void> load() async {
    _loading = true;
    notifyListeners();   // ← trigger UI rebuild

    _items = await repository.getItems();

    _loading = false;
    notifyListeners();   // ← trigger UI rebuild
  }
}
```

### 4. View Layer (`lib/screens/`) — REFACTORED

Screen hanya berisi **Widget Tree** (UI layout) dan memanggil ViewModel.

**Pola View:**
```dart
class ExampleScreen extends StatefulWidget {
  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _viewModel = ExampleViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.load();
  }

  void _onChanged() {
    if (mounted) setState(() {});  // ← rebuild ketika ViewModel berubah
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          body: _viewModel.loading
              ? CircularProgressIndicator()
              : ListView.builder(/* ... */),
        );
      },
    );
  }
}
```

---

## 🔄 Data Flow Sebelum vs Sesudah

### Sebelum (Coupling Langsung)
```
User Tap → Screen.setState() → DatabaseHelper.query() → Screen.setState() → UI rebuild
```

### Sesudah (MVVM)
```
User Tap → Screen.callMethod()
                ↓
         ViewModel.method()
                ↓
         Repository.call()
                ↓
         DatabaseHelper.query()
                ↓
         ViewModel.notifyListeners()
                ↓
         Screen.ListenableBuilder → UI rebuild
```

---

## 📊 Perubahan per File

### Admin Role
| File | Perubahan |
|------|-----------|
| `admin_login_screen.dart` | `DatabaseHelper` → `AdminLoginViewModel` |
| `admin_dashboard_screen.dart` | `DatabaseHelper` → `AdminDashboardViewModel` |
| `admin_users_screen.dart` | `DatabaseHelper` → `AdminUsersViewModel` |
| `admin_books_screen.dart` | `DatabaseHelper` → `AdminBooksViewModel` |
| `admin_main_screen.dart` | Tidak berubah (shell navigasi) |
| `admin_profile_screen.dart` | Tidak berubah (StatelessWidget, no DB) |

### Seller Role
| File | Perubahan |
|------|-----------|
| `seller_auth_screen.dart` | `DatabaseHelper` → `SellerAuthViewModel` |
| `seller_book_list_screen.dart` | `DatabaseHelper` → `SellerBookListViewModel` |
| `seller_orders_screen.dart` | `DatabaseHelper` → `SellerOrdersViewModel` |
| `seller_revenue_screen.dart` | `DatabaseHelper` → `SellerRevenueViewModel` |
| `seller_main_screen.dart` | Tidak berubah (shell navigasi) |
| `seller_profile_screen.dart` | Tidak berubah (StatelessWidget, no DB) |

### Buyer Role
| File | Perubahan |
|------|-----------|
| `buyer_auth_screen.dart` | `DatabaseHelper` → `BuyerAuthViewModel` |
| `buyer_home_screen.dart` | `DatabaseHelper` → `BuyerHomeViewModel` |
| `buyer_catalog_screen.dart` | `DatabaseHelper` → `BuyerCatalogViewModel` |
| `buyer_book_detail_screen.dart` | `DatabaseHelper` → `BuyerBookDetailViewModel` |
| `buyer_cart_screen.dart` | `DatabaseHelper` → `BuyerCartViewModel` |
| `buyer_wishlist_screen.dart` | `DatabaseHelper` → `BuyerWishlistViewModel` |
| `buyer_main_screen.dart` | Tidak berubah (shell navigasi) |
| `buyer_profile_screen.dart` | Tidak berubah (StatelessWidget, no DB) |

### Legacy Screens
| File | Perubahan |
|------|-----------|
| `book_list_screen.dart` | `DatabaseHelper` → `BookListViewModel` |
| `book_detail_screen.dart` | Tidak berubah (StatelessWidget, no DB) |
| `book_form_screen.dart` | `DatabaseHelper` → `BookFormViewModel` |

---

## ✅ Keuntungan MVVM

| Aspek | Sebelum | Sesudah |
|-------|---------|---------|
| **Separation of Concerns** | ❌ UI + Logic + DB tercampur | ✅ UI (View), Logic (ViewModel), Data (Repository) |
| **Testability** | ❌ Sulit (tergantung SQLite) | ✅ ViewModel & Repository bisa di-unit-test |
| **Maintainability** | ❌ Perubahan DB = edit semua screen | ✅ Cukup edit Repository |
| **State Management** | ❌ `setState()` di setiap widget | ✅ `ChangeNotifier` + `notifyListeners()` |
| **Code Duplication** | ❌ Tinggi (query berulang) | ✅ Rendah (logic di satu tempat) |
| **Scalability** | ❌ Screen > 300 lines menjadi kompleks | ✅ ViewModel menampung complex state |
| **Reusability** | ❌ Logic terikat di widget | ✅ ViewModel bisa dipakai multiple Views |

---

## 📝 Catatan

1. **DatabaseHelper tetap sebagai singleton** — Lapisan ini tidak diubah karena berfungsi sebagai infrastruktur database. Repository membungkusnya sehingga jika ada migrasi ke backend API, cukup mengganti implementasi Repository.

2. **State Management** — Menggunakan `ChangeNotifier` bawaan Flutter (dari `package:flutter/foundation.dart`) tanpa dependency tambahan seperti Provider, Riverpod, atau Bloc.

3. **UI Identik** — Semua tema, warna, layout, dan user experience tetap sama persis dengan versi original.

4. **Tidak Ada Error Baru** — Hasil `flutter analyze` menunjukkan 0 error (hanya info-level style hints dan 4 pre-existing warnings).

---

*Dokumentasi ini dibuat sebagai bagian dari refactoring MVVM Pattern untuk E-BookStore Flutter.*
