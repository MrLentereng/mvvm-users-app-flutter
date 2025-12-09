class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUri;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUri,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUri,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUri: photoUri ?? this.photoUri,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'photoUri': photoUri,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        photoUri: json['photoUri'] as String?,
      );
}
