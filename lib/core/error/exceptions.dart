/// Custom exceptions for the application
/// These are thrown in the data layer and caught by repositories
/// to be converted into Failures

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException(message: $message)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AuthException(message: $message, code: $code)';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  const ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException(message: $message, errors: $errors)';
}

class NewUserException implements Exception {
  final String message;
  final String jwtToken;

  const NewUserException({
    required this.message,
    required this.jwtToken,
  });

  @override
  String toString() => 'NewUserException(message: $message)';
}
