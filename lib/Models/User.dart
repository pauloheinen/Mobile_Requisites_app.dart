class User {
  final int? id;
  final String? name;
  final String? password;

  const User({required this.id, required this.name, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nome'],
      password: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nome'] = name;
    data['senha'] = password;

    return data;
  }
}
