/// Represents a user in the system.
class User {
  /// The unique identifier for the user.
  final String id;

  /// The username of the user.
  final String username;

  /// The email address of the user.
  final String email;

  /// The role of the user (e.g., 'admin', 'premium', 'pro').
  final String role;

  /// Creates a [User] instance.
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  /// Creates a [User] instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  /// Converts this [User] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
    };
  }
}
