import 'package:equatable/equatable.dart';

/// User entity (domain layer)
/// Pure Dart class with no dependencies on Flutter or external packages
class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        phoneNumber,
        createdAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName)';
  }
}
