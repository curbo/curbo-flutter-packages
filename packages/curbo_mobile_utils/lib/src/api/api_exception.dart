abstract class AppException implements Exception {
  final String? _message;
  final String? _prefix;
  final Map<String, dynamic>? data;

  AppException([this._message, this._prefix, this.data]);

  String toString() {
    return '$_prefix$_message';
  }
}

class ServerException extends AppException {
  ServerException([
    String? message,
    Map<String, dynamic>? data,
  ]) : super(
          message,
          'Error During Communication: ',
          data,
        );
}

class BadRequestException extends AppException {
  BadRequestException([
    String? message,
    Map<String, dynamic>? data,
  ]) : super(
          message,
          'Invalid Request: ',
          data,
        );
}

class UnauthorisedException extends AppException {
  UnauthorisedException([
    String? message,
    Map<String, dynamic>? data,
  ]) : super(
          message,
          'Unauthorised: ',
          data,
        );
}

class NotFoundException extends AppException {
  NotFoundException([
    String? message,
    Map<String, dynamic>? data,
  ]) : super(
          message,
          'Not Found: ',
          data,
        );
}
