import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

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
        return NetworkExceptions.unauthorizedRequest(
          message ?? 'Un Authorized Request',
        );
      case 403:
        return const NetworkExceptions.loggingInRequired();
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
      case 500:
        return NetworkExceptions.internalServerError(
          message ?? 'Internal Server Error',
        );
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      default:
        var responseCode = statusCode;
        return NetworkExceptions.defaultError(
          "Received invalid status code: $responseCode",
        );
    }
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
          print("type: ${error.type}");
          print("message: ${error.message}");
          print('response ${error.response}');

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
    print(networkExceptions.runtimeType);
    networkExceptions?.whenOrNull(
          notImplemented: () {
            errorMessage = "Not Implemented";
          },
          requestCancelled: () {
            errorMessage = "Request Cancelled";
          },
          loggingInRequired: () {
            errorMessage = "Un Authorized Request";
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
            errorMessage = "Service unavailable";
          },
          methodNotAllowed: () {
            errorMessage = "Method Not Allowed";
          },
          badRequest: () {
            errorMessage = "Bad request";
          },
          unauthorizedRequest: (String error) {
            errorMessage = error;
          },
          unprocessableEntity: (String error) {
            errorMessage = error;
          },
          unexpectedError: (String? error) {
            errorMessage = error ?? "Unexpected error occurred";
          },
          requestTimeout: () {
            errorMessage = 'request_timeout'.tr;
          },
          noInternetConnection: () {
            errorMessage = 'no_internet_connection'.tr;
          },
          conflict: () {
            errorMessage = "Error due to a conflict";
          },
          sendTimeout: () {
            errorMessage = 'send_timeout'.tr;
          },
          unableToProcess: () {
            errorMessage = "Unable to process the data";
          },
          defaultError: (String error) {
            errorMessage = error;
          },
          formatException: () {
            errorMessage = "Unexpected error occurred";
          },
          notAcceptable: () {
            errorMessage = "Not acceptable";
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
