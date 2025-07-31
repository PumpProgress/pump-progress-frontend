import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pump_progress_frontend/utils/helpers/global_bloc_observer.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = GlobalObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Try to initialize Sentry with better error handling
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://81c58da756449805f48d4cea7ed19ba8@o4509293403635712.ingest.us.sentry.io/4509297944756224';
  //     options.sendDefaultPii = true;
  //     options.environment = F.name;
  //     options.tracesSampleRate = 1.0;
  //     options.profilesSampleRate = 1.0;
  //     options.debug = true;
  //     // Add some additional safety options
  //     options.captureFailedRequests = false;
  //     options.autoInitializeNativeSdk = true;
  //   },
  //   appRunner: () async {
  //     try {
  //       runApp(
  //         SentryWidget(
  //           child: await builder(),
  //         ),
  //       );
  //     } catch (e) {
  //       print('Error running app with Sentry widget: $e');
  //       runApp(await builder());
  //     }
  //   },
  // );
  runApp(await builder());
}
