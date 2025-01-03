// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppException implements Exception {
  late final String title;
  late final String message;
  AppException({
    required this.title,
    required this.message,
  });

  @override
  String toString() => 'AppException(title: $title, message: $message)';
}

class BadRequestException extends AppException {
  BadRequestException({required super.title, required super.message});
}

class NetworkException extends AppException {
  NetworkException({required super.title, required super.message});
}

class ValidationException extends AppException {
  ValidationException({required super.title, required super.message});
}

class NotFoundException extends AppException {
  NotFoundException({required super.title, required super.message});
}

class FirebaseCredentialException extends AppException {
  FirebaseCredentialException({required super.title, required super.message});
}

class FireStoreException extends AppException {
  FireStoreException({required super.title, required super.message});
}

class InternalServerException extends AppException {
  InternalServerException({required super.title, required super.message});
}

class NoInternetException extends AppException {
  NoInternetException({required super.title, required super.message});
}

class ForbiddenException extends AppException {
  ForbiddenException({required super.title, required super.message});
}

class UnknownException extends AppException {
  UnknownException({required super.title, required super.message});
}
