import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pump_progress_frontend/flavors.dart';
import 'package:pump_progress_frontend/utils/helpers/global_bloc_observer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    // log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = GlobalObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await runZonedGuarded(
  //   () async => runApp(await builder()),
  //   (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  // );

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://81c58da756449805f48d4cea7ed19ba8@o4509293403635712.ingest.us.sentry.io/4509297944756224';
      // Adds request headers and IP for users,
      // visit: https://docs.sentry.io/platforms/dart/data-management/data-collected/ for more info
      options.sendDefaultPii = true;
      options.environment = F.name;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () async => runApp(
      SentryWidget(
        child: await builder(),
      ),
    ),
  );
}
