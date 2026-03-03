import 'package:equatable/equatable.dart';

/// Abstract base class for all failures
/// Failures represent errors in a type-safe way for the domain layer
abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);

  final List properties;

  @override
  List<Object?> get props => [properties];

  String get message;
}

class ServerFailure extends Failure {
  final String errorMessage;
  final int? statusCode;

  const ServerFailure({
    required this.errorMessage,
    this.statusCode,
  });

  @override
  List<Object?> get props => [errorMessage, statusCode, ...super.props];

  @override
  String get message => errorMessage;

  @override
  String toString() => 'ServerFailure(message: $errorMessage, statusCode: $statusCode)';
}

class NetworkFailure extends Failure {
  final String errorMessage;

  const NetworkFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage, ...super.props];

  @override
  String get message => errorMessage;

  @override
  String toString() => 'NetworkFailure(message: $errorMessage)';
}

class CacheFailure extends Failure {
  final String errorMessage;

  const CacheFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage, ...super.props];

  @override
  String get message => errorMessage;

  @override
  String toString() => 'CacheFailure(message: $errorMessage)';
}

class AuthFailure extends Failure {
  final String errorMessage;
  final String? code;

  const AuthFailure({
    required this.errorMessage,
    this.code,
  });

  @override
  List<Object?> get props => [errorMessage, code, ...super.props];

  @override
  String get message => errorMessage;

  @override
  String toString() => 'AuthFailure(message: $errorMessage, code: $code)';
}

class ValidationFailure extends Failure {
  final String errorMessage;
  final Map<String, String>? errors;

  const ValidationFailure({
    required this.errorMessage,
    this.errors,
  });

  @override
  List<Object?> get props => [errorMessage, errors, ...super.props];

  @override
  String get message => errorMessage;

  @override
  String toString() => 'ValidationFailure(message: $errorMessage, errors: $errors)';
}
