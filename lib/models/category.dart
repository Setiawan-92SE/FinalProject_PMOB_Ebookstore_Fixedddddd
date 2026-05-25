/// Model BookCategory — kategori buku yang dikelola Admin
/// Path: lib/models/category.dart
class BookCategory {
  int? id;
  String nama;
  String? deskripsi;
  bool isActive;

  BookCategory({
    this.id,
    required this.nama,
    this.deskripsi,
    this.isActive = true,
  });

  factory BookCategory.fromMap(Map<String, dynamic> map) => BookCategory(
        id: map['id'],
        nama: map['nama'] ?? '',
        deskripsi: map['deskripsi'],
        isActive: (map['is_active'] ?? 1) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nama': nama,
        'deskripsi': deskripsi,
        'is_active': isActive ? 1 : 0,
      };

  BookCategory copyWith({
    int? id,
    String? nama,
    String? deskripsi,
    bool? isActive,
  }) =>
      BookCategory(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        deskripsi: deskripsi ?? this.deskripsi,
        isActive: isActive ?? this.isActive,
      );

  @override
  String toString() =>
      'BookCategory{id: $id, nama: $nama, isActive: $isActive}';
}