import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);
  final List properties;

  @override
  List<Object?> get props => [properties];
}


class ServerFailure extends Failure {
  final String message;
  const ServerFailure({required this.message});

  @override
  List<Object?> get props => [message, ...super.props];


  @override
  String toString() {
    return 'ServerFailure(message: $message)';
  }
}

class NetworkFailure extends Failure {
  final String message;
  const NetworkFailure({required this.message});
}


class CacheFailure extends Failure {
  final String message;
  const CacheFailure({required this.message});
}