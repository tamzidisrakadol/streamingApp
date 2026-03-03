import 'package:dartz/dartz.dart';
import 'package:streaming_app/core/error/failures.dart';
import 'package:streaming_app/core/usecases/usecase.dart';
import 'package:streaming_app/features/authentication/domain/entities/user.dart';
import 'package:streaming_app/features/authentication/domain/repositories/auth_repository.dart';

/// Use case for logging in with Google
class LoginWithGoogle implements UseCase<User, NoParams> {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.loginWithGoogle();
  }
}
