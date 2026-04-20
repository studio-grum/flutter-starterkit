class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

class AppAuthException extends AppException {
  const AppAuthException(super.message, {super.code});
}

class PurchaseException extends AppException {
  const PurchaseException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}
