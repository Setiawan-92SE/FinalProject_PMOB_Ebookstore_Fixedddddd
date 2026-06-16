/// Model Book — dengan field status (pending/approved/rejected) dan sellerId
/// Path: lib/models/book.dart
class Book {
  int? id;
  String judul;
  String penulis;
  String kategori;
  double harga;
  String deskripsi;
  String? coverUrl;
  int stok;
<<<<<<< HEAD
  String status; // 'pending' | 'approved' | 'rejected'
  int? sellerId; // id seller yang mengajukan buku
=======
  int? sellerId;
  String status;
>>>>>>> 6b0f76a63e881777dd2f8c012d8f63eb38c702eb

  Book({
    this.id,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
    this.coverUrl,
    this.stok = 0,
<<<<<<< HEAD
    this.status = 'approved', // seed data langsung approved
    this.sellerId,
=======
    this.sellerId,
    this.status = 'approved',
>>>>>>> 6b0f76a63e881777dd2f8c012d8f63eb38c702eb
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      judul: map['judul'] ?? '',
      penulis: map['penulis'] ?? '',
      kategori: map['kategori'] ?? '',
      harga: (map['harga'] ?? 0).toDouble(),
      deskripsi: map['deskripsi'] ?? '',
      coverUrl: map['cover_url'],
      stok: map['stok'] ?? 0,
<<<<<<< HEAD
      status: map['status'] ?? 'approved',
      sellerId: map['seller_id'],
=======
      sellerId: map['seller_id'],
      status: map['status'] ?? 'approved',
>>>>>>> 6b0f76a63e881777dd2f8c012d8f63eb38c702eb
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'penulis': penulis,
      'kategori': kategori,
      'harga': harga,
      'deskripsi': deskripsi,
      'cover_url': coverUrl,
      'stok': stok,
<<<<<<< HEAD
      'status': status,
      'seller_id': sellerId,
=======
      'seller_id': sellerId,
      'status': status,
>>>>>>> 6b0f76a63e881777dd2f8c012d8f63eb38c702eb
    };
  }

  Book copyWith({
    int? id,
    String? judul,
    String? penulis,
    String? kategori,
    double? harga,
    String? deskripsi,
    String? coverUrl,
    int? stok,
<<<<<<< HEAD
    String? status,
    int? sellerId,
=======
    int? sellerId,
    String? status,
>>>>>>> 6b0f76a63e881777dd2f8c012d8f63eb38c702eb
  }) {
    return Book(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      penulis: penulis ?? this.penulis,
      kategori: kategori ?? this.kategori,
      harga: harga ?? this.harga,
      deskripsi: deskripsi ?? this.deskripsi,
      coverUrl: coverUrl ?? this.coverUrl,
      stok: stok ?? this.stok,
<<<<<<< HEAD
      status: status ?? this.status,
      sellerId: sellerId ?? this.sellerId,
=======
      sellerId: sellerId ?? this.sellerId,
      status: status ?? this.status,
>>>>>>> 6b0f76a63e881777dd2f8c012d8f63eb38c702eb
    );
  }

  @override
  String toString() =>
      'Book{id: $id, judul: $judul, status: $status, sellerId: $sellerId}';
}
