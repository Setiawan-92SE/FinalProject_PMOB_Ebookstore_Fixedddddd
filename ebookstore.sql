--
-- File generated with SQLiteStudio v3.4.21 on Wed Jun 17 11:53:26 2026
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: android_metadata
CREATE TABLE IF NOT EXISTS android_metadata (locale TEXT);
INSERT INTO android_metadata (locale) VALUES ('en_US');

-- Table: books
CREATE TABLE IF NOT EXISTS books (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      judul TEXT NOT NULL,
      penulis TEXT NOT NULL,
      kategori TEXT NOT NULL REFERENCES categories(nama)
        ON DELETE RESTRICT ON UPDATE CASCADE,
      harga REAL NOT NULL DEFAULT 0,
      deskripsi TEXT NOT NULL,
      cover_url TEXT,
      stok INTEGER NOT NULL DEFAULT 0,
      status TEXT NOT NULL DEFAULT 'pending',
      seller_id INTEGER REFERENCES users(id)
        ON DELETE SET NULL ON UPDATE CASCADE
    );
INSERT INTO books (id, judul, penulis, kategori, harga, deskripsi, cover_url, stok, status, seller_id) VALUES (1, 'Laskar Pelangi', 'Andrea Hirata', 'Fiksi', 85000.0, 'Novel tentang semangat anak-anak Belitung.', NULL, 50, 'approved', 1);
INSERT INTO books (id, judul, penulis, kategori, harga, deskripsi, cover_url, stok, status, seller_id) VALUES (2, 'Atomic Habits', 'James Clear', 'Pengembangan Diri', 120000.0, 'Cara membangun kebiasaan baik.', NULL, 30, 'approved', 1);
INSERT INTO books (id, judul, penulis, kategori, harga, deskripsi, cover_url, stok, status, seller_id) VALUES (3, 'Sapiens', 'Yuval Noah Harari', 'Non-Fiksi', 135000.0, 'Sejarah singkat umat manusia.', NULL, 25, 'approved', 1);
INSERT INTO books (id, judul, penulis, kategori, harga, deskripsi, cover_url, stok, status, seller_id) VALUES (4, 'Clean Code', 'Robert C. Martin', 'Teknologi', 150000.0, 'Panduan menulis kode bersih.', NULL, 20, 'approved', 1);
INSERT INTO books (id, judul, penulis, kategori, harga, deskripsi, cover_url, stok, status, seller_id) VALUES (5, 'Rich Dad Poor Dad', 'Robert Kiyosaki', 'Bisnis', 95000.0, 'Pelajaran keuangan dua sudut pandang.', NULL, 40, 'approved', 1);
INSERT INTO books (id, judul, penulis, kategori, harga, deskripsi, cover_url, stok, status, seller_id) VALUES (6, 'Buku Menunggu Approval', 'Penulis Baru', 'Fiksi', 75000.0, 'Contoh buku pending persetujuan admin.', NULL, 10, 'pending', 1);

-- Table: cart
CREATE TABLE IF NOT EXISTS cart (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL REFERENCES users(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
      book_id INTEGER NOT NULL REFERENCES books(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
      qty INTEGER NOT NULL DEFAULT 1,
      UNIQUE(user_id, book_id)
    );

-- Table: categories
CREATE TABLE IF NOT EXISTS categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT NOT NULL UNIQUE,
      deskripsi TEXT,
      is_active INTEGER NOT NULL DEFAULT 1
    );
INSERT INTO categories (id, nama, deskripsi, is_active) VALUES (1, 'Fiksi', NULL, 1);
INSERT INTO categories (id, nama, deskripsi, is_active) VALUES (2, 'Non-Fiksi', NULL, 1);
INSERT INTO categories (id, nama, deskripsi, is_active) VALUES (3, 'Pengembangan Diri', NULL, 1);
INSERT INTO categories (id, nama, deskripsi, is_active) VALUES (4, 'Pendidikan', NULL, 1);
INSERT INTO categories (id, nama, deskripsi, is_active) VALUES (5, 'Teknologi', NULL, 1);
INSERT INTO categories (id, nama, deskripsi, is_active) VALUES (6, 'Bisnis', NULL, 1);

-- Table: notifications
CREATE TABLE IF NOT EXISTS notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            message TEXT NOT NULL,
            type TEXT NOT NULL DEFAULT 'info',
            related_order_id INTEGER,
            is_read INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id)
              ON DELETE CASCADE ON UPDATE CASCADE
          );
INSERT INTO notifications (id, user_id, title, message, type, related_order_id, is_read, created_at) VALUES (1, 2, 'Pesanan Dikonfirmasi', 'Pesanan "Atomic Habits" telah dikonfirmasi. Silakan lakukan pembayaran sekarang.', 'order_confirmed', 4, 1, '2026-06-17T03:53:23.203247');
INSERT INTO notifications (id, user_id, title, message, type, related_order_id, is_read, created_at) VALUES (2, 1, 'Pembayaran Diterima', 'Pembayaran untuk "Atomic Habits" telah diterima.', 'payment_received', 4, 1, '2026-06-17T03:54:05.390424');
INSERT INTO notifications (id, user_id, title, message, type, related_order_id, is_read, created_at) VALUES (3, 2, 'Pesanan Dikonfirmasi', 'Pesanan "Clean Code" telah dikonfirmasi. Silakan lakukan pembayaran sekarang.', 'order_confirmed', 5, 1, '2026-06-17T03:54:43.040626');
INSERT INTO notifications (id, user_id, title, message, type, related_order_id, is_read, created_at) VALUES (4, 1, 'Pembayaran Diterima', 'Pembayaran untuk "Clean Code" telah diterima.', 'payment_received', 5, 1, '2026-06-17T03:55:35.564419');
INSERT INTO notifications (id, user_id, title, message, type, related_order_id, is_read, created_at) VALUES (5, 2, 'Pesanan Dikonfirmasi', 'Pesanan "Rich Dad Poor Dad" telah dikonfirmasi. Silakan lakukan pembayaran sekarang.', 'order_confirmed', 6, 1, '2026-06-17T04:30:13.903696');
INSERT INTO notifications (id, user_id, title, message, type, related_order_id, is_read, created_at) VALUES (6, 1, 'Pembayaran Diterima', 'Pembayaran untuk "Rich Dad Poor Dad" telah diterima via E-Wallet.', 'payment_received', 6, 0, '2026-06-17T04:31:24.846123');

-- Table: orders
CREATE TABLE IF NOT EXISTS orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      buyer_id INTEGER NOT NULL REFERENCES users(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
      book_id INTEGER NOT NULL REFERENCES books(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
      qty INTEGER NOT NULL DEFAULT 1,
      total REAL NOT NULL DEFAULT 0,
      status TEXT NOT NULL DEFAULT 'pending',
      payment_status TEXT NOT NULL DEFAULT 'belum_bayar',
      created_at TEXT NOT NULL
    , payment_method TEXT, payment_account TEXT);
INSERT INTO orders (id, buyer_id, book_id, qty, total, status, payment_status, created_at, payment_method, payment_account) VALUES (1, 2, 2, 1, 120000.0, 'selesai', 'lunas', '2026-06-16T16:45:08.928998', NULL, NULL);
INSERT INTO orders (id, buyer_id, book_id, qty, total, status, payment_status, created_at, payment_method, payment_account) VALUES (2, 2, 4, 1, 150000.0, 'selesai', 'lunas', '2026-06-16T16:49:22.503721', NULL, NULL);
INSERT INTO orders (id, buyer_id, book_id, qty, total, status, payment_status, created_at, payment_method, payment_account) VALUES (3, 2, 1, 2, 170000.0, 'selesai', 'lunas', '2026-06-17T03:17:11.795655', NULL, NULL);
INSERT INTO orders (id, buyer_id, book_id, qty, total, status, payment_status, created_at, payment_method, payment_account) VALUES (4, 2, 2, 1, 120000.0, 'selesai', 'lunas', '2026-06-17T03:52:58.629', NULL, NULL);
INSERT INTO orders (id, buyer_id, book_id, qty, total, status, payment_status, created_at, payment_method, payment_account) VALUES (5, 2, 4, 2, 300000.0, 'selesai', 'lunas', '2026-06-17T03:54:21.906411', NULL, NULL);
INSERT INTO orders (id, buyer_id, book_id, qty, total, status, payment_status, created_at, payment_method, payment_account) VALUES (6, 2, 5, 1, 95000.0, 'selesai', 'lunas', '2026-06-17T04:29:46.548954', 'E-Wallet', '24082010092');

-- Table: users
CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      phone TEXT NOT NULL,
      password TEXT NOT NULL,
      role TEXT NOT NULL DEFAULT 'buyer',
      is_active INTEGER NOT NULL DEFAULT 1
    );
INSERT INTO users (id, nama, email, phone, password, role, is_active) VALUES (1, 'Demo Seller', 'seller@demo.com', '081234567890', 'seller123', 'seller', 1);
INSERT INTO users (id, nama, email, phone, password, role, is_active) VALUES (2, 'Demo Buyer', 'buyer@demo.com', '089876543210', 'buyer123', 'buyer', 1);
INSERT INTO users (id, nama, email, phone, password, role, is_active) VALUES (3, 'Administrator', 'admin@demo.com', '081111111111', 'admin123', 'admin', 1);

-- Table: wishlist
CREATE TABLE IF NOT EXISTS wishlist (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL REFERENCES users(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
      book_id INTEGER NOT NULL REFERENCES books(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
      UNIQUE(user_id, book_id)
    );

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
