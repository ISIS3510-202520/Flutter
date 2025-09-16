class UserEntity {
  final String id;
  final String name;
  final String email;
  final bool isActive;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isActive': isActive,
    };
  }
}