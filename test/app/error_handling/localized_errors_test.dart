import 'dart:io';

import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/widgets_Informative/error_view.dart';
import 'package:clinc_app_t1/app/domain/error_handler/message.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/generated/codegen_loader.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void loadLocale(String language) {
  Localization.load(
    Locale(language),
    translations: Translations(CodegenLoader.mapLocales[language]!),
  );
}

Widget app(Widget child) => ScreenUtilInit(
  designSize: const Size(390, 844),
  builder: (_, __) => MaterialApp(
    localizationsDelegates: const [_TestLocalizationDelegate()],
    home: Scaffold(body: child),
  ),
);

class _TestLocalizationDelegate extends LocalizationsDelegate<Localization> {
  const _TestLocalizationDelegate();
  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<Localization> load(Locale locale) =>
      SynchronousFuture(Localization.instance);
  @override
  bool shouldReload(_TestLocalizationDelegate old) => false;
}

void main() {
  for (final language in ['ar', 'en']) {
    group(language, () {
      setUp(() => loadLocale(language));

      test('backend messages and codes use the selected language', () {
        for (final message in [
          'Invalid credentials.',
          'invalid email or password',
          'network.invalid_credentials',
        ]) {
          expect(
            MessageApi.localizeError(message),
            tr('network.invalid_credentials'),
          );
        }
        expect(
          MessageApi.localizeError('Internal Server Error'),
          tr('network.internal_server_error'),
        );
        expect(
          MessageApi.localizeError('no_internet_connection'),
          tr('network.no_internet_connection'),
        );
        expect(MessageApi.localizeError(null), tr('network.unexpected_error'));
      });

      test('foreign unknown errors use a translated fallback', () {
        final message = language == 'ar'
            ? 'Unmapped backend failure'
            : 'خطأ غير معروف من الخادم';
        expect(
          MessageApi.localizeError(message),
          tr('network.unexpected_error'),
        );
      });

      test('localized backend validation detail is preserved', () {
        final message = language == 'ar'
            ? 'هذا الموعد غير متاح للحجز'
            : 'This appointment cannot be booked';
        expect(MessageApi.localizeError(message), message);
      });

      test('connection failures retain their type and translated message', () {
        for (final error in [
          const SocketException('offline'),
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionError,
          ),
          DioException(
            requestOptions: RequestOptions(),
            error: const SocketException('offline'),
          ),
          const NetworkExceptions.noInternetConnection(),
        ]) {
          final exception = NetworkExceptions.getException(error);
          expect(exception, isA<NoInternetConnection>());
          expect(
            NetworkExceptions.getErrorMessage(exception),
            tr('network.no_internet_connection'),
          );
        }
        expect(
          NetworkExceptions.getException(
            DioException(
              requestOptions: RequestOptions(),
              error: StateError('bad data'),
            ),
          ),
          isA<UnexpectedError>(),
        );
      });

      testWidgets(
        'offline state replaces empty copy and retry returns to empty state',
        (tester) async {
          var retries = 0;
          await tester.pumpWidget(
            app(
              SharedEmptyWidget(
                title: 'Empty data',
                subtitle: 'No results',
                error: const NetworkExceptions.noInternetConnection(),
                onRetry: () => retries++,
              ),
            ),
          );
          expect(
            find.text(tr('network.no_internet_connection')),
            findsOneWidget,
          );
          expect(find.text('Empty data'), findsNothing);
          expect(find.text('No results'), findsNothing);
          expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
          await tester.tap(find.text(tr('network.retry')));
          expect(retries, 1);
          await tester.pumpWidget(
            app(const SharedEmptyWidget(title: 'Empty data')),
          );
          expect(find.text('Empty data'), findsOneWidget);
          expect(find.byIcon(Icons.wifi_off_outlined), findsNothing);
        },
      );

      testWidgets('network error takes precedence over empty flag', (
        tester,
      ) async {
        await tester.pumpWidget(
          app(
            const ErrorView(
              isEmptyState: true,
              networkExceptions: NetworkExceptions.noInternetConnection(),
            ),
          ),
        );
        expect(find.text(tr('network.no_internet_connection')), findsOneWidget);
        expect(find.text(tr('search.no_results')), findsNothing);
      });
    });
  }
}
