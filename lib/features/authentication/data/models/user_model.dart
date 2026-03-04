import 'package:hive/hive.dart';
import 'package:streaming_app/core/constants/cache_constants.dart';
import 'package:streaming_app/features/authentication/domain/entities/user.dart';

part 'user_model.g.dart';

/// User model (data layer)
/// Handles JSON serialization and Hive storage
/// Matches backend API response structure
@HiveType(typeId: CacheConstants.userModelTypeId)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final String? createdAt;

  @HiveField(6)
  final String? role;

  @HiveField(7)
  final String? gender;

  @HiveField(8)
  final String? bio;

  @HiveField(9)
  final String? dob;

  @HiveField(10)
  final String? loginType;

  @HiveField(11)
  final String? fcmToken;

  @HiveField(12)
  final String? country;

  @HiveField(13)
  final String? ip;

  @HiveField(14)
  final String? status;

  @HiveField(15)
  final String? lastLogin;

  @HiveField(16)
  final int? userId;

  @HiveField(17)
  final bool? onboarded;

  @HiveField(18)
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.imageUrl,
    this.phoneNumber,
    this.createdAt,
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
  });

  /// Convert from backend API JSON response
  /// Handles the nested structure: response['data']['user']
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
      gender: json['gender'] as String?,
      bio: json['bio'] as String?,
      dob: json['dob'] as String?,
      loginType: json['login_type'] as String?,
      fcmToken: json['fcm_token'] as String?,
      country: json['country'] as String?,
      ip: json['ip'] as String?,
      status: json['status'] as String?,
      lastLogin: json['last_login'] as String?,
      userId: json['userId'] as int?,
      onboarded: json['onboarded'] as bool?,
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'name': name,
      'image_url': imageUrl,
      'phoneNumber': phoneNumber,
      'role': role,
      'gender': gender,
      'bio': bio,
      'dob': dob,
      'login_type': loginType,
      'fcm_token': fcmToken,
      'country': country,
      'ip': ip,
      'status': status,
      'last_login': lastLogin,
      'userId': userId,
      'onboarded': onboarded,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      imageUrl: imageUrl,
      phoneNumber: phoneNumber,
      role: role,
      gender: gender,
      bio: bio,
      dob: dob != null ? DateTime.tryParse(dob!) : null,
      loginType: loginType,
      fcmToken: fcmToken,
      country: country,
      ip: ip,
      status: status,
      lastLogin: lastLogin != null ? DateTime.tryParse(lastLogin!) : null,
      userId: userId,
      onboarded: onboarded,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }

  /// Create from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      imageUrl: user.imageUrl,
      phoneNumber: user.phoneNumber,
      role: user.role,
      gender: user.gender,
      bio: user.bio,
      dob: user.dob?.toIso8601String(),
      loginType: user.loginType,
      fcmToken: user.fcmToken,
      country: user.country,
      ip: user.ip,
      status: user.status,
      lastLogin: user.lastLogin?.toIso8601String(),
      userId: user.userId,
      onboarded: user.onboarded,
      updatedAt: user.updatedAt?.toIso8601String(),
      createdAt: user.createdAt?.toIso8601String(),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, onboarded: $onboarded)';
  }
}
