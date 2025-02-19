class User {
  final int id;
  final String name;
  final String username;
  final String? accessToken;

  User({
    required this.id,
    required this.name,
    required this.username,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
    );
  }
}