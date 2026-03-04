import 'package:equatable/equatable.dart';

/// User entity (domain layer)
/// Pure Dart class with no dependencies on Flutter or external packages
/// Matches backend API response structure
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? imageUrl;
  final String? phoneNumber;
  final String? role;
  final String? gender;
  final String? bio;
  final DateTime? dob;
  final String? loginType;
  final String? fcmToken;
  final String? country;
  final String? ip;
  final String? status;
  final DateTime? lastLogin;
  final int? userId;
  final bool? onboarded;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.imageUrl,
    this.phoneNumber,
    this.role,
    this.gender,
    this.bio,
    this.dob,
    this.loginType,
    this.fcmToken,
    this.country,
    this.ip,
    this.status,
    this.lastLogin,
    this.userId,
    this.onboarded,
    this.updatedAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        imageUrl,
        phoneNumber,
        role,
        gender,
        bio,
        dob,
        loginType,
        fcmToken,
        country,
        ip,
        status,
        lastLogin,
        userId,
        onboarded,
        updatedAt,
        createdAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, onboarded: $onboarded)';
  }
}
