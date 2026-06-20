import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/error_event_bus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class ErrorStatus {
  final String errorMsg;
  final DateTime timestamp;
  ErrorStatus(this.errorMsg) : timestamp = DateTime.now();
}

Future<void> runSafeEvent(
  Emitter emit,
  dynamic Function() getState,
  Function(String) errorStatus,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (e, stackTrace) {
    AppLogger.error(
      'Error in runSafeEvent: $e',
      stackTrace: stackTrace,
      error: e,
    );
    ErrorEventBus.emitError(e.toString());
    emit(getState().copyWith(
      status: errorStatus(e.toString()),
    ));
    await Sentry.captureException(e, stackTrace: stackTrace);
  }
}
