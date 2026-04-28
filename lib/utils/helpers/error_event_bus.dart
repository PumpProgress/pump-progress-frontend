import 'dart:async';

class ErrorEventBus {
  static final _controller = StreamController<String>.broadcast();

  static Stream<String> get stream => _controller.stream;

  static void emitError(String message) {
    _controller.add(message);
  }
}
