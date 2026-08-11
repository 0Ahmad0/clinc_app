import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'email_verification_challenge.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions implements Exception {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  // const factory NetworkExceptions.firebaseAuthException(String message) =
  //     FireBaseAuthException;
  // const factory NetworkExceptions.firebaseException(String message) =
  //     FireBaseException;

  const factory NetworkExceptions.unauthorizedRequest(String reason) =
      UnauthorizedRequest;
  const factory NetworkExceptions.loggingInRequired() = LoggingInRequired;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.unprocessableEntity(String reason) =
      UnprocessableEntity;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError(String reason) =
      InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError(String? error) =
      UnexpectedError;

  static String? _loggingInRequiredMessage;
  static EmailVerificationChallenge? _emailVerificationChallenge;

  static List<NetworkExceptions> getAllNetworkExceptions() {
    return [
      const NetworkExceptions.badRequest(),
      const NetworkExceptions.unauthorizedRequest(''),
      const NetworkExceptions.conflict(),
      const NetworkExceptions.defaultError(''),
      const NetworkExceptions.formatException(),
      const NetworkExceptions.internalServerError(''),
      const NetworkExceptions.loggingInRequired(),
      const NetworkExceptions.methodNotAllowed(),
      const NetworkExceptions.noInternetConnection(),
      const NetworkExceptions.notFound(''),
      const NetworkExceptions.notAcceptable(),
      const NetworkExceptions.notImplemented(),
      const NetworkExceptions.requestCancelled(),
      const NetworkExceptions.unprocessableEntity(''),
      const NetworkExceptions.unexpectedError(""),
      const NetworkExceptions.unableToProcess(),
      const NetworkExceptions.serviceUnavailable(),
      const NetworkExceptions.sendTimeout(),
    ];
  }

  static NetworkExceptions handleResponse(Response? response) {
    final message = extractBackendErrorMessage(response?.data);
    int statusCode = response?.statusCode ?? 0;

    switch (statusCode) {
      case 400:
        return NetworkExceptions.unprocessableEntity(
          message ?? 'Un Processable Entity',
        );
      // case 400:
      case 401:
        if (_isLoginRequired(response?.data)) {
          return _buildLoggingInRequired(message);
        }
        return NetworkExceptions.unauthorizedRequest(
          message ?? 'Un Authorized Request',
        );
      case 403:
        final challenge = _extractEmailVerificationChallenge(response?.data);
        if (challenge != null) {
          return _buildEmailVerificationRequired(challenge);
        }
        return _buildLoggingInRequired(message);
      case 404:
        return NetworkExceptions.notFound(message ?? 'Not Found');
      case 405:
        return const NetworkExceptions.methodNotAllowed();
      case 409:
        return const NetworkExceptions.conflict();
      case 408:
        return const NetworkExceptions.requestTimeout();
      case 422:
        return NetworkExceptions.unprocessableEntity(
          message ?? 'Un Processable Entity',
        );
      case 429:
        return NetworkExceptions.defaultError(
          message ?? 'Too many requests. Please try again later.',
        );
      case 500:
        return NetworkExceptions.internalServerError(
          message ?? 'Internal Server Error',
        );
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      default:
        var responseCode = statusCode;
        return NetworkExceptions.defaultError(
          message ?? "Received invalid status code: $responseCode",
        );
    }
  }

  static bool _isLoginRequired(dynamic responseData) {
    final data = _decodeResponseData(responseData);
    if (data is! Map) return false;
    final error = data['error'];
    if (error is Map && error['code']?.toString() == 'login_required') {
      return true;
    }
    return data['code']?.toString() == 'login_required';
  }

  static EmailVerificationChallenge? _extractEmailVerificationChallenge(
    dynamic responseData,
  ) {
    final data = _decodeResponseData(responseData);
    if (data is! Map) return null;

    final error = data['error'];
    final errorMap = error is Map ? error : data;
    final code = errorMap['code']?.toString();
    final requiresEmailVerification =
        errorMap['requires_email_verification'] == true;
    if (code != 'email_not_verified' && !requiresEmailVerification) {
      return null;
    }

    final user = errorMap['user'] is Map
        ? Map<String, dynamic>.from(errorMap['user'] as Map)
        : null;
    final otp = errorMap['otp'] is Map
        ? Map<String, dynamic>.from(errorMap['otp'] as Map)
        : const <String, dynamic>{};
    final otpIdentifier = _cleanMessage(otp['identifier']);
    final userEmail = _cleanMessage(user?['email']);
    final identifier = otpIdentifier ?? userEmail ?? '';

    return EmailVerificationChallenge(
      identifier: identifier,
      email: userEmail ?? otpIdentifier,
      purpose: otp['purpose']?.toString() ?? 'email_verification',
      expiresIn: int.tryParse(otp['expires_in']?.toString() ?? '') ?? 300,
      user: user,
      message: extractBackendErrorMessage(data),
    );
  }

  static NetworkExceptions _buildLoggingInRequired(String? message) {
    _loggingInRequiredMessage = _cleanMessage(message);
    return const NetworkExceptions.loggingInRequired();
  }

  static NetworkExceptions buildEmailVerificationRequired(
    EmailVerificationChallenge challenge,
  ) {
    return _buildEmailVerificationRequired(challenge);
  }

  static EmailVerificationChallenge? takeEmailVerificationChallenge(
    NetworkExceptions exception,
  ) {
    final challenge = _emailVerificationChallenge;
    if (challenge == null) return null;
    _emailVerificationChallenge = null;
    return challenge;
  }

  static NetworkExceptions _buildEmailVerificationRequired(
    EmailVerificationChallenge challenge,
  ) {
    _emailVerificationChallenge = challenge;
    return NetworkExceptions.defaultError(
      challenge.message ?? 'Email verification required',
    );
  }

  static String? extractBackendErrorMessage(dynamic responseData) {
    final data = _decodeResponseData(responseData);

    if (data is Map) {
      final validationMessage = _extractValidationMessage(data['errors']);
      if (validationMessage != null) return validationMessage;

      final message = _cleanMessage(data['message']);
      if (message != null) return message;

      final errorMessage = extractBackendErrorMessage(data['error']);
      if (errorMessage != null) return errorMessage;

      final details = _cleanMessage(data['details'] ?? data['detail']);
      if (details != null) return details;

      return _extractValidationMessage(data['messages']);
    }

    if (data is List) {
      return _extractValidationMessage(data);
    }

    return _cleanMessage(data);
  }

  static dynamic _decodeResponseData(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is Map || responseData is List) return responseData;

    final text = responseData.toString().trim();
    if (text.isEmpty) return null;

    try {
      return jsonDecode(text);
    } catch (_) {
      return text;
    }
  }

  static String? _extractValidationMessage(dynamic errors) {
    if (errors == null) return null;

    if (errors is Map) {
      for (final value in errors.values) {
        final message = _extractValidationMessage(value);
        if (message != null) return message;
      }
      return null;
    }

    if (errors is Iterable) {
      for (final value in errors) {
        final message = _extractValidationMessage(value);
        if (message != null) return message;
      }
      return null;
    }

    return _cleanMessage(errors);
  }

  static String? _cleanMessage(dynamic value) {
    final message = value?.toString().trim();
    if (message == null || message.isEmpty || message == 'null') return null;
    return message;
  }

  static NetworkExceptions getException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;

        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.transformTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              networkExceptions = NetworkExceptions.handleResponse(
                error.response,
              );
              break;

            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.connectionError:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions = const NetworkExceptions.methodNotAllowed();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
          // } else if (error is FirebaseAuthException) {
          //   networkExceptions =
          //       NetworkExceptions.firebaseAuthException(error.message!);
          // } else if (error is FirebaseException) {
          //   networkExceptions =
          //       NetworkExceptions.firebaseException(error.message!);
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError(null);
        }
        return networkExceptions;
      } on FormatException {
        return const NetworkExceptions.formatException();
      } catch (_) {
        return const NetworkExceptions.unexpectedError(null);
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError(null);
      }
    }
  }

  static String getErrorMessage(NetworkExceptions? networkExceptions) {
    //  return getErrorMessageTr(networkExceptions);
    var errorMessage = "";
    networkExceptions?.whenOrNull(
          notImplemented: () {
            errorMessage = tr('network.not_implemented');
          },
          requestCancelled: () {
            errorMessage = tr('network.request_cancelled');
          },
          loggingInRequired: () {
            errorMessage =
                _loggingInRequiredMessage ?? tr('network.unauthorized_request');
            _loggingInRequiredMessage = null;
            // errorMessage = "Log in First";
          },
          internalServerError: (String reason) {
            errorMessage = reason;
            // errorMessage = "Internal Server Error";
          },
          notFound: (String reason) {
            errorMessage = reason;
          },
          serviceUnavailable: () {
            errorMessage = tr('network.service_unavailable');
          },
          methodNotAllowed: () {
            errorMessage = tr('network.method_not_allowed');
          },
          badRequest: () {
            errorMessage = tr('network.bad_request');
          },
          unauthorizedRequest: (String error) {
            errorMessage = error;
          },
          unprocessableEntity: (String error) {
            errorMessage = error;
          },
          unexpectedError: (String? error) {
            errorMessage = error ?? tr('network.unexpected_error');
          },
          requestTimeout: () {
            errorMessage = tr('network.request_timeout');
          },
          noInternetConnection: () {
            errorMessage = tr('network.no_internet_connection');
          },
          conflict: () {
            errorMessage = tr('network.conflict');
          },
          sendTimeout: () {
            errorMessage = tr('network.send_timeout');
          },
          unableToProcess: () {
            errorMessage = tr('network.unable_to_process');
          },
          defaultError: (String error) {
            errorMessage = error;
          },
          formatException: () {
            errorMessage = tr('network.unexpected_error');
          },
          notAcceptable: () {
            errorMessage = tr('network.not_acceptable');
          },
          // firebaseAuthException: (String message) {
          //   errorMessage = message;
          // },
          // firebaseException: (String message) {
          //   errorMessage = message;
          // },
        ) ??
        '';
    return errorMessage;
  }

  //
  // static String getErrorMessageTr(NetworkExceptions networkExceptions) {
  //   var errorMessage = "";
  //
  //   networkExceptions.when(
  //     notImplemented: () {
  //       errorMessage = tr(LocaleKeys.network_exceptions_not_implemented);
  //     },
  //     requestCancelled: () {
  //       errorMessage = tr(LocaleKeys.network_exceptions_request_cancelled);
  //     },
  //     loggingInRequired: () {
  //       errorMessage = tr(LocaleKeys.network_exceptions_logging_in_required);
  //     },
  //     internalServerError: () {
  //       errorMessage = tr(LocaleKeys.network_exceptions_internal_server_error);
  //     },
  //     notFound: (String reason) {
  //       errorMessage = reason;
  //       if (reason.toLowerCase().contains("not found"))
  //         errorMessage = tr(LocaleKeys.network_exceptions_not_found);
  //     },
  //     serviceUnavailable: () {
  //       errorMessage = errorMessage =
  //           tr(LocaleKeys.network_exceptions_service_unavailable);
  //     },
  //     methodNotAllowed: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_method_not_allowed);
  //     },
  //     badRequest: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_bad_request);
  //     },
  //     unauthorizedRequest: (String error) {
  //       errorMessage = error;
  //       if (error.toLowerCase().contains("unauthorized request"))
  //         errorMessage = tr(LocaleKeys.network_exceptions_unauthorized_request);
  //     },
  //     unprocessableEntity: (String error) {
  //       errorMessage = error;
  //       if (error.toLowerCase().contains("unprocessable entity"))
  //         errorMessage = tr(LocaleKeys.network_exceptions_unprocessable_entity);
  //     },
  //     unexpectedError: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_unexpected_error);
  //     },
  //     requestTimeout: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_request_timeout);
  //     },
  //     noInternetConnection: () {
  //       errorMessage  =
  //           tr(LocaleKeys.network_exceptions_no_internet_connection);
  //     },
  //     conflict: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_conflict);
  //     },
  //     sendTimeout: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_send_timeout);
  //     },
  //     unableToProcess: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_unable_to_process);
  //     },
  //     defaultError: (String error) {
  //       errorMessage = error;
  //       if (error.toLowerCase().contains("default error"))
  //         errorMessage = tr(LocaleKeys.network_exceptions_default_error);
  //     },
  //     formatException: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_format_exception);
  //     },
  //     notAcceptable: () {
  //       errorMessage =
  //           errorMessage = tr(LocaleKeys.network_exceptions_not_acceptable);
  //     },
  //     // firebaseAuthException: (String message) {
  //     //   errorMessage = message;
  //     // },
  //     // firebaseException: (String message) {
  //     //   errorMessage = message;
  //     // },
  //   );
  //   return errorMessage;
  // }
}
