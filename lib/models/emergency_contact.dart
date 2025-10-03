class EmergencyContact {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String relation;

  EmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.relation,
  });

  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'userId': userId,
    'name': name,
    'phone': phone,
    'email': email,
    'relation': relation,
  };
  }
}


