import 'package:dartz/dartz.dart';
import 'package:streaming_app/core/error/failures.dart';
import 'package:streaming_app/core/usecases/usecase.dart';
import 'package:streaming_app/features/authentication/domain/entities/user.dart';
import 'package:streaming_app/features/authentication/domain/repositories/auth_repository.dart';

/// Use case for getting the current logged-in user from cache
class GetCurrentUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
