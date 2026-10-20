class UserModel {
  final String id;
  final String email;
  final String? name;
  final String role;
  final String? phone;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.role = 'USER',
    this.phone,
  });

  bool get isAdmin => role == 'ADMIN';

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
        'phone': phone,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        role: json['role'] as String? ?? 'USER',
        phone: json['phone'] as String?,
      );
}
