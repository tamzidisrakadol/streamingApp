import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:streaming_app/core/error/failures.dart';

/// Base class for all use cases
/// Type: The return type wrapped in Either
/// Params: The parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this class when a use case doesn't need any parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
