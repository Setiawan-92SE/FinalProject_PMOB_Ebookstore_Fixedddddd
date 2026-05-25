/// Model User
/// Path: lib/models/user.dart
class User {
  int? id;
  String nama;
  String email;
  String phone;
  String password;
  String role;
  bool isActive;

  User(
      {this.id,
      required this.nama,
      required this.email,
      required this.phone,
      required this.password,
      required this.role,
      this.isActive = true});

  factory User.fromMap(Map<String, dynamic> map) => User(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'buyer',
      isActive: (map['is_active'] ?? 1) == 1);

  Map<String, dynamic> toMap() => {
        'id': id,
        'nama': nama,
        'email': email.trim().toLowerCase(),
        'phone': phone,
        'password': password,
        'role': role,
        'is_active': isActive ? 1 : 0
      };

  User copyWith(
          {int? id,
          String? nama,
          String? email,
          String? phone,
          String? password,
          String? role,
          bool? isActive}) =>
      User(
          id: id ?? this.id,
          nama: nama ?? this.nama,
          email: email ?? this.email,
          phone: phone ?? this.phone,
          password: password ?? this.password,
          role: role ?? this.role,
          isActive: isActive ?? this.isActive);

  @override
  String toString() => 'User{id:$id, nama:$nama, role:$role}';
}