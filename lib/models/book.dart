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
  String status; // 'pending' | 'approved' | 'rejected'
  int? sellerId; // id seller yang mengajukan buku

  Book({
    this.id,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
    this.coverUrl,
    this.stok = 0,
    this.status = 'approved', // seed data langsung approved
    this.sellerId,
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
      status: map['status'] ?? 'approved',
      sellerId: map['seller_id'],
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
      'status': status,
      'seller_id': sellerId,
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
    String? status,
    int? sellerId,
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
      status: status ?? this.status,
      sellerId: sellerId ?? this.sellerId,
    );
  }

  @override
  String toString() =>
      'Book{id: $id, judul: $judul, status: $status, sellerId: $sellerId}';
}
