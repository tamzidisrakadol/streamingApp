import 'package:dartz/dartz.dart';
import 'package:streaming_app/core/error/failures.dart';
import 'package:streaming_app/core/usecases/usecase.dart';
import 'package:streaming_app/features/authentication/domain/repositories/auth_repository.dart';

/// Use case for logging out
class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
