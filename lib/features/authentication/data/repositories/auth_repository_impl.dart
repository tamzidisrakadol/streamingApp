import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:streaming_app/core/error/exceptions.dart';
import 'package:streaming_app/core/error/failures.dart';
import 'package:streaming_app/core/network/network_info.dart';
import 'package:streaming_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:streaming_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:streaming_app/features/authentication/domain/entities/user.dart';
import 'package:streaming_app/features/authentication/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
/// Coordinates between remote and local data sources
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(errorMessage: 'No internet connection'));
    }

    try {
      // 1. Authenticate with backend API
      final userModel = await remoteDataSource.loginWithGoogle();

      // 2. Save JWT token (already saved by remote data source in NewUserException case)
      // For existing users, we get the full user model here

      // 3. Cache user locally
      await localDataSource.cacheUser(userModel);

      // 4. Return entity
      return Right(userModel.toEntity());
    } on NewUserException catch (e) {
      // New user detected - save JWT token only, don't cache user yet
      print('🔑 Saving JWT token for new user...');
      await localDataSource.saveAuthToken(e.jwtToken);

      // Return NewUserFailure to signal BLoC that onboarding is needed
      return Left(NewUserFailure(
        errorMessage: e.message,
        jwtToken: e.jwtToken,
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(errorMessage: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    } catch (e) {
      return Left(AuthFailure(errorMessage: 'Login failed: $e'));
    }
  }



  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // 1. Sign out from Firebase
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }

      // 2. Clear local data
      await localDataSource.clearAuthData();

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(errorMessage: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    } catch (e) {
      return Left(AuthFailure(errorMessage: 'Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Always read from local cache (instant, no network needed)
      final userModel = await localDataSource.getCachedUser();

      if (userModel == null) {
        return const Left(
          CacheFailure(errorMessage: 'No user cached'),
        );
      }

      return Right(userModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(errorMessage: e.message));
    } catch (e) {
      return Left(CacheFailure(errorMessage: 'Failed to get current user: $e'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return localDataSource.isLoggedIn();
  }

  @override
  Stream<Either<Failure, User?>> get authStateChanges {
    // TODO: Implement auth state changes stream
    // This would typically listen to Firebase auth state changes
    // and emit User entities
    return const Stream.empty();
  }
}
