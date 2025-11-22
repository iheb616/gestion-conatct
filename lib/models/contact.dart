class Contact {
  final int? id;
  final String name;
  final String phone;
  final String email;

  Contact(
      {this.id, required this.name, required this.phone, required this.email});

  // Convert Contact to JSON (useful for saving data)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'name': name,
      'phone': phone,
      'email': email,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse('${json['id']}') : null),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Map conversion used with sqflite
  Map<String, dynamic> toMap() => toJson();

  factory Contact.fromMap(Map<String, dynamic> map) => Contact.fromJson(map);
}
