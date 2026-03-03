import 'package:dartz/dartz.dart';
import 'package:streaming_app/core/error/failures.dart';
import 'package:streaming_app/features/authentication/domain/entities/user.dart';

/// Authentication repository interface (domain layer)
/// Defines the contract that data layer must implement
abstract class AuthRepository {
  /// Login with Google
  Future<Either<Failure, User>> loginWithGoogle();

  /// Logout
  Future<Either<Failure, void>> logout();

  /// Get current user from local cache
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Stream of authentication state changes
  Stream<Either<Failure, User?>> get authStateChanges;
}
